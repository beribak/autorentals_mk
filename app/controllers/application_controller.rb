class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale
  helper_method :switch_locale_params

  private

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale].presence&.to_sym || I18n.default_locale
  end

  # Merge current params with the desired locale while preserving query string
  def switch_locale_params(locale)
    request.query_parameters.merge(locale: locale)
  end

  def default_url_options
    { locale: (I18n.locale unless I18n.locale == I18n.default_locale) }.compact
  end
end
