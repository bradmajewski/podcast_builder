module ApplicationHelper
  def dt(datetime, format: :system)
    datetime&.strftime(I18n.t("time.formats.#{format}"))
  end

  def recover_path(record)
    recovery_recover_path(model: record.class.name.underscore, id: record.id)
  end

  def return_to_tag
    if params[:return_to].present?
      hidden_field_tag :return_to, params[:return_to]
    end
  end

  def hh_mm_ss(seconds)
    return "00:00:00" if seconds.nil? || seconds <= 0

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    format("%02d:%02d:%02d", hours, minutes, secs)
  end
end
