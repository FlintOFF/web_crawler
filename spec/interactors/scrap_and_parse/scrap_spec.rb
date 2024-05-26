require 'rails_helper'

RSpec.describe ScrapAndParse::Scrap do
  let(:params) { { url: params_url } }
  let(:params_url) { "https://www.google.com/search?q=#{Time.now.to_i}" }
  let(:dummy_struct) { Struct.new(:body, :status) }
  let(:dummy_body) { '<html></html>' }
  let(:dummy_status) { 200 }

  it 'returns the same content twice and make only one real request' do
    allow(Faraday).to receive(:get).and_return(dummy_struct.new(dummy_body, dummy_status))
    first_body = described_class.call(params: params).content
    second_body = described_class.call(params: params).content
    expect(Faraday).to have_received(:get).once
    expect(first_body).to eq dummy_body
    expect(first_body).to eq second_body
  end
end
