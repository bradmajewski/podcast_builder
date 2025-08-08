module AttributeCastMethods
  extend ActiveSupport::Concern

  class_methods do
    def boolean_date_methods(attribute_at)
      attribute = attribute_at.to_s.chomp("_at")

      getter = proc { self[:"#{attribute}_at"].present? }
      define_method(attribute, &getter)
      define_method("#{attribute}?", &getter)

      define_method("#{attribute}!") do
        update_column(:"#{attribute}_at", Time.current)
      end

      define_method("#{attribute}=") do |value|
        if ActiveModel::Type::Boolean.new.cast(value)
          self[:"#{attribute}_at"] ||= Time.current
        else
          self[:"#{attribute}_at"] = nil
        end
      end
    end
  end
end
