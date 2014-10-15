require 'rails_helper'

RSpec.describe 'urls/show', type: :view do
  context 'with a valid URL object' do
    it 'displays url details' do
      assign :url, Url.create(original: GOOGLE, shortened: 'ABC123')
      render
      expect(rendered).to have_selector('p', text: GOOGLE)
      expect(rendered).to have_selector('p', text: 'ABC123')
    end
  end

  context 'with an empty URL object' do
    it 'displays url details' do
      assign :url, Url.new
      render
      expect(rendered).to have_selector('p', text: '')
      expect(rendered).to have_selector('p', text: '')
    end
  end
end
