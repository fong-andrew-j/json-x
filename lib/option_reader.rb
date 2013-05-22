#!/usr/bin/env ruby

def fetch_yaml_values()
  yml_section = @endpoints_yaml.fetch(ARGV[0])
  for i in 1...ARGV.size
    yml_section = yml_section.fetch(ARGV[i])
  end

  #URI.parse used to be able to have @uri hold the different sections of the uri in its data structure, such as @uri.host or @uri.port
  #eval on header is used to translate the ruby hash specified in the yaml file into a structure that can be put into the http header
  @uri = URI.parse(yml_section.fetch("uri", ifnone = ""))
  @method = yml_section.fetch("method", ifnone = nil)
  @header = eval(yml_section.fetch("header", ifnone = nil))
  @username = yml_section.fetch("username", ifnone = nil)
  @password = yml_section.fetch("password", ifnone = nil)
  @certificate = yml_section.fetch("certificate", ifnone = nil)
  @file = yml_section.fetch("file", ifnone = nil)

  @log.debug("===== YAML FILE VALUES =====")
  @log.debug("uri: #{@uri}")
  @log.debug("method: #{@method}")
  @log.debug("header: #{@header}")
  @log.debug("username: #{@username}")
  @log.debug("password: #{@password}")
  @log.debug("certificate: #{@certificate}")
  @log.debug("file: #{@file}")
end

def fetch_option_values(options)
  @uri = URI.parse(options[:uri]) if options[:uri]
  @method = options[:method] if options[:method]
  @header = eval(options[:header]) if options[:header]
  @username = options[:username] if options[:username]
  @password = options[:password] if options[:password]
  @certificate = options[:certificate] if options[:certificate]
  @file = options[:file] if options[:file]
  @uri += options[:suffix] if options[:suffix]

  @log.debug("===== OPTIONS READ =====")
  @log.debug("uri: #{@uri}")
  @log.debug("method: #{@method}")
  @log.debug("header: #{@header}")
  @log.debug("username: #{@username}")
  @log.debug("password: #{@password}")
  @log.debug("certificate: #{@certificate}")
  @log.debug("file: #{@file}")
end

def convert_file_to_payload(file)
  read_as_json(file) if @header.to_s.include?("json")
  read_as_xml(file) if @header.to_s.include?("xml")
end
