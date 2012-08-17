class SfClient
  include HTTParty
  format :json

  class << self
    attr_accessor :credentials
  end

  LOGIN_URL = 'https://login.salesforce.com/services/oauth2/token'


  def initialize(klass)
    @klass = klass.to_s
  end

  def headers
    { 'Authorization' => "OAuth #{self.class.credentials.token}" }
  end

  def api_headers
    headers.merge('Content-Type' => 'application/json', 'Accept' => 'application/json')
  end

  def prefix
    "#{self.class.credentials.instance_url}/services/apexrest/#{@klass}"
  end

  def auth_token_expired?(response)
    response.code == 401 && response[0]['errorCode'] == 'INVALID_SESSION_ID'
  end

  def refresh_auth_token
    refresh_response = self.class.post(LOGIN_URL,
                                       :headers => headers,
                                       :body => {:grant_type => 'refresh_token', :refresh_token => self.class.credentials.refresh_token, :client_id => APP_CONFIG['key']})
    self.class.credentials.token = refresh_response['access_token']
    self.class.credentials.save
  end

  def do_request
    response = yield
    if auth_token_expired?(response)
      refresh_auth_token
      response = yield
    end
    response.parsed_response
  end

  def find(id)
    do_request do
      self.class.get("#{prefix}/#{id}", :headers => api_headers)
    end
  end

  def create(data)
    do_request do
      self.class.post(prefix, :headers => api_headers, :body => data.to_json)
    end
  end

  def all
    do_request do
      self.class.get(prefix, :headers => api_headers)
    end
  end

  def delete(id)
    do_request do
      self.class.delete("#{prefix}/#{id}", :headers => api_headers)
    end
  end

  def update(id, data)
    do_request do
      self.class.put("#{prefix}/#{id}", :headers => api_headers, :body => data.to_json)
    end
  end
end
