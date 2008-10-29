require 'uri'

module Merb
  module Test
    class Cookie
      
      attr_reader :name, :value
      
      def initialize(raw, default_host)
        # separate the name / value pair from the cookie options
        @name_value_raw, options = raw.split(/[;,] */n, 2)
        
        @name, @value = Merb::Parse.query(@name_value_raw, ';').to_a.first
        @options = Merb::Parse.query(options, ';')
        
        @options.delete_if { |k, v| !v || v.empty? }
        
        @options["domain"] ||= default_host
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
      
      def valid?(uri)
        uri.host =~ Regexp.new("#{Regexp.escape(domain)}$") &&
        uri.path =~ Regexp.new("^#{Regexp.escape(path)}")
      end
      
      def matches?(uri)
        ! expired? && valid?(uri)
      end
      
      def <=>(other)
        # Orders the cookies from least specific to most
        [name, path, domain.reverse] <=> [other.name, other.path, other.domain.reverse]
      end
      
    end

    class CookieJar
      
      def initialize
        @jars = {}
      end
      
      def update(jar, uri, raw_cookies)
        return unless raw_cookies
        # Initialize all the the received cookies
        cookies = []
        raw_cookies.each do |raw|
          c = Cookie.new(raw, uri.host)
          cookies << c if c.valid?(uri)
        end
        
        @jars[jar] ||= []
        
        # Remove all the cookies that will be updated
        @jars[jar].delete_if do |existing|
          cookies.find { |c| [c.name, c.domain, c.path] == [existing.name, existing.domain, existing.path] }
        end
        
        @jars[jar].concat cookies
        
        @jars[jar].sort!
      end
      
      def for(jar, uri)
        cookies = {}
        
        @jars[jar] ||= []
        # The cookies are sorted by most specific first. So, we loop through
        # all the cookies in order and add it to a hash by cookie name if
        # the cookie can be sent to the current URI. It's added to the hash
        # so that when we are done, the cookies will be unique by name and
        # we'll have grabbed the most specific to the URI.
        @jars[jar].each do |cookie|
          cookies[cookie.name] = cookie.raw if cookie.matches?(uri)
        end
        
        cookies.values.join
      end
      
    end
  end
end