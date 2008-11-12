DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/wiki.db")

PARSER = Wikitext::Parser.new
PARSER.internal_link_prefix = nil

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

Article.auto_migrate! unless File.exist?("#{Dir.pwd}/wiki.db")

def de_wikify(phrase)
  phrase.gsub(/(\w)([A-Z])/, "\\1 \\2")
end