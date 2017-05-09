require "net/http"
require "net/https"
require "open-uri"

class Http
	def get_post_put(original_url, method, params)
		url = URI.parse(url)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true if url.scheme == "https"
		request = if method.eql?(:get)
			Net::HTTP::Get.new(url.path)
		elsif method.eql?(:post)
			Net::HTTP::Post.new(url.path)
		elsif method.eql?(:put)
			Net::HTTP::Put.new(url.path)
		end
		request.set_form_data(params)
		return http.request(request).body
	end
end