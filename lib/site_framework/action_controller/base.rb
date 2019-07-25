ActionController::Base.class_eval do
  private def set_template_path
    site = Rails.application.site if Rails.application.respond_to?(:site)

    if site.present?
      return nil unless site.default_template.present?

      prefix = SiteFramework::Engine.view_path_prefix
      prepend_view_path "#{prefix}/#{site.default_template}"
    end
  end
end

ActionController::Base.instance_eval do
  before_action :set_template_path
end
