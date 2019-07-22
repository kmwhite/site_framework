ActionController::Base.class_eval do
  private def set_template_path
    if Rails.application.respond_to?(:site) && Rails.application.site.default_template.present?
      site = Rails.application.site
      return nil unless site.default_template.present?

      prefix = SiteFramework::Engine.view_path_prefix
      prepend_view_path "#{prefix}/#{site.default_template}"
    end
  end
end

ActionController::Base.instance_eval do
  before_action :set_template_path
end
