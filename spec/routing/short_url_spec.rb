require 'rails_helper'

RSpec.describe ShortUrlController, type: :routing do
  describe 'routing to short_url' do
    it 'routes /:shortened_url to #redirect' do
      expect(get: '/abcdef').to route_to(
        controller: 'short_url', action: 'redirect',
        shortened_url: 'abcdef')
    end

    it 'does not route an invalid url' do
      expect(get: '/abcdefg').not_to be_routable
    end
  end
end
