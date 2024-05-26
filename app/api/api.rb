require 'grape-swagger'

class API < Grape::API
  format :json
  content_type :json, 'application/json'

  desc 'Returns data according to the CSS selectors from the specified URL'
  params do
    requires :url, type: String, allow_blank: false, desc: 'The URL of the page from which to download and parse the data.'
    requires :fields, type: Hash, desc: 'The hash of the fields to be parsed.'

    # requires :fields, type: Hash, desc: 'The hash of the fields to be parsed.' do
    #   optional :meta,
    #            type: Array[String],
    #            values: %w[keywords twitter:image],
    #            desc: 'The array of the fields to be parsed from meta tags.'
    # end
  end
  post :data do
    interactor = ScrapAndParse::Organizer.call(params: declared(params))
    if interactor.success?
      status 200
      interactor.result
    else
      error!(interactor.message, :bad_request)
    end
  end
end
