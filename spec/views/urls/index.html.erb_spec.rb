require 'rails_helper'

RSpec.describe 'urls/index', type: :view do
  context 'with multiple URL records' do
    before do
      Url.create(original: GOOGLE)
      Url.create(original: YAHOO)
      Url.create(original: AMAZON)
    end
    it 'displays urls list' do
      assign(:urls, Url.all)
      render
      expect(rendered).to have_selector('table') do |tbl|
        expect(tbl).to have_selector('tr td', text: GOOGLE)
        expect(tbl).to have_selector('tr td', text: YAHOO)
        expect(tbl).to have_selector('tr td', text: AMAZON)
      end
    end
  end

  context 'with no URL records' do
    it 'does not display urls list' do
      assign(:urls, [])
      render
      expect(rendered).not_to have_selector('table')
    end
  end
end
