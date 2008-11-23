class Article
  REP = '<+<<*>>+>'

  include DataMapper::Resource

  property :id,               Serial
  property :body,             Text
  property :title,            String
  property :slug,             String

  property :created_at,       DateTime
  property :updated_at,       DateTime

  is :versioned, :on => :updated_at

  def auto_link
    keeps = []
    altered = body.gsub(/\[+.*?\]+/) do |match|
      keeps << match
      REP
    end
    altered.gsub(Regexp.new("(#{Article.all.map{|x| x.slug}.join("|")})"), "[[\\1]]").gsub(REP){|match| keeps.shift}
  end
end