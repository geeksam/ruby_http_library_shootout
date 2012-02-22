require 'net/http'
require 'uri'

uri = URI.parse(BaseURL)
http = Net::HTTP.start(uri.host, uri.port)

measure 'Net::HTTP' do
  http.get(TestBOC, { 'Host' => HostHeader }).tap { |response|
    response['content-type']
    response.body
  }
end
