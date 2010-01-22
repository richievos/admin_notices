module Admin
  class Notice
    include MongoMapper::Document

    key :status
    key :title
    key :url
    timestamps!

    after_save :fire_tweet

    def fire_tweet
      AppTweeter.update(status, url) if Rails.env.production?
    end
  end
end