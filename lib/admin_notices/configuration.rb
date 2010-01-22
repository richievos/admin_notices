module AdminNotices
  class Configuration
    def load_config(name)
      if name == 'controller'
        Admin::ReportsController.class_eval &@controller_block
      end
    end

    def reports(&block)
      @reports_block ||= block
      load_config('reports')
    end

    def controller(&block)
      @controller_block ||= block
      load_config('controller')
    end
  end
end