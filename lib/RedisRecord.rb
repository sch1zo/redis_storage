require 'json'

module RedisRecord
  require 'RedisRecord/railtie' if defined?(Rails)
#  module Rails
#    class Railtie < ::Rails::Railtie
#      if ::Rails.version.to_f >= 3.1
#        config.app_generators.orm :redis
#      else
#        config.generators.orm :redis
#      end
#    end
#  end

  class Model
    def self.attrs
      [:id]
    end
    def attrs
      self.class.attrs.inject({}) do |a,key|
        a[key] = send(key)
        a
      end
    end
    attr_accessor *attrs

    def initialize(params={})
      params.each do |key, value|
        send("#{key}=", value)
      end
    end

    def self.build(params)
      new params
    end

    def self.create(params)
      obj = new params
      obj.save
      obj
    end

    def self.find_by_id(id)
      new JSON.parse($db.get("#{db_key}:#{id}"))
    end

    def save
      $db.set db_key, attrs.to_json
    end

    def self.db_key
      raise NotImplementedError
    end
    def db_key
      "#{self.class.db_key}:#{self.id}"
    end
  end
end