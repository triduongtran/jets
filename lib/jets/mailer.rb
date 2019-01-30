require 'action_mailer'

module Jets
  # Reference: https://github.com/rails/rails/blob/master/actionmailer/lib/action_mailer/railtie.rb
  class Mailer < ::Jets::Turbine
    config.action_mailer = ActiveSupport::OrderedOptions.new

    initializer "action_mailer.logger" do
      ActiveSupport.on_load(:action_mailer) { self.logger ||= Jets.logger }
    end

    initializer "action_mailer.set_configs" do |app|
      options = app.config.action_mailer
      options.default_url_options ||= {}
      options.default_url_options[:protocol] ||= "https"
      options.show_previews = Jets.env.development? if options.show_previews.nil?
      options.preview_path ||= "#{Jets.root}/spec/mailers/previews" if options.show_previews
      options.view_paths ||= "#{Jets.root}/app/views"

      # TODO: figure this out. Dont think respecting asset_host the same way
      # make sure readers methods get compiled
      # options.asset_host          ||= app.config.asset_host
      # options.relative_url_root   ||= app.config.relative_url_root

      ActiveSupport.on_load(:action_mailer) do
        # TODO: figure out helpers
        # include AbstractController::UrlFor
        # extend ::AbstractController::Railties::RoutesHelpers.with(app.routes, false)
        # include app.routes.mounted_helpers

        register_interceptors(options.delete(:interceptors))
        register_preview_interceptors(options.delete(:preview_interceptors))
        register_observers(options.delete(:observers))

        options.each { |k, v| send("#{k}=", v) }
      end
    end
  end
end
