class ApplicationRecord < ActiveRecord::Base
  include AttributeCastMethods
  primary_abstract_class
end
