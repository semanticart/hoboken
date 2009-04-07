require 'rubygems'
require 'sinatra'
Sinatra::Application.environment = 'test'
require 'spec'
require 'sinatra/test/rspec'
require 'wiki'
Article.auto_migrate!
Article.create(:slug => "Index", :title => "Index", :body => "Welcome to hoboken.  You can edit this content")


describe 'Hoboken' do

  before(:all) do
    @@article = Article.create(:slug => 'aardvark', :title => 'Aardvark', :body => "Commonly spelled incorrectly as 'ardvark'")
  end

  it "should show an index" do
    get '/'
    @response.should be_ok
    @response.body.should include('Recent items')
  end

  it "should allow creating new articles" do
    Article.first(:slug => "test").should be_nil
    get '/test'
    @response.body.should include('Creating test')
  end

  it "should allow viewing and editing existing article" do
    get '/aardvark'
    @response.body.should include(@@article.body)

    get '/aardvark/edit'
    @response.body.should include('Editing Aardvark')
  end

  it "should show versions" do
    # sadly we need to sleep or the updated_at uniqueness constraint of
    # dm-is-versioned will not be met
    sleep 1
    post '/', {:slug => 'aardvark', :body => 'New content', :title => 'Aardvark'}
    sleep 1
    post '/', {:slug => 'aardvark', :body => 'Newer content', :title => 'Aardvark'}

    get '/aardvark/history'
    @response.body.should include(@@article.body)
    @response.body.should include("New content")
  end

  it "should auto-link articles" do
    post '/', {:slug => 'pancakes', :body => 'It is unknown if an aardvark would eat a pancake', :title => 'Pancakes'}

    Article.first(:slug => 'pancakes').auto_link.should include('[[aardvark]]')

    get '/pancakes'
    @response.body.should include('<a href="aardvark">aardvark</a>')
  end

  it "should allow tagging" do
    @@article.tag_list = "out, of, order"
    @@article.save

    Article.first(:slug => @@article.slug).tag_list.should == %w( of order out)
  end

  it "should have a show page for tags" do
    @@article.tag_list = "hey, there"
    @@article.save

    get '/tags/hey'
    @response.body.should include(@@article.title)
  end

end