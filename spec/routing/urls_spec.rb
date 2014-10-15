require 'rails_helper'

RSpec.describe UrlsController, type: :routing do
  describe 'routing to urls' do
    it 'routes /urls to #index' do
      expect(get: '/urls').to route_to(
        controller: 'urls', action: 'index')
    end
    it 'routes /urls/new to #new' do
      expect(get: '/urls/new').to route_to(
        controller: 'urls', action: 'new')
    end
    it 'routes /urls/new to #create' do
      expect(post: '/urls').to route_to(
        controller: 'urls', action: 'create')
    end
    it 'routes /urls/:id to #show' do
      expect(get: '/urls/123').to route_to(
        controller: 'urls', action: 'show', id: '123')
    end
    it 'routes /urls/:id to #destroy' do
      expect(delete: '/urls/123').to route_to(
        controller: 'urls', action: 'destroy', id: '123')
    end
  end
end
