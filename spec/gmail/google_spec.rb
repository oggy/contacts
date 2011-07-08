require 'spec_helper'
require 'contacts/google'
require 'yaml'  

describe Contacts::Google do
  before(:each) do
    config = YAML.load_file(File.expand_path("../../config/contacts.yml", __FILE__))
    Contacts.configure(config["test"])
    @google = Contacts::Google.new
    fake_responses
  end
  
  context "return_url" do
    it "should allow the return url to be set in the config" do
      @google.return_url.should_not == nil
    end
  end

  context "authentication_url" do
    it "should return an authentication url" do
      @google.authentication_url("http://browser.zen.turingstudio.com/test").length.should_not == 0
    end
    
    it "should return the return url from configuration if the return url is not set" do
      @google.authentication_url().length.should_not == 0
    end
  end
  
  context "authorize" do
    it "should set the access token if the authoriztion is granted" do
      @google.authentication_url("http://browser.zen.turingstudio.com/test").length.should_not == 0
      @google.authorize({})
      @google.access_token.should_not == nil
    end
  end
  
  context "contacts" do
    it "should return an array of contacts (all users with email addresses)" do
      @google.authentication_url("http://browser.zen.turingstudio.com/test").length.should_not == 0
      @google.authorize({})
      contacts = @google.contacts
      contacts.should_not == nil
      contacts.length.should == 3
    end
    
    it "should return multiple email addresses for user with multiple email addresses" do
      @google.authentication_url("http://browser.zen.turingstudio.com/test").length.should_not == 0
      @google.authorize({})
      contacts = @google.contacts
      contacts[1].emails.length.should == 2
    end

    it "should return an array of contacts with phone numbers" do
      @google.authentication_url("http://browser.zen.turingstudio.com/test").length.should_not == 0
      @google.authorize({})
      contacts = @google.contacts
      contacts[0].phones.length.should == 1
      contacts[0].phones.first.should == "555-456-4567"
    end
  end

end
