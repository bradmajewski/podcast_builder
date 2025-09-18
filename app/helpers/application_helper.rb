module ApplicationHelper
  def bi(icon_name, **kwargs)
    kwargs[:class] = "bi bi-#{icon_name} #{kwargs[:class]}"
    tag.i(**kwargs)
  end

  def bi_edit(text=nil) = bi('pencil-square', title: text)
  def bi_delete(text=nil) = bi('trash-fill', title: text)

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
end
