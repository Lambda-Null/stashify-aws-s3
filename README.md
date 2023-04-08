# Stashify::Aws::S3

This is an implementation of the [Stashify](https://rubydoc.info/gems/stashify) abstraction for AWS S3. It operates under the assumption that the "/" in file names has the typical meaning of a path separater.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stashify-aws-s3'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install stashify-aws-s3

## Usage

This implementation is built on top of an instance of `Aws::S3::Bucket`. The following usage is an abbreviated form to illustrate how to engage in this particular library. For a more extensive example see [Stashify's Usage](https://rubydoc.info/gems/stashify#usage).

```ruby
> require "aws-sdk-s3"
=> true
> s3 = Aws::S3::Resource.new
=> #<Aws::S3::Resource:0x0000558723dad2e8 @client=#<Aws::S3::Client>>
irb(main):005:0> bucket = s3.bucket("some-bucket")
=> 
#<Aws::S3::Bucket:0x0000558723f5a6e0
...
> file.contents
=> "foo"
> require "stashify/directory/aws/s3"
=> true
> dir = Stashify::Directory::AWS::S3.new(bucket: bucket, path: "path/to")
=> 
#<Stashify::Directory::AWS::S3:0x000055872460c628
...
> dir.find("file") == file
=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stashify-aws-s3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/stashify-aws-s3/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stashify::Aws::S3 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stashify-aws-s3/blob/main/CODE_OF_CONDUCT.md).
