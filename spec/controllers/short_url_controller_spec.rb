require 'rails_helper'

RSpec.describe ShortUrlController, type: :controller do

  describe 'GET redirect' do
    context 'with a shortened URL saved in DB' do
      before { Url.create(original: GOOGLE, shortened: 'ABC123') }
      let(:url) { Url.find_by(original: GOOGLE) }
      it 'redirects to the registered URL' do
        get :redirect, shortened_url: url.shortened
        expect(assigns(:url)).to eq(url)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(url.original)
      end
    end

    context 'with a shortened URL not saved in DB' do
      it 'redirects to the registered URL' do
        get :redirect, shortened_url: 'BADURL'
        expect(assigns(:url)).to be_nil
        expect(response).to have_http_status(404)
        expect(response.body).to match(/No Route Matched/)
      end
    end
  end
end
