$:.unshift File.dirname(__FILE__)
require 'spec_helper'

describe Whitme do
  describe "short operation" do
    describe "with one url" do
      before(:all) do
        @url = 'http://www.google.com'
        @res = Whitme.short(:url => @url)
      end
      
      it "should short url" do
        @res.should_not be_nil
        @res.class.should == WhitmeURL
        @res.url.first.should == @url
        @res.urlnote.should == []
        @res.note.should be_nil
        @res.hash.should_not be_nil
      end
    end
    
    describe "with one url and a note and a urlnote" do
      before(:all) do
        @url = 'http://www.google.com'
        @note = 'Shortening Google'
        @urlnote = 'THE url to start the internet'
        @res = Whitme.short(:url => @url, :urlnote => @urlnote, :note => @note)
      end
      
      it "should short url" do
        @res.should_not be_nil
        @res.class.should == WhitmeURL
        @res.url.first.should == @url
        @res.urlnote.first.should == @urlnote
        @res.note.should == @note
        @res.hash.should_not be_nil
      end
    end
    
    describe "with multiple urls and multiple urlnotes" do
      before(:all) do
        @urls = ['http://www.google.com', 'http://www.yahoo.com']
        @urlnotes = ['THE url to start', 'Search engine wannabe']
        @res = Whitme.short(:url => @urls, :urlnote => @urlnotes)
      end
      
      it "should short url" do
        @res.should_not be_nil
        @res.class.should == WhitmeURL
        @res.url.should == @urls
        @res.urlnote.should == @urlnotes
        @res.note.should be_nil
        @res.hash.should_not be_nil
      end
    end
    
    describe "with a hash/alias" do
      before(:all) do
        @urls = 'http://www.google.com'
        @hash = 'google'
        @res = Whitme.short(:url => @urls, :hash => @hash)
      end
      
      it "should short with hash" do
        @res.should_not be_nil
        @res.class.should == WhitmeURL
        @res.url.first.should == @urls
        @res.urlnote.should == []
        @res.note.should be_nil
        @res.hash.should_not be_nil
      end
    end
    
    describe "without a url" do
      it "should throw a ArgumentError" do
        lambda { Whitme.short(:url => nil) }.should raise_error(ArgumentError)
        lambda { Whitme.short().should raise_error(ArgumentError) } 
      end
    end
    
    describe "with different url and urlnotes sizes" do
      it "should throw a ArgumentError" do
        lambda { 
          Whitme.short(:url => ['http://www.google.com'],
                       :urlnote => ['yes', 'no'])
        }.should raise_error(ArgumentError)
      end
    end
    
    describe "with a malformed url" do
      it "should throw a MalformedURLError" do
        lambda { 
          Whitme.short(:url => '////////////') 
        }.should raise_error(MalformedURLError)
      end
    end
  end
  
  describe "expand operation" do
    describe "expanding a hash" do
      before(:all) do
        @res = Whitme.expand('HQX4P9')
      end
      
      it "should expand" do
        @res.should_not be_nil
        @res.class.should == WhitmeURL
        @res.url.should == ['http://whit.me/', 'http://whit.me/api/docs']
        @res.urlnote.should == ['main page', 'documentation']
        @res.note.should == 'Some links about whit.me'
      end
    end
    
    describe "expading a url" do
      before(:all) do
        @res = Whitme.expand('http://www.whit.me/api/expand?hash=HQX4P9')
      end
      
      it "should expand" do
        @res.should_not be_nil
        @res.class.should == WhitmeURL
        @res.url.should == ['http://whit.me/', 'http://whit.me/api/docs']
        @res.urlnote.should == ['main page', 'documentation']
        @res.note.should == 'Some links about whit.me'
      end
    end
  end
end
