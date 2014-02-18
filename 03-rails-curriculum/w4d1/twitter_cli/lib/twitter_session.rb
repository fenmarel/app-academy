require 'oauth'
require 'launchy'
require 'yaml'
require 'addressable/uri'
require '../keys'

class TwitterSession
  include Keys

  ACCESS_TOKEN_FILE = 'access_token.yml'

  CONSUMER = OAuth::Consumer.new(
    TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, :site => "https://api.twitter.com")

  def self.get(path, query_values)
    get = self.path_to_url(path, query_values)

    self.access_token.get(get).body
  end

  def self.post(path, req_params)
    post = self.path_to_url(path, req_params)

    self.access_token.post(post).body
  end

  def self.access_token
    if File.exist?(ACCESS_TOKEN_FILE)
      @access_token ||= YAML::load(File.read(ACCESS_TOKEN_FILE))
    else
      self.request_access_token
    end

    @access_token
  end

  def self.request_access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    Launchy.open(authorize_url)

    puts "Enter the verification code (only required once)"
    oauth_verifier = gets.chomp

    @access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )

    File.open(ACCESS_TOKEN_FILE, 'w') do |f|
      f.puts @access_token.to_yaml
    end

    nil
  end

  def self.path_to_url(path, query_values = nil)
    Addressable::URI.new({
      scheme: "https",
      host: "api.twitter.com",
      path: "/1.1/#{path}.json",
      query_values: query_values
    }).to_s
  end
end
