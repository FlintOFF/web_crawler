# frozen_string_literal: true

require 'rails_helper'

describe 'API', type: :request do
  context 'GET /data' do
    let(:url) { '/data' }
    let(:params) { { url: params_url, fields: params_fields } }
    let(:params_url) { 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm' }
    let(:params_fields) do
      {
        price: '.price-box__price',
        rating_count: '.ratingCount',
        rating_value: '.ratingValue',
        meta: %w[keywords twitter:image]
      }
    end

    before { post('/data', params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }) }

    context 'when parameters are present and valid' do
      let(:expected_body) do
        {
          'price' => '17 749,-',
          'rating_count' => '8 hodnocení',
          'rating_value' => '4,9',
          'meta' => {
            'keywords' => 'AEG,7000,ProSteam®,LFR73964CC,Automatické ' \
                          'pračky,Automatické pračky AEG,Chytré pračky,Chytré pračky AEG',
            'twitter:image' => 'https://image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360'
          }
        }
      end

      it 'returns correct response' do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq expected_body
      end
    end

    context 'when the CSS selector is invalid' do
      let(:params_fields) { { price: '$price-box__price' } }
      let(:expected_body) { { 'error' => I18n.t('interactors.errors.css_syntax') } }

      it 'returns error' do
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq expected_body
      end
    end

    context 'when the URL is invalid' do
      let(:params_url) { 'httpss://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm' }
      let(:expected_body) { { 'error' => I18n.t('interactors.errors.invalid_url') } }

      it 'returns error' do
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq expected_body
      end
    end

    context 'when the URL is not present' do
      let(:params_url) { 'https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493-11111111111111111.htm' }
      let(:expected_body) { { 'error' => I18n.t('interactors.errors.page_load') } }

      it 'returns error' do
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq expected_body
      end
    end

    context 'when the CSS selector is valid but not present' do
      let(:params_fields) { { price: '.price-box__price_not_present' } }
      let(:expected_body) { { 'price' => nil } }

      it 'returns correct response' do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq expected_body
      end
    end
  end
end
