require 'addressable/uri'
require 'rest-client'

url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users.html',
  query_values: {
      'some_category[a_key]' => 'another value',
      'some_category[a_second_key]' => 'yet another value',
      'some_category[inner_inner_hash][key]' => 'value',
      'something_else' => 'aaahhhhh'
    }
).to_s

def create_user
  url = Addressable::URI.new(
     scheme: 'http',
     host: 'localhost',
     port: 3000,
     path: '/users.json'
   ).to_s
   begin
      puts RestClient.post(url,
              {:user => {:name => "Gizmo", :email => "gizmo@gizmo.gizmo"}})
  rescue => e
    e.messages
  end
end

