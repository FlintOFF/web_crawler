# frozen_string_literal: true

class API < Grape::API
  format :json
  content_type :json, 'application/json'

  mount V1::API
  mount V2::API
end
