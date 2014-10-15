# Redirects a shrotened URL to the original URL
class ShortUrlController < ApplicationController
  def redirect
    @url = Url.find_by(shortened: params[:shortened_url])
    if @url
      redirect_to @url.original
    else
      render text: "No Route Matched: #{params[:shortened_url]}", status: 404
    end
  end
end
