class Article
  include DataMapper::Resource

  property :id,               Serial
  property :body,             Text
  property :title,            String
  property :slug,             String

  property :created_at,       DateTime
  property :updated_at,       DateTime

  is :versioned, :on => :updated_at
end