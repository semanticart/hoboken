class Article
  REP = '<+<<*>>+>'

  include DataMapper::Resource

  property :id,               Serial
  property :body,             Text
  property :title,            String
  property :slug,             String

  property :created_at,       DateTime
  property :updated_at,       DateTime
  has_tags_on :tags

  is :versioned, :on => :updated_at

  def auto_link
    keeps = []
    # replace everything currently within brackets with our constant
    # and save the results
    altered = body.gsub(/\[+.*?\]+/) do |match|
      # save what we're replacing so we can put it back later
      keeps << match
      REP
    end
    # auto-link any articles
    altered.gsub!(Regexp.new("(#{Article.all.map{|x| x.slug}.join("|")})"), "[[\\1]]")
    # put our original already-bracketed items back
    altered.gsub!(REP){|match| keeps.shift}
    altered
  end
end