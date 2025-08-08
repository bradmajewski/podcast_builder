module ApplicationHelper
  def dt(datetime, format: :system)
    datetime&.strftime(I18n.t("time.formats.#{format}"))
  end
end
