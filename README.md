# Obzvonilka::Api

Предназначен для интеграции сервиса Obzvonilka с другими системами (Asterisk и другие).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'obzvonilka-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obzvonilka-api

## Usage

Для интеграции с Asterisk нужно запустить скрипт:

    $ OBZVONILKA_API_KEY=1234567890 ruby -e "require 'rubygems'; require 'obzvonilka/api'; Obzvonilka::Asterisk::Voice.send_voices"

Значение параметра OBZVONILKA_API_KEY получаете в настройках профила на вкладке "Организации".

Другие возможные параметры, задаваемые переменными окружения:

|           Название           |         Описание                                  | Значение по умолчанию                |
|------------------------------|---------------------------------------------------|--------------------------------------|
| ASTERISK_CDR_CSV_PATH        | Путь к файлу CDR.                                 | /var/log/asterisk/cdr-csv/Master.csv |
| ASTERISK_VOICE_FILES_DIR     | Путь к звуковым файлам.                           | /var/spool/asterisk/monitor          |
| ASTERISK_VOICE_PATH_TEMPLATE | Шаблон для формирования имени звукового файла     | "#{FILES_PATH}/%Y/%m/%d/*-%ai.*"     |
| ASTERISK_CHECK_FILE_COUNT    | Количество старых CDR, обрабатываемых при запуске | 100                                  |


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/obzvonilka-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

