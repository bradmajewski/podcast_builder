module ApplicationHelper
  def dt(datetime, format: :system)
    datetime&.strftime(I18n.t("time.formats.#{format}"))
  end

  def recover_path(record)
    recovery_recover_path(model: record.class.name.underscore, id: record.id)
  end
end
