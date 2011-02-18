class PostalCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << I18n.t("activerecord.errors.messages.invalid_postal_code") if !is_postal_code(value)
  end
  
  private
  def is_postal_code(value)
    return true if value.nil? || value.empty?
    return true if value.match(/^\d{4}-\d{3}$/)!=nil
    return false
  end
end