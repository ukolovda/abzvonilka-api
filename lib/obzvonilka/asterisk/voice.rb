require 'csv'
require 'date'

module Obzvonilka
  module Asterisk
    class Voice

      # Path to asterisk CDR logs
      LOGS_PATH = ENV['ASTERISK_CDR_CSV_PATH'] || '/var/log/asterisk/cdr-csv/Master.csv'
      # Path to voice files root
      FILES_PATH = ENV['ASTERISK_VOICE_FILES_DIR'] || '/var/spool/asterisk/monitor'

      FILE_PATH_TEMPLATE = ENV['ASTERISK_VOICE_PATH_TEMPLATE'] || "#{FILES_PATH}/%Y/%m/%d/*-%ai.*"

      # Amount of old file, then will be checked
      PREV_FILE_CNT = ENV['ASTERISK_CHECK_FILE_COUNT'] || 100

      # DST field name from Master.csv. Use if real DST wroted in other field (i.e. userfield)
      LOG_FIELD_DST = (ENV['ASTERISK_DST_FIELD_NAME'] || :dst).to_sym

      TAIL_COMMAND = "tail -n #{PREV_FILE_CNT} -F '#{LOGS_PATH}'"

      HEADINGS = [:accountcode, :src, :dst, :dcontet, :clid, :channel, :dstchannel, :lastapp, :lastdata,
                  :start, :answer, :end, :duration, :billsec, :disposition, :amaflags, :astid, :userfield]


      def self.send_voices
        read_cdr_rows do |row|
          file_name = get_voice_file_name(row)
          if file_name
            puts file_name
            send_voice(row, file_name)
          end
        end
      end

      def self.send_voice(row, file_name)
        Obzvonilka::Api::Voice.new.put_voice row[LOG_FIELD_DST], row[:start], row[:end], file_name, row[:astid]
      end

      def self.read_cdr_rows
        each_cdr_lines do |x|
          yield parse_cdr_row(x.chomp)
        end
      end

      def self.each_cdr_lines
        IO.popen(TAIL_COMMAND).each_line { |x| yield x }
      end

      private
      def self.get_voice_file_name(row, template = FILE_PATH_TEMPLATE)
        file_name = make_voice_file_mask(row, template)
        check_file_exists(file_name)
      end

      def self.check_file_exists(file_name)
        Dir[file_name].first
      end

      def self.make_voice_file_mask(row, template)
        process_template(row, template)
        # "#{FILES_PATH}/#{row[:start].gsub(/^(\d\d\d\d)-(\d\d)-(\d\d).*/, '\\1/\\2/\\3')}/*-#{row[:astid]}.*"
      end

      def self.parse_cdr_row(line)
        Hash[HEADINGS.zip(CSV.parse(line).first)]
      end

      # @param [String] template
      # @param [Hash] row
      # @return [String]
      def self.process_template(row, template)
        template.gsub /(%(?:a.|.))/ do |m|
          case m
            when '%ai'
              row[:astid]
            when '%as'
              row[:src]
            when '%ad'
              row[LOG_FIELD_DST]
            else
              row_date(row).strftime(m)
          end
        end
      end

      def self.row_date(row)
        date_time = "#{row[:start]}+00:00"
        utc = DateTime.strptime(date_time, '%Y-%m-%d %H:%M:%S %Z')
        utc.new_offset(DateTime.now.offset)
      end
    end
  end
end
