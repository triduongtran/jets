require "action_view"

# hackety hack
module Jets::UrlHelper
  include Jets::CommonMethods

  # Basic implementation of url_for to allow use helpers without routes existence
  def url_for(options = nil) # :nodoc:
    url = case options
          when String
            options
          when :back
            _back_url
          # TODO: hook this up to Jets implmentation of config/routes.rb
          # when ActiveRecord::Base
          #   record = options
          #   record.id
          else
            raise ArgumentError, "Please provided a String to link_to as the the second argument. The Jets link_to helper takes as the second argument."
          end

    puts "url before add_stage_name: #{url}"
    url2 = add_stage_name(url)
    puts "url2 #{url2}"
    url2
  end
end # UrlHelper
ActionView::Helpers.send(:include, Jets::UrlHelper)
