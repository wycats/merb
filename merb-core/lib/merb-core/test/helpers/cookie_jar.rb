require 'uri'

module Merb
  module Test
    class Cookie
      
      attr_reader :name, :value
      
      def initialize(raw, response_host)
        # separate the name / value pair from the cookie options
        @name_value_raw, options = raw.split(/[;,] */n, 2)
        
        @name, @value = Merb::Parse.query(@name_value_raw, ';').to_a.first
        @options = Merb::Parse.query(options, ';')
        
        @options.delete_if { |k, v| !v || v.empty? }
        
        @options["domain"] ||= response_host
      end
      
      def raw
        @name_value_raw
      end
      
      def empty?
        @value.nil? || @value.empty?
      end
      
      def domain
        @options["domain"]
      end
      
      def path
        @options["path"] || "/"
      end
      
      def expires
        Time.parse(@options["expires"]) if @options["expires"]
      end
      
      def expired?
        expires && expires < Time.now
      end
      
      def matches?(uri)
        host = uri.host || "example.org"
        
        # puts "#{!expired?} && "
        # puts "#{host} =~ #{Regexp.new("#{Regexp.escape(domain)}$").inspect} && "
        # puts "#{uri.path} =~ #{Regexp.new("^#{Regexp.escape(path)}").inspect} <br/>"
        # puts "Result: #{! expired? &&
        # host     =~ Regexp.new("#{Regexp.escape(domain)}$") &&
        # uri.path =~ Regexp.new("^#{Regexp.escape(path)}")} <br/>"
        
        ! expired? &&
        host     =~ Regexp.new("#{Regexp.escape(domain)}$") &&
        uri.path =~ Regexp.new("^#{Regexp.escape(path)}")
      end
      
      def <=>(other)
        # Orders the cookies from least specific to most
        [name, path, domain.reverse] <=> [other.name, other.path, other.domain.reverse]
      end
      
    end

    class CookieJar
      
      def initialize
        @jars = Hash.new([])
      end
      
      def update(jar, uri, raw_cookies)
        return unless raw_cookies
        
        host = URI(uri).host || "example.org"
        # Initialize all the the received cookies
        cookies = raw_cookies.map { |raw| Cookie.new(raw, host) }
        
        # Remove all the cookies that will be updated
        @jars[jar].delete_if do |existing|
          cookies.find { |c| [c.name, c.domain, c.path] == [existing.name, existing.domain, existing.path] }
        end
        
        @jars[jar].concat cookies
      end
      
      def for(jar, uri)
        uri = URI(uri)
        cookies = []
        
        @jars[jar].each do |cookie|
          cookies << cookie.raw if cookie.matches?(uri)
        end
        
        cookies.join
      end
      
    end
  end
end