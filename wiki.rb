require 'rubygems'
require 'sinatra'

configure do
  %w(dm-core dm-is-versioned dm-timestamps dm-tags haml wikitext article).each { |lib| require lib }

  ROOT = File.expand_path(File.dirname(__FILE__))
  config = begin
    YAML.load(File.read("#{ROOT}/config.yml").gsub(/ROOT/, ROOT))[Sinatra::Application.environment.to_s]
  rescue => ex
    raise "Cannot read the config.yml file at #{ROOT}/config.yml - #{ex.message}"
  end

  DataMapper.setup(:default, config['db_connection'])
  DataMapper.auto_upgrade!

  PARSER = Wikitext::Parser.new(:external_link_class => 'external', :internal_link_prefix => nil)
end

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
  unless params[:preview] == '1'
    @article.update_attributes(:title => params[:title], :body => params[:body], :slug => params[:slug], :tag_list => params[:tag_list])
    redirect "/#{params[:slug].gsub(/^index$/i, '')}"
  else
    haml :edit, :locals => {:action => ["Editing", "Edit"]}
  end
end

get '/tags/:tag_name' do
  tag = Tag.first(:name => params[:tag_name])
  @tagged_articles = Tagging.all(:tag_id => tag.id, :order => [:id.desc]).map{|t| t.taggable}
  @title = "Items tagged &quot;#{params[:tag_name]}&quot;"
  haml :show_tag
end

get '/:slug' do
  @article = Article.first(:slug => params[:slug])
  if @article
    haml :show
  else
    @article = Article.new(:slug => params[:slug], :title => de_wikify(params[:slug]))
    haml :edit, :locals => {:action => ["Creating", "Create"]}
  end
end

get '/:slug/history' do
  @article = Article.first(:slug => params[:slug])
  haml :history
end

get '/:slug/edit' do
  @article = Article.first(:slug => params[:slug])
  haml :edit, :locals => {:action => ["Editing", "Edit"]}
end

post '/:slug/edit' do
  @article = Article.first(:slug => params[:slug])
  @article.body = params[:body] if params[:body]
  haml :revert
end