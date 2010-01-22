module Admin
  class NoticesController < ApplicationController
    def index
      @rss_url = admin_notices_url(:api_key => current_user.single_access_token, :format => 'rss')
      @notices = Notice.find(:all, :limit => 100, :order => 'created_at desc')
      respond_to do |wants|
        wants.html
        wants.rss
      end
    end
  end
end
AdminNotices.configuration.load_config('controller')