# frozen_string_literal: true

module V2
  class API < Grape::API
    version 'v2', using: :path do
      format :json
      content_type :json, 'application/json'

      desc 'Returns data according to the CSS selectors from the specified URL'
      params do
        requires :url,
                 type: String,
                 allow_blank: false,
                 desc: 'The URL of the page from which to download and parse the data.'
        group :fields, type: Array, desc: 'The hash of the fields to be parsed.' do
          requires :name, type: String, desc: 'The name of variable.'
          requires :selector, type: String, desc: 'The selector value.'
          optional :selector_kind,
                   type: String,
                   default: 'css',
                   values: %w[css xpath],
                   desc: 'The kind of selector. Possible values: css, xpath'
        end
        optional :meta,
                 type: [String],
                 values: %w[keywords twitter:image],
                 desc: 'The array of the fields to be parsed from meta tags.'
      end
      post :data do
        # return declared(params)

        interactor = ScrapAndParse::V2::Organizer.call(params: declared(params))
        if interactor.success?
          status 200
          interactor.result
        else
          error!(interactor.message, :bad_request)
        end
      end
    end
  end
end
