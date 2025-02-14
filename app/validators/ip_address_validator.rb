require "ipaddr"

class IpAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid_ip?(value)
      record.errors.add(attribute, options[:message] || "不是有效的 IP 地址")
    end
  end

private

  def valid_ip?(value)
    return false if value.blank?

    begin
      IPAddr.new(value)
      true
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end
