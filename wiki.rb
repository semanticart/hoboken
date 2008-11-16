require 'rubygems'
require 'sinatra'
require 'init'

helpers do
  # break up a CamelCased word into something more readable
  def de_wikify(phrase)
    phrase.gsub(/(\w)([A-Z])/, "\\1 \\2")
  end
end

get '/' do
  @article = Article.first(:slug => 'Index')
  @article ||= Article.create(:slug => "Index", :title => "Index", :body => "Welcome to hoboken.  You can edit this content")
  @recent = Article.all(:order => [:updated_at.desc], :limit => 10)
  haml :show
end

post '/' do
  @article = Article.first(:slug => params[:slug])
  attributes = {:title => params[:title], :body => params[:body], :slug => params[:slug]}
  if @article
    @article.update_attributes(attributes)
  else
    @article = Article.create(attributes)
  end

  if @article.slug =~ /^index$/i
    redirect "/"
  else
    redirect "/#{params[:slug]}"
  end
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