#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'json/pure'
require 'net/http'
require 'net/https'
require 'uri'
require 'optparse'
require 'psych'
require 'logger'

require_relative 'lib/payload_helper'
require_relative 'lib/option_reader'


#TODO: Certificate management
#TODO: Error handling

#===== INSTANCE VARIABLES =====#
@endpoints_yaml = Psych.load(File.open("endpoints.yml", 'r'))
@payload

timestamp = Time.now
Dir.mkdir('log') if !Dir.exists?('log')
logfile = 'log/crystal-lake' + timestamp.year.to_s + timestamp.month.to_s + timestamp.day.to_s + '.log'
@log = Logger.new(logfile)
log_level = @endpoints_yaml.fetch("log_level")
case log_level
when 'DEBUG'
  @log.level = Logger::DEBUG
when 'INFO'
  @log.level = Logger::INFO
when 'WARN'
  @log.level = Logger::WARN
when 'ERROR'
  @log.level = Logger::ERROR
when 'FATAL'
  @log.level = Logger::FATAL
end


#===== OPTION PARSERS =====#
#options in yaml: should allow al of these options and have the command line overwrite
@options = {}
option_parser = OptionParser.new do |opts|
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Usage: ruby #{executable_name} [options] <environment> <application> <endpoint>"

  opts.on("--uri URI","URI to send the request to") do |uri|
    @options[:uri] = uri
  end

  opts.on("-m METHOD","--method METHOD","Send method: POST, GET, PUT, DELETE") do |method|
    @options[:method] = method
  end

  opts.on("-h HEADER, --header HEADER", "Header initialization values") do |header|
    @options[:header] = header
  end

  opts.on("-u USER","--user USER","Username to authenticate to server if needed") do |user|
    @options[:user] = user
  end

  opts.on("-p PASSWORD","--password PASSWORD","Password to authenticate to server if needed") do |password|
    @options[:password] = password
  end

  opts.on("-c CERTIFICATE","--cert CERTIFICATE","Certificate to authenticate to server if needed") do |certificate|
    @options[:certificate] = certificate
  end

  opts.on("-f FILE","--file FILE","File containing request data to send") do |file|
    @options[:file] = file
  end

  opts.on("-s SUFFIX","--suffix SUFFIX","Optional string added to the end of the uri") do |suffix|
    @options[:suffix] = suffix
  end
end

option_parser.parse!

#===== ARGUMENT PARSER =====#
# This parses the rest of the command line arguments after the options parser has run. This grabs the required command line arguments.
if ARGV.size < 1
  puts option_parser
  puts "options found: #{@options.inspect}"
  puts "ERROR: Missing required arguments"
  exit(-1)
else
  fetch_yaml_values()
  fetch_option_values(@options)
  if (@header.to_s.include?("json") and (@file.nil?))
    print "No JSON file specified. Please type in your JSON here: "
    json = STDIN.gets().chomp
    @payload = json
  end
end

#trigger an authenticate_user call if a username/password combination or certificate is provided
auth_user = true if ((@username != nil && @password !=nil) || @certificate != nil)
convert_file_to_payload(@file) if @file
case @method.downcase
when 'get'
  get(auth_user)
when 'post'
  post(auth_user)
when 'put'
  put(auth_user)
when 'delete'
  delete(auth_user)
end
