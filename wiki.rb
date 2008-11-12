%w(rubygems dm-core dm-is-versioned dm-timestamps sinatra wikitext init).each { |lib| require lib }

get '/' do
  @recent = Article.all(:order => [:updated_at.desc], :limit => 10)
  haml :index
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

get '/:slug/edit' do
  @article = Article.first(:slug => params[:slug])
  @action = ["Editing", "Edit"]
  haml :edit
end

post '/' do
  @article = Article.first(:slug => params[:slug])
  attributes = {:title => params[:title], :body => params[:body], :slug => params[:slug]}
  if @article
    @article.update_attributes(attributes)
  else
    @article = Article.create(attributes)
  end
  redirect "/#{params[:slug]}"
end