# Cws3chk

This gem checks the existance on S3 of the assets described by ActiveRecord
and Carrierwave.

* It loads the ids of the object with assets in a task and splits them into 
  groups. Each group is going to be processed by a Resque Job.
* It studies the groups of object by launching n threads. It checks for the
  existence of the original file and the different versions.
* It stores the result of the check in Redis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'Cws3chk'
```

And then execute:

    $ bundle

## Usage

    $ bundle exec rake Cws3chk:check
or

```ruby
request = User.with_avatar
Cws3chk::Checker.new(request, :avatar, 250).check
```
Then study your missig assets and fix them if needed:
```ruby
redis.smembers 'Cws3chk::missing'
```
You can also study the size of the resulting assets:
```ruby
redis.smembers 'Cws3chk::metadata'
```
