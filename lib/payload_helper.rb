#!/usr/bin/env ruby
# http://www.rubyinside.com/nethttp-cheat-sheet-2940.html
#Possibly deal with authentication https://www.socialtext.net/open/very_simple_rest_in_ruby_part_3_post_to_create_a_new_workspace

require 'nokogiri'

#===== File Format Conversion =====#
def read_as_json(filename)
  @log.info("Converting file #{filename} to JSON")
  @payload  = File.read(filename)
end

def read_as_xml(filename)
  @log.info("Converting file #{filename} to XML")
  xml_file = File.open(filename, 'r')
  @payload = Nokogiri::XML(xml_file)
  xml_file.close
end

#===== Authentication and Security =====#
def authenticate_user(request)
  @log.info("Authentication user #{@username}")
  request.basic_auth(@username, @password)
end

#===== HTTP Requests =====#
def get(user_auth=false)
  http = new_http()
  request = Net::HTTP::Get.new(@uri.request_uri)
  initialize_header(request, @header)
  authenticate_user(request) if user_auth == true
  request.body = @payload if @payload
  log_request(request)
  response = http.request(request)
  log_response(response)
end

def post(user_auth=false)
  http = new_http()
  request = Net::HTTP::Post.new(@uri.request_uri)
  initialize_header(request, @header)
  authenticate_user(request) if user_auth == true
  request.body = @payload if @payload
  log_request(request)
  response = http.post(@uri.path, request.body.to_s, @header)
  log_response(response)
end

def put(user_auth=false)
  http = new_http()
  request = Net::HTTP::Put.new(@uri.request_uri)
  initialize_header(request, @header)
  authenticate_user(request) if user_auth == true
  request.body = @payload if @payload
  log_request(request)
  response = http.put(@uri.path, request.body.to_s, @header)
  log_response(response)
end

def delete(user_auth=false)
    http = new_http()
  request = Net::HTTP::Delete.new(@uri.request_uri)
  initialize_header(request, @header)
  authenticate_user(request) if user_auth == true
  request.body = @payload if @payload
  log_request(request)
  response = http.request(request)
  log_response(response)
end

#===== HTTP Connection =====#
def new_http()
  http = Net::HTTP.new(@uri.host, @uri.port)
  if @uri.to_s.include?("https")
    @log.debug("uri contains https. Enabling https")
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  return http
end

def initialize_header(request, header)
  request.initialize_http_header(header)
end

#===== Logging =====#
def log_request(request)
  @log.info("Sending Request to #{@uri} using #{@method}")
  @log.info("File used: #{@file}")
  @log.debug("::REQUEST HEADER:: #{@header}")
  @log.debug("::REQUEST BODY:: #{request.body}")

  puts "Sending Request to #{@uri} using #{@method}"
end

def log_response(response)
  @log.debug("::RESPONSE BODY:: #{response.body}")
  puts "::HTTP RESPONSE CODE:: #{response.code}"
  puts "::RESPONSE BODY:: #{response.body}"
end
