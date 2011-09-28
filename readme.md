RedisStorage
---

This is a little gem which provides a redis interface for models. It works out of the box with rails or can be used standalone.

Basically I just got sick rewriting the same logic over and over again for each model of my little sinatra apps so this evolved. Then I wanted to write a new rails app an thought having this in a gem would be really nice, and a generator would be awesome.
Now I will add new Feature as I need them. You also can let me know what to add.

[![Build Status](https://secure.travis-ci.org/sch1zo/redis_storage.png)](http://travis-ci.org/sch1zo/redis_storage)

Features
---

* stores the attributes_hash of the model as JSON in redis
* creates an index of all used ids(which will be set automatically)
* compatible with the default rails controller
* uses ActiveModel to provide things like validations
* provides a Rails 3 Generator
* indexing of choosen attributes and find_by

Roadmap aka. ToDo
---

* perhaps use some stuff from redis-scripting to make more methods atomic (like find_by or update_attributes)
* some wrappers for searching in a model(probably will need some indexes)
* perhaps some kind of dirty flag - or the ActiveModel::Dirty module, but that will make some things way more complicated
* more tests/specs are always good

Newest Stuff
---

* indexing for choosen attributes
* new find_by :attr

Installation
---

As this gem need redis running you will have to install it(see redis.io for more information on that task)

Then just add the gem to your Gemfile and run bundler

    gem 'redis_storage'

or just install it manually

    gem install redis_storage

Then this gem will need a global object $db which just is a Redis connection.

    redis_config = { :host => 'localhost', :port => 6379, :password => '', :db => 1 }
    $db = Redis.new(redis_config)

Usage
---

require the gem in your code

    require 'redis_storage'

create a model which inherit from RedisStorage::Model

    class MyModel < RedisStorage::Model
    ...
    end

and define the models attributes via self.attrs, additional to the defined attributes there will always be an attribute id

    def self.attrs
      [:body, :title]
    end
    attr_accessor *attrs

Minimal Example
---

    require 'redis_storage'
    class MyModel < RedisStorage::Model
      def self.attrs
        [:body, :title]
      end
      attr_accessor *attrs
    end

Indexing and find_by
---

If you want or need to find records based on a attribute you have to add it to the index_for array like this.

    def self.index_for
      [:some, :attributes, :to, :index]
    end

The elements should be symbols and have to also be element of attrs.
After that you can use the following to get the the instance.

    MyModel.find_by :key, "search"

Also I should mention that you should update record only via the update_attributes method, otherwise the indexes will become corrupt.

Rails 3 Integration
---

to initialize redis there is a rake task

    rake install_redis

The task will install a initializer file which creates the above mentioned $db object and a redis.yml file to configure the redis connection.

There is also a Rails 3 Generator which will generates the above mentioned model

    rails g redis model attr1 attr2

or

    rails g scaffold model attr1:string attr2:int -o redis

meta
---

Tested with RSpec and testunit for the generator for
* ree-1.8.7-2011.03
* MRI 1.9.2
* rbx
* rbx-2.0.0pre
* ruby-1.9.3-preview1

Inspired by

* some ideas from the redis backend in [scanty-redis](https://github.com/adamwiggins/scanty-redis)
* various small sinatra projects from myself which use a pre version of this gem

sch1zo