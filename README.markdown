# Admin Notices #

## Example trigger (observer) ##

    # config/intializers/admin_notices.rb
    NoticableEventsObserver.default_url_options[:host] = 'abc.com'

    # noticable_events_observer.rb
    class NoticableEventsObserver < ActiveRecord::Observer
      include ActionController::UrlWriter if Object.const_defined?(:ActionController)

      observe :user, :coral, :image

      def after_create(obj)
        title, status = generate_title_and_status(obj)
        url = generate_url(obj)
        Admin::Notice.create!(:title => title, :status => status, :url => url, :object_type => obj.class.name, :object_id => obj.id)
      rescue => e
        RAILS_DEFAULT_LOGGER.error("Error creating notice: #{e.message}\n")
        HoptoadNotifier.notify(e, :parameters => { :object => obj, :object_class => obj.class.name })
      end

      private
      def generate_title_and_status(obj)
        if obj.is_a?(User)
          ["User signup", "#{obj.login} signed up!"]
        elsif obj.is_a?(Image)
          ["Image created", "Image #{obj.title} created under #{obj.user.login}!"]
        end
      end

      def generate_url(obj)
        url_info = obj.respond_to?(:user) ? [obj.user] : []
        url_info << obj
        polymorphic_url(url_info)
      end
    end

### Note ###
This requires mongo for storing the notice data right now.

Originally created by Richie Vos
[@richievos](http://twitter.com/richievos)
[github.com/jerryvos](http://github.com/jerryvos)
[esopp.us](http://esopp.us)
[reeflines.com](http://reeflines.com)