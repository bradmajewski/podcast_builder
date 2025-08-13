class ApplicationController < ActionController::Base
  include Authentication
  before_action :resume_session
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :return_to_path

  private

  def return_to_path(fallback=nil)
    # Disallow returns to external sites by blocking http:// and //
    if params[:return_to]&.match? %r`\A/[^/]`
      params[:return_to]
    else
      # Protecting against somebody setting fallback to nil
      fallback || root_path
    end
  end

  # Prefixing this method with `redirect_` so `return_to` can be used as a variable
  def redirect_return_to(options = {}, response_options = {})
    redirect_to return_to_path(options), response_options
  end
end
