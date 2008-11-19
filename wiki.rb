require 'rubygems'
require 'sinatra'
require 'init'

helpers do
  # break up a CamelCased word into something more readable
  # this is used when you create a new page by visiting /NewItem
  def de_wikify(phrase)
    phrase.gsub(/(\w)([A-Z])/, "\\1 \\2")
  end

  def friendly_time(time)
    time.strftime("%a. %b. %d, %Y, %I:%M%p")
  end
end

get '/' do
  @article = Article.first_or_create(:slug => 'Index')
  @recent = Article.all(:order => [:updated_at.desc], :limit => 10)
  haml :show
end

post '/' do
  @article = Article.first_or_create(:slug => params[:slug])
  @article.update_attributes(:title => params[:title], :body => params[:body], :slug => params[:slug])
  redirect "/#{params[:slug].gsub(/^index$/i, '')}"
end

get '/:slug' do
  @article = Article.first(:slug => params[:slug])
  if @article
    haml :show
  else
    @article = Article.new(:slug => params[:slug], :title => de_wikify(params[:slug]))
    @action = ["Creating", "Create"]
    haml :edit
  end
end

get '/:slug/history' do
  @article = Article.first(:slug => params[:slug])
  haml :history
end

get '/:slug/edit' do
  @article = Article.first(:slug => params[:slug])
  @action = ["Editing", "Edit"]
  haml :edit
end

post '/:slug/edit' do
  @article = Article.first(:slug => params[:slug])
  @article.body = params[:body] if params[:body]
  @action = ["Reverting", "Save"]
  haml :revert
end