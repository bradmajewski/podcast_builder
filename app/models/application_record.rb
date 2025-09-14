class ApplicationRecord < ActiveRecord::Base
  include AttributeCastMethods
  primary_abstract_class

  def render_to_string(...)
    ApplicationController.new.render_to_string(...)
  end
end
