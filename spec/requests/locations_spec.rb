require 'rails_helper'

RSpec.describe 'Locations API', type: :request do
  # initialize test data
  let!(:locations) { create_list(:location, 10) }
  let(:location_id) { locations.first.id }
  let!(:location1) { FactoryGirl.create(:location, ip_address: '11.11.11.11', city: 'delhi', country: 'india', country_code: 'IN', latitude: 111.12, longitude: 232.88 ) }
  let!(:location2) { FactoryGirl.create(:location, ip_address: '11.11.11.12', city: 'delhi', country: 'india', country_code: 'IN', latitude: 112.12, longitude: 232.88 ) }

  # Test suite for GET /locations
  describe 'GET /locations' do
    # make HTTP get request before each example
    before { get '/locations' }

    it 'returns locations' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(12)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /locations/:id
  describe 'GET /locations/:id' do
    before { get "/locations/#{location_id}" }

    context 'when the record exists' do
      it 'returns the location' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(location_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:location_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find GeoLocation::Location/)
      end
    end
  end

  # Test suite for POST /locations
  describe 'POST /locations' do
    # valid payload
    let(:valid_attributes) { { ip_address: '10.10.10.10', city: 'delhi', country: 'india', country_code: 'IN', latitude: 111.12, longitude: 231.88 } }

    context 'when the request is valid' do
      before { post '/locations', params: valid_attributes }

      it 'creates a location' do
        expect(json['ip_address']).to eq('10.10.10.10')
        expect(json['city']).to eq('delhi')
        expect(json['country']).to eq('india')
        expect(json['latitude']).to eq('111.12')
        expect(json['longitude']).to eq('231.88')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/locations', params: { ip_address: '10.10.10.12' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed:.*City can't be blank/)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed:.*Country can't be blank/)
      end
    end
  end

  # Test suite for PUT /locations/:id
  describe 'PUT /locations/:id' do
    let(:valid_attributes) { { city: 'new delhi' } }

    context 'when the record exists' do
      before { put "/locations/#{location_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /locations/:id
  describe 'DELETE /locations/:id' do
    before { delete "/locations/#{location_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  # Test suite for GET /locations/search
  describe 'GET /search' do

    # context 'when search query is not provided' do
    #   before { get '/search' }
    #   it 'returns status code 200' do
    #     expect(response).to have_http_status(200)
    #   end
    #
    #   it 'returns status code 200' do
    #     expect(json).to be_empty
    #   end
    # end

    context 'when city is passed in search query' do
      before { get '/search', params: { q: 'delhi' } }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns list of locations with city delhi' do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end
    end

    context 'when ip address is passed in search query' do
      before { get '/search?q=11.11.11.12' }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns list of locations with ip 11.11.11.12' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
        expect(json.first['ip_address']).to eq('11.11.11.12')
      end
    end

    context 'when ip address is passed in search query which is not available' do
      before { get '/search?q=11.11.11.112' }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns empty array' do
        expect(json).to be_empty
      end
    end

    context 'when valid country is provided' do
      before { get '/search?q=india' }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns array of location with india as country' do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end
    end

    context 'when valid latitude and longitude is provided' do
      before { get '/search?q=111.12,232.88' }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns array of location with india as country' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
        expect(json.first['latitude']).to eq('111.12')
        expect(json.first['longitude']).to eq('232.88')
      end
    end
  end
end