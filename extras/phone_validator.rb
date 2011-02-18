class PhoneValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    record.errors[attribute] << I18n.t("activerecord.errors.messages.invalid_phone") if !is_phone(value)
  end
  
  private
  def is_phone(value)
    return true if value.nil? || value.empty?
    return true if value.match(/^\d{9}$/)!=nil
    return false
  end
end