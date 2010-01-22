AppTweeter = Struct.new(:status, :url) do
  class << self
    def update(status, url)
      # status = "[#{Rails.env}] #{status}" unless Rails.env.production?
      Delayed::Job.enqueue AppTweeter.new(status, url)
    end
  end

  def perform
    if url
      self.url = bitly_ify(url)
      self.status = "#{status} #{url}"
    end

    raise "Twitter update failed" unless system(
      %{curl -u #{twitter_creds} -d "status=#{URI.escape(status)}" http://twitter.com/statuses/update.xml > /dev/null}
    )
  end

  private
  def twitter_creds
    "#{TwitterConfig[:notification_creds][:login]}:#{TwitterConfig[:notification_creds][:password]}"
  end

  def bitly_ify(long_url)
    bitly.shorten(long_url).short_url
  rescue => e
    RAILS_DEFAULT_LOGGER.debug "Error bitly'ifying #{long_url}, #{e.message}"
    long_url
  end

  def bitly
    Bitly.new(BitlyConfig[:login], BitlyConfig[:api_key])
  end
end