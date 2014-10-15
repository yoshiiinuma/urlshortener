require 'rails_helper'
require 'shared_constants'

RSpec.describe UrlsController, type: :controller do

  describe 'GET index' do
    it 'routes to URLController#index' do
      expect(get: '/urls').to route_to(
        controller: 'urls', action: 'index')
    end
    context 'With multiple URL records in DB' do
      before do
        Url.create(original: GOOGLE)
        Url.create(original: YAHOO)
        Url.create(original: AMAZON)
      end
      let(:urls) { Url.all }
      it 'gets populated with an array of urls' do
        get :index
        expect(assigns(:urls)).to eq(urls)
      end

      it 'renders the :index view with the url list' do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end

    context 'With no URL records in DB' do
      it 'gets populated with an enpty array' do
        get :index
        expect(assigns(:urls)).to be_empty
      end

      it 'renders the :index view without the url list' do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    context 'with valid id' do
      before { Url.create(original: GOOGLE) }
      let(:url) { Url.find_by(original: GOOGLE) }
      it 'assigns the requested url to @url' do
        get :show, id: url.id
        expect(assigns(:url)).to eq(url)
      end
      it 'renders the :show template' do
        get :show, id: url.id
        expect(response).to have_http_status(200)
        expect(response).to render_template(:show)
      end
    end

    context 'with nonexistent id' do
      it 'assigns a newly created empty url to @url' do
        get :show, id: 9999
        expect(assigns(:url)).to be_a_new(Url)
      end
      it 'renders the :show template' do
        get :show, id: 9999
        expect(response).to have_http_status(200)
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET new' do
    it 'assigns a new URL to @url' do
      get :new
      expect(assigns(:url)).to be_a_new(Url)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    context 'with valid url' do
      it 'saves the new url in the database' do
        post :create, url: { original: GOOGLE }
        url = Url.find_by(original: GOOGLE)
        expect(url).not_to be_nil
        expect(assigns(:url)).to eq(url)
        expect(Url.find_by(original: GOOGLE)).to eq(url)
      end
      it 'redirects to the show page' do
        post :create, url: { original: GOOGLE }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(url_path(assigns(:url)))
      end
    end

    context 'with valid url preceded and followed by white spaces' do
      it 'saves the new url in the database' do
        post :create, url: { original: '   ' + GOOGLE + '   ' }
        url = Url.find_by(original: GOOGLE)
        expect(url).not_to be_nil
        expect(assigns(:url)).to eq(url)
      end
    end

    context 'with valid url that was alraedy stored in the database' do
      before { Url.create(original: GOOGLE) }
      let(:url) { Url.find_by(original: GOOGLE) }
      it 'does not save the new url in the database' do
        post :create, url: { original: GOOGLE }
        expect(assigns(:url)).not_to be_nil
        expect(assigns(:url)).to eq(url)
      end
      it 'redirects to the show page' do
        post :create, url: { original: GOOGLE }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(url_path(assigns(:url)))
      end
    end

    context 'with invalid url' do
      let(:invalid_url) { 'invalid url' }
      it 'does not save the new url in the database' do
        post :create, url: { original: invalid_url }
        expect(assigns(:url)).not_to be_nil
        expect(assigns(:url).original).to eq(invalid_url)
        expect(Url.count).to eq(0)
      end
      it 're-renders the :new template with the invalid url' do
        post :create, url: { original: GOOGLE }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(url_path(assigns(:url)))
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with id of an existing record' do
      before { Url.create(original: GOOGLE) }
      let(:url) { Url.find_by(original: GOOGLE) }
      it 'deletes the specified url in the database' do
        delete :destroy, id: url.id
        expect(assigns(:url)).not_to be_nil
        expect(Url.count).to eq(0)
      end
      it 'redirects to the index page' do
        delete :destroy, id: url.id
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(urls_path)
      end
    end

    context 'with id of a nonexistent record' do
      before { Url.create(original: GOOGLE) }
      let(:url) { Url.find_by(original: GOOGLE) }
      it 'does not delete any urls in the database' do
        delete :destroy, id: 9999
        expect(assigns(:url)).to be_nil
        expect(Url.find_by(original: GOOGLE)).not_to be_nil
      end
      it 'redirects to the index page' do
        delete :destroy, id: 9999
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(urls_path)
      end
    end
  end
end
