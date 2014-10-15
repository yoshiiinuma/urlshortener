# Urls Helper
module UrlsHelper
  def fullpath(shortened)
    "http://#{current_host}/#{shortened}"
  end

  def current_host
    host = request.host
    host += ":#{request.port}" if request.port
    host
  end
end
