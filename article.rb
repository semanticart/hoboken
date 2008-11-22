class Article
  include DataMapper::Resource

  property :id,               Serial
  property :body,             Text
  property :title,            String
  property :slug,             String

  property :created_at,       DateTime
  property :updated_at,       DateTime

  is :versioned, :on => :updated_at

  # if an auto_link set is defined in config.yml, automatically turn
  # those words into internal links.  Case matters.
  def auto_link
    if defined?(AUTO_LINK_REGEXP)
      keeps = []
      altered = body.gsub(/\[+.*?\]+/) do |match|
        keeps << match
        REP
      end
      altered.gsub(AUTO_LINK_REGEXP, "[[\\1]]").gsub(REP){|match| keeps.shift}
    else
      body
    end
  end
end