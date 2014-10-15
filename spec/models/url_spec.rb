require 'rails_helper'
require 'shared_constants'

RSpec.describe Url, type: :model do

  describe '#save' do
    context 'with valid URL' do
      subject(:url) { Url.new(original: GOOGLE) }
      it 'generates the shortened URL and stores the URL in the DB' do
        expect(url.original).to eq GOOGLE
        expect(url.shortened).to be_nil
        expect(url.save).to be true
        expect(url.original).to eq GOOGLE
        expect(url.shortened).not_to be_nil
        expect(Url.find_by(original: GOOGLE)).not_to be_nil
      end
    end

    context 'with complex URL' do
      subject(:url) { Url.new(original: AMAZON) }
      it 'generates the shortened URL and stores the URL in the DB' do
        expect(url.original).to eq AMAZON
        expect(url.shortened).to be_nil
        expect(url.save).to be true
        expect(url.original).to eq AMAZON
        expect(url.shortened).not_to be_nil
        expect(Url.find_by(original: AMAZON)).to eq url
      end
    end

    context 'with valid URL using https' do
      subject(:url) { Url.new(original: GOOGLS) }
      it 'generates the shortened URL and stores the URL in the DB' do
        expect(url.original).to eq GOOGLS
        expect(url.shortened).to be_nil
        expect(url.save).to be true
        expect(url.original).to eq GOOGLS
        expect(url.shortened).not_to be_nil
        expect(Url.find_by(original: GOOGLS)).not_to be_nil
      end
    end

    context 'with valid URL and valid shortened URL' do
      let(:short) { 'ABC123' }
      subject(:url) { Url.new(original: GOOGLE, shortened: short) }
      it 'generates the shortened URL and stores the URL in the DB' do
        expect(url.original).to eq GOOGLE
        expect(url.shortened).to eq short
        expect(url.save).to be true
        expect(url.original).to eq GOOGLE
        expect(url.shortened).to eq short
        expect(Url.find_by(original: GOOGLE, shortened: short)).not_to be_nil
      end
    end

    context 'with valid URL and invalid shortened URL' do
      let(:short) { 'A' }
      subject(:url) { Url.new(original: GOOGLE, shortened: short) }
      it 'generates the shortened URL and stores the URL in the DB' do
        expect(url.original).to eq GOOGLE
        expect(url.shortened).to eq short
        expect(url.save).to be false
        expect(Url.find_by(original: GOOGLE)).to be_nil
      end
    end

    context 'with valid URL preceded and followed by white spaces' do
      let(:input) { '   ' + GOOGLE + '    ' }
      subject(:url) { Url.new(original: input) }
      it 'generates the shortened URL' do
        expect(url.shortened).to be_nil
        expect(url.save).to be true
        expect(url.shortened).not_to be_nil
      end

      it 'strips all leading and trailing white spaces from the URL' do
        expect(url.original).to eq input
        expect(url.save).to be true
        expect(url.original).to eq GOOGLE
        expect(Url.find_by(original: GOOGLE)).not_to be_nil
      end

      it 'stores in DB' do
        expect(url.save).to be true
        expect(Url.find_by(original: GOOGLE)).to eq(url)
      end
    end

    context 'with the same URL as an existing record in the DB' do
      subject(:url) { Url.new(original: GOOGLE) }
      before { Url.create(original: GOOGLE) }
      it 'does not save the URL in the DB' do
        expect(Url.count(original: GOOGLE)).to be 1
        expect(url.save).to be false
        expect(Url.count(original: GOOGLE)).to be 1
      end
    end

    context 'with only the scheme of URL' do
      let(:scheme) { 'http://' }
      subject(:url) { Url.new(original: scheme) }
      it 'does not save the URL in the DB' do
        expect(url.save).to be false
        expect(Url.count(original: scheme)).to be 0
      end
    end

    context 'with valid URL using a scheme other than http/s' do
      let(:ftp) { 'ftp://www.google.com' }
      subject(:url) { Url.new(original: ftp) }
      it 'does not save the URL in the DB' do
        expect(url.save).to be false
        expect(Url.count(original: ftp)).to be 0
      end
    end

    context 'with no URL' do
      subject(:url) { Url.new }
      it 'does not save the URL in the DB' do
        expect(Url.count).to be 0
        expect(url.original).to be_nil
        expect(url.shortened).to be_nil
        expect(url.save).to be false
        expect(url.original).to be_nil
        expect(url.shortened).to be_nil
        expect(Url.count).to be 0
      end
    end

    context 'with invalid URL' do
      let(:invalid) { 'invalid url' }
      subject(:url) { Url.new(original: invalid) }
      it 'does not save the URL in the DB' do
        expect(url.original).to eq invalid
        expect(url.shortened).to be_nil
        expect(url.save).to be false
        expect(Url.count).to be 0
      end
    end
  end
end
