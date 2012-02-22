require 'patron'
patron = Patron::Session.new.tap { |session|
  session.base_url = BaseURL
  session.connect_timeout = session.timeout = 1
  session.insecure = true
}

measure 'Patron' do
  patron.get(TestBOC, :host => HostHeader).tap { |response|
    response.headers
    response.body
  }
end
