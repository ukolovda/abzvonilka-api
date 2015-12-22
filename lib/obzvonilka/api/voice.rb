require 'json'
require 'rest-client'

module Obzvonilka
  module Api
    class Voice
      def initialize(api_key = nil)
        @api_key = api_key || ENV['OBZVONILKA_API_KEY']
        @app_host = ENV['OBZVONILKA_APP_HOST'] || 'https://obzvonilka.ru'
      end

      def find_contact(phone, started_at, unique_id)
        JSON.parse RestClient.get("#{@app_host}/api/get_voice_record_info",
                                  :params => {:api_key => @api_key,
                                              :phone_number => phone,
                                              :started_at => started_at,
                                              :unique_id => unique_id
                                  })
      rescue RestClient::ResourceNotFound => e
        return {'code' => 2}
      end

      def upload_file(id, phone_number, started_at, finished_at, file_name, unique_id, call_history_id)
        RestClient.post "#{@app_host}/api/upload_voice_record",
                        :api_key => @api_key,
                        :id => id,
                        :voice_data => {:started_at => started_at,
                                        :finished_at => finished_at,
                                        :phone_number => phone_number,
                                        :data => File.open(file_name),
                                        :unique_id => unique_id,
                                        :call_history_id => call_history_id}
      end

      def put_voice(phone, started_at, finished_at, file_name, unique_id)
        json = find_contact(phone, started_at, unique_id)
        if json['code'].zero?
          upload_file json['id'], phone, started_at, finished_at, file_name, unique_id, json['call_history_id']
        end
      end

    end
  end
end
