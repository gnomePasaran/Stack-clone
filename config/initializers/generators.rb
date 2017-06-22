Rails.application.config.generators do |g|
  g.test_framework  :rspec,
                    fixtures: true,
                    view_specs: false,
                    helper_specs: false,
                    routing_specs: false,
                    request_specs: false,
                    controller_specs: true
end
