require 'excon'

measure 'Excon' do
  Excon.get(TestURL, :headers => { 'Host' => HostHeader }).tap { |response|
    response.headers
    response.body
  }
end
