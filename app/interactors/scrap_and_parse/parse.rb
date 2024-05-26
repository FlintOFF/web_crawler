# frozen_string_literal: true

module ScrapAndParse
  class Parse
    include Interactor

    def call
      context.result ||= {}
      context.result.merge!(parse_css_fields)
      context.result.merge!(parse_meta_fields)
    end

    private

    def parse_css_fields
      out = {}

      css_fields.each do |name, css_selector|
        out[name] = parse(css_selector)
      end

      out
    end

    def parse_meta_fields
      return {} unless meta_fields

      out = {}

      meta_fields.each do |name|
        out[name] = parse("meta[name='#{name}']", meta_tag: true)
      end

      { meta: out }
    end

    def parse(css_selector, meta_tag: false)
      @doc ||= Nokogiri::HTML(context.content)

      if meta_tag
        @doc.css(css_selector).first&.attribute('content')&.text
      else
        @doc.css(css_selector).first&.text
      end
    rescue Nokogiri::CSS::SyntaxError
      context.fail!(message: I18n.t('interactors.errors.css_syntax'))
    end

    def css_fields
      @css_fields ||= context.params[:fields].except('meta')
    end

    def meta_fields
      @meta_fields ||= context.params[:fields].select { |k, _v| k == 'meta' }[:meta]
    end
  end
end
