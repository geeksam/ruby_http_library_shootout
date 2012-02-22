require 'curb'
curb = Curl::Easy.new(TestURL)
curb.headers['Host'] = HostHeader
# curb.perform

measure 'Curb' do
  curb.perform
  curb.headers['Host']
  curb.body_str
end
