require 'spec_helper'
require 'rails_helper'

RSpec.describe UrlsHelper, type: :helper do

  HOST = 'www.example.com'
  PORT = 8080

  before(:each) do
    allow(request).to receive_messages(host: HOST, port: PORT)
  end

  describe '#current_host' do
    context 'with request which has host and port' do
      it 'returns the host and port that the request instance has' do
        expect(current_host).to eq "#{HOST}:#{PORT}"
      end
    end

    context 'with request which has only host' do
      it 'returns the host that the request instance has' do
        allow(request).to receive_messages(host: HOST, port: nil)
        expect(current_host).to eq "#{HOST}"
      end
    end
  end

  describe '#fullpath' do
    it 'returns the shortened url that contains the correct scheme and host' do
      short = 'ABC123'
      expect(fullpath(short)).to eq "http://#{HOST}:#{PORT}/#{short}"
    end
  end
end
