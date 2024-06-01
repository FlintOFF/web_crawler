# frozen_string_literal: true

require 'open-uri'
require 'redis'

module ScrapAndParse
  class Scrap
    include Interactor

    REDIS_HOST = 'localhost'
    CACHE_DIR = 'tmp'
    CACHE_TTL = 10 # seconds

    def call
      cache_record_hsh = read_cache_record
      if cache_record_hsh.present? && cache_record_valid?(cache_record_hsh)
        context.content = read_content_from_cache
      else
        context.content = read_content_from_source
        write_content_to_cache
        write_cache_record
      end
    end

    private

    def redis
      @redis ||= Redis.new(host: REDIS_HOST)
    end

    def read_content_from_source
      response = Faraday.get(context.params[:url])
      context.fail!(message: I18n.t('interactors.errors.page_load')) unless response.status == 200
      response.body
    rescue NoMethodError
      context.fail!(message: I18n.t('interactors.errors.invalid_url'))
    end

    def read_content_from_cache
      File.read(file_path)
    end

    def write_content_to_cache
      File.write(file_path, context.content)
    end

    def read_cache_record
      json = redis.get(context.params[:url])
      json ? JSON.parse(json, symbolize_names: true) : nil
    end

    def write_cache_record
      redis.set(context.params[:url], { file_path:, expire_at: Time.now.to_i + CACHE_TTL }.to_json)
    end

    def cache_record_valid?(cache_record_hsh)
      return false unless cache_record_hsh[:expire_at]

      cache_record_hsh[:expire_at] > Time.now.to_i
    end

    def file_name
      @file_name ||= ActiveStorage::Filename.new(context.params[:url]).sanitized
    end

    def file_path
      Rails.root.join(CACHE_DIR, file_name)
    end
  end
end
