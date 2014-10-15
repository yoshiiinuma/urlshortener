# Handles a URL submitted by a user
class UrlsController < ApplicationController
  def index
    @urls = Url.all
  end

  def show
    @url = Url.find_by(id: params[:id].to_i) || Url.new
  end

  def new
    @url ||= Url.new
  end

  def create
    @url = Url.find_or_initialize_by(original: url_params[:original])
    if @url.new_record?
      if @url.save
        redirect_to @url
      else
        render :new
      end
    else
      redirect_to @url
    end
  end

  def destroy
    @url = Url.find_by(id: params[:id])
    @url.destroy if @url
    redirect_to urls_path
  end

  private

  def url_params
    params.require(:url).permit(:original)
  end
end
