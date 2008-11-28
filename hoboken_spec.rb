require 'rubygems'
require 'sinatra'
Sinatra.application.options.env = 'test'
require 'spec'
require 'sinatra/test/rspec'
require 'wiki'
Article.auto_migrate!
Article.create(:slug => "Index", :title => "Index", :body => "Welcome to hoboken.  You can edit this content")

class Article
  @@count ||= 1
  # make sure updated_at is always unique
  before :save do
    @@count += 1
    self.updated_at = Time.now + 60 * @@count
  end
end

describe 'Hoboken' do
  
  before(:all) do
    @@article = Article.create(:slug => 'aardvark', :title => 'Aardvark', :body => "Commonly spelled incorrectly as 'ardvark'")
  end
  
  it "should show an index" do
    get_it '/'
    @response.should be_ok
    @response.body.should include('Recent items')
  end

  it "should allow creating new articles" do
    Article.first(:slug => "test").should be_nil
    get_it '/test'
    @response.body.should include('Creating test')
  end

  it "should allow viewing and editing existing article" do
    get_it '/aardvark'
    @response.body.should include(@@article.body)

    get_it '/aardvark/edit'
    @response.body.should include('Editing Aardvark')
  end
  
  it "should show versions" do
    post_it '/', {:slug => 'aardvark', :body => 'New content', :title => 'Aardvark'}
    post_it '/', {:slug => 'aardvark', :body => 'Newer content', :title => 'Aardvark'}
    
    get_it '/aardvark/history'
    @response.body.should include(@@article.body)
    @response.body.should include("New content")
  end
end