module AttributeCastMethods
  extend ActiveSupport::Concern

  class_methods do
    # Allows you to treat a DateTime attribute in ending in "_at" as a boolean.
    # Creates methods: verified, verified?, and verified! (or bang_method: :verify!).
    def boolean_date_methods(attribute_at, bang_method: nil)
      attribute = attribute_at.to_s.chomp("_at")
      bang_method ||= "#{attribute}!"

      getter = proc { self[:"#{attribute}_at"].present? }
      define_method(attribute, &getter)
      define_method("#{attribute}?", &getter)

      define_method(bang_method) do
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
