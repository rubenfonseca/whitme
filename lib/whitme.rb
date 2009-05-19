# -*- coding: utf-8 -*-
# vim:tabstop=4:expandtab:sw=4:softtabstop=4

require 'rubygems'
require 'json'
require 'open-uri'
require 'cgi'

# == MalformedURLError
#
# Raised when the user submits a malformed URL to whit.me
#
class MalformedURLError < ArgumentError
end

# == MalformedAliasError
#
# Raised when the user submits a malformed alias/hash to whit.me
#
class MalformedAliasError < ArgumentError
end

# == WhitmeURL
#
# Object that holds the different results of a Whit.me response
#
class WhitmeURL
  SHORT_URL = 'http://www.whit.me/api/short?'
  EXPAND_URL = 'http://www.whit.me/api/expand?'
  
  # The list of urls
  attr_accessor :url
  
  # The list of url notes. Should be the same size of urls
  attr_accessor :urlnote
  
  # The note associated with this url
  attr_accessor :note
  
  # Contains the shortened URL
  attr_accessor :hash
  
  def initialize
    self.url = []
    self.urlnote = []
  end
  
  def to_short_url
    params = self.url.map { |u| "url=#{CGI.escape(u)}" }
    params |= self.urlnote.map { |u| "urlnote=#{CGI.escape(u)}" }
    params << "note=#{CGI.escape(self.note)}" if self.note
    params << "hash=#{CGI.escape(self.hash)}" if self.hash
    
    SHORT_URL + params.join('&')
  end
  
  def to_expand_url
    EXPAND_URL + "hash=#{CGI.escape(self.hash)}"
  end
end

# == Whitme
#
# Holds the methods available on the Whit.me API
#
# (see http://www.whit.me/api/docs)
#
class Whitme
  # Shortens a URL
  #
  # Returns a Whitme instance with the shortened version under the
  # <tt>hash</tt> property.
  #
  # === Parameters
  #
  # * <tt>:url</tt> - a single string or an array of strings containing urls to shorten
  # * <tt>:urlnote</tt> - a single string or an array of strings containing notes associated with the urls
  # * <tt>:note</tt> - a general note to be associated with all the urls shortened
  # * <tt>:hash</tt> - a custom URL alias (for readable shortened URLs). whit.me will return a generated alias if the supplied parameter already exists or is invalid
  #
  # The only really required field is <tt>:url</tt>. If <tt>:urlnotes</tt> is
  # supplied, it must have the same size of <tt>:url</tt>. Otherwise an
  # ArgumentError is raised.
  #
  # === Example
  #
  #   require 'whitme'
  #   url = Whitme.short(:url => 'http://www.google.com', :note => 'foo')
  #   puts url.hash.inspect
  #
  #   url = Whitme.short(:url => ['http://google.com', 'http://sapo.pt'])
  #   puts url.hash.inspect
  #
  def self.short(options = {})
    # we must have at least on url to short
    raise ArgumentError unless options[:url]
    
    # if we have multiple notes, we should have the same number of urls
    if options[:urlnote]
      raise ArgumentError unless options[:urlnote].class == options[:url].class
      if(options[:url].class == Array)
        raise ArgumentError unless options[:url].size == options[:urlnote].size
      end
    end
    
    url = WhitmeURL.new
    url.url << options[:url] if options[:url].class == String
    url.url |= options[:url] if options[:url].class == Array
    
    if options[:urlnote]
      url.urlnote << options[:urlnote] if options[:urlnote].class == String
      url.urlnote |= options[:urlnote] if options[:urlnote].class == Array
    end
    
    url.note = options[:note]
    url.hash = options[:hash]
    
    url.hash = open(url.to_short_url).read
    json = JSON.parse(url.hash) rescue nil
    if json
      case json['error']
      when 0
        raise MalformedURLError
      when 1
        raise MalformedAliasError
      else
        raise ArgumentError
      end
    end
    
    url
  end
  
  # Expands an URL
  #
  # Returns a Whitme instance with all the (possible) fields filled. Accepts
  # a unique argument with either a hash (e.g. XP45xe3) or a full whit.me
  # URL.
  # 
  # === Example
  #  
  #  require 'whitme'
  #  url = Whitme.expand('HQX4P9')
  #  puts url.url.inspect
  #
  def self.expand(hash)
    url = WhitmeURL.new
    
    if(hash.include? 'http://')
      hash =~ /hash=(.+)/
      hash = $1
    end
    url.hash = hash
    
    json = JSON.parse(open(url.to_expand_url).read)
    url.url = json['urls']
    url.urlnote = json['urlnotes']
    url.note = json['note']
    url
  end
end