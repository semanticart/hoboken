%w(dm-core dm-is-versioned dm-timestamps wikitext).each { |lib| require lib }
ROOT = "#{Dir.pwd}"

config = begin
  YAML.load(File.read("#{ROOT}/config.yml").gsub(/ROOT/, ROOT))
rescue => ex
  raise "Cannot read the config.yml file at #{ROOT}/config.yml - #{ex.message}"
end

DataMapper.setup(:default, config[Sinatra.application.options.env.to_s]['db_connection'])

PARSER = Wikitext::Parser.new
PARSER.external_link_class = 'external'
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