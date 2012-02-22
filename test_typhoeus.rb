require 'typhoeus'

# Typhoeus::Request.get(TestURL, :headers => { 'Host' => HostHeader })

measure 'Typhoeus' do
  Typhoeus::Request.get(TestURL, :headers => { 'Host' => HostHeader }).tap { |response|
    response.headers_hash
    response.body
  }
end
