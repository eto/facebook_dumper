# FacebookDumper

FacebookDumperは、Facebookの保存されたWebページを解析して、テキストとしてダンプするプログラムです。
現在は、友達リストをダンプすることができます。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'facebook_dumper'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install facebook_dumper

## Usage

- Facebookの友達リストのページを開きます。
https://www.facebook.com/【あなたのID】/friends

- たくさん友達がいる場合は、スクロールすると表示が増えます。スペースバーを押し続けると最後まで表示されるので、しばらくスペースバーを押し続けるといいでしょう。
- 全て表示されたら、Webブラウザから、「ファイル」→「名前を付けてページを保存…」を選び、ファイルとして保存します。
- 以下のように、そのHTMLファイルを指定して、facebook_dumperを起動します。引数に、ファイルを指定します。

    $ facebook_dumper friends.html

- カレントディレクトリーの`facebook-friends.txt`に、内容が保存されます。

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eto/facebook_dumper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/eto/facebook_dumper/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FacebookDumper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/eto/facebook_dumper/blob/master/CODE_OF_CONDUCT.md).
