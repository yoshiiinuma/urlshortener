require 'rails_helper'

RSpec.describe 'urls/new', type: :view do
  context 'Before a user submits the form' do
    it 'displays url entry form' do
      assign :url, Url.new
      render
      expect(rendered).not_to have_selector('div#error_explanation')
      expect(rendered).to have_selector('form') do |f|
        expect(f).to have_selector('text_field', text: '')
        expect(f).to have_selector('submit')
      end
    end
  end

  context 'After a user submitted an invalid input' do
    it 'displays error messages for the user input' do
      assign :url,  Url.create(original: 'invalid url')
      render
      expect(rendered).to have_selector('div#error_explanation')
      expect(rendered).to have_selector('form') do |f|
        expect(f).to have_selector('text_field', text: 'invalid url')
        expect(f).to have_selector('submit')
      end
    end
  end
end
