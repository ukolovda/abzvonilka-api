require 'test_helper'

class Obzvonilka::AsteriskTest < Minitest::Test

  MASTER_ROW = {:accountcode => '', :lastdata=> 'SIP/89659014949@3912902926,,', :end=> '2015-12-23 07:57:13',
                :dcontet=> 'outgoingmind', :billsec => '8', :start=> '2015-12-23 07:56:55',
                :clid=>'"Виктория Громова" <83912902926>', :dst => '89659014949', :disposition=> 'ANSWERED',
                :channel=> 'SIP/211-0000ce14', :amaflags=> 'DOCUMENTATION', :dstchannel => 'SIP/3912902926-0000ce15',
                :astid=> '1450857416.80700', :duration=>"16", :answer=> '2015-12-23 07:57:04', :lastapp => 'Dial',
                :src=> '83912902926'}
  MASTER_LINE = '"","83912902926","89659014949","outgoingmind","""Виктория Громова"" <83912902926>","SIP/211-0000ce14","SIP/3912902926-0000ce15","Dial","SIP/89659014949@3912902926,,","2015-12-23 07:56:55","2015-12-23 07:57:04","2015-12-23 07:57:13",16,8,"ANSWERED","DOCUMENTATION","1450857416.80700",""'

  def test_parse_cdr_row
    row = Obzvonilka::Asterisk::Voice.parse_cdr_row(MASTER_LINE)
    assert_equal MASTER_ROW, row
  end

  def test_make_standard_mask
    assert_equal '/var/spool/asterisk/monitor/2015/12/23/*-1450857416.80700.*',
                 Obzvonilka::Asterisk::Voice.make_voice_file_mask(MASTER_ROW, Obzvonilka::Asterisk::Voice::FILE_PATH_TEMPLATE)
  end

  def test_make_custom_mask
    template = '/records/mind/2xx/outgoing/%H-%M_%Y-%m-%d-*-%ad.*'
    assert_equal '/records/mind/2xx/outgoing/11-56_2015-12-23-*-89659014949.*',
                 Obzvonilka::Asterisk::Voice.make_voice_file_mask(MASTER_ROW, template)
  end

  def test_process_template
=begin
   %a - The abbreviated weekday name (``Sun'')
%A - The full weekday name (``Sunday'')
%b - The abbreviated month name (``Jan'')
%B - The full month name (``January'')
%c - The preferred local date and time representation
%d - Day of the month (01..31)
%H - Hour of the day, 24-hour clock (00..23)
%I - Hour of the day, 12-hour clock (01..12)
%j - Day of the year (001..366)
%m - Month of the year (01..12)
%M - Minute of the hour (00..59)
%p - Meridian indicator (``AM'' or ``PM'')
%S - Second of the minute (00..60)
%U - Week number of the current year,            starting with the first Sunday as the first            day of the first week (00..53)
%W - Week number of the current year,            starting with the first Monday as the first            day of the first week (00..53)
%w - Day of the week (Sunday is 0, 0..6)
%x - Preferred representation for the date alone, no time
%X - Preferred representation for the time alone, no date
%y - Year without a century (00..99)
%Y - Year with century
%Z - Time zone name
%% - Literal
``%'' character
=end
    template = '/dir/%Y/%m/%d/%H-%M-%S-%ai-%as-%ad.wav'
    assert_equal '/dir/2015/12/23/11-56-55-1450857416.80700-83912902926-89659014949.wav',
                 Obzvonilka::Asterisk::Voice.process_template(MASTER_ROW, template)
  end

  class TestVoice < Obzvonilka::Asterisk::Voice
    def self.each_cdr_lines
      yield MASTER_LINE
    end
  end

  def test_read_cdr_rows
    TestVoice.read_cdr_rows do |row|
      assert_equal MASTER_ROW, row
    end
  end

  def test_send_voices
    Dir.stub :[], ['123'] do
    # Obzvonilka::Asterisk::Voice.stub :check_file_exists, '123' do
      Obzvonilka::Asterisk::Voice.stub :send_voice, true do
        TestVoice.send_voices
      end
    end
  end
end
