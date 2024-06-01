# frozen_string_literal: true

module ScrapAndParse
  module V2
    class Parse
      include Interactor

      def call
        context.result ||= {}
        context.result.merge!(parse_fields)
        context.result.merge!(parse_meta_fields)
      end

      private

      def parse_fields
        context.params[:fields].to_h do |hsh|
          [hsh[:name], parse(hsh[:selector], kind: hsh[:selector_kind])]
        end
      end

      def parse_meta_fields
        return {} unless context.params[:meta]

        out = {}

        context.params[:meta].each do |name|
          out[name] = parse("meta[name='#{name}']", meta_tag: true)
        end

        { meta: out }
      end

      def parse(selector, kind: 'css', meta_tag: false)
        @doc ||= Nokogiri::HTML(context.content)

        if kind == 'css'
          meta_tag ? @doc.css(selector).first&.attribute('content')&.text : @doc.css(selector).first&.text
        else
          @doc.xpath(selector).first.text
        end
      rescue Nokogiri::CSS::SyntaxError
        context.fail!(message: I18n.t('interactors.errors.css_syntax'))
      end
    end
  end
end
