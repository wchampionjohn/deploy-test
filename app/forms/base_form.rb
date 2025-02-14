# frozen_string_literal: true

class BaseForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Attributes

  include ::AttributesConcern

  PERMITTED_PARAMS = []

  def is_new?
    @_is_new
  end

  def is_update?
    @_is_update
  end

  def base_error_sentence(prefix = nil)
    return nil if self.errors[:base].blank?

    base_error = self.errors[:base]&.join(", ")
    [prefix, base_error].compact.join(" ")
  end

  def error_sentence
    self.errors.full_messages.to_sentence
  end

  def self.form_errors(errors = {})
    case errors.class.to_s
    when "ActiveModel::Errors"
      # recusive exec
      self.form_errors(errors.as_json)
    when "Hash"
      # recusive exec
      errors.keys.inject({}) do |memo, key|
        case key.to_s.split(".").length
        when 2
          # * handle nested attributes errors
          # e.g. { "remittance.bank_code" = "some errors" } => { remittance_attributes: { bank_code: "some errors" } }
          nested_key, nested_key_attr = key.to_s.split(".")
          nested_key_attr_errors = {}
          nested_key_attr_errors[nested_key_attr] = self.form_errors(errors[key])
          memo["#{nested_key}_attributes"] = nested_key_attr_errors
          memo
        else
          value = self.form_errors(errors[key])
          memo[key] = value if value.present?
          memo
        end
      end
    when "Array"
      if errors.all? { |arr| arr.class.to_s == "String" }
        return errors.join("、")
      end
      if errors.all? { |arr| arr.class.to_s == "Hash" }
        return self.form_errors(errors.reduce({}, :merge))
      end

      errors.inject(nil) do |memo, value|
        case value.class.to_s
        when "ActiveModel::Errors"
          memo = (memo || {}).merge(self.form_errors(value.as_json)) # flatten array of hash, ex: [{...}] => {...}
          return memo
        when "Hash"
          memo = (memo || {}).merge(self.form_errors(value)) # flatten array of hash, ex: [{...}] => {...}
          return memo
        when "Array"
          memo = (memo || []) << value.map { |v| self.form_errors(v) }
          return memo
        when "String"
          memo = (memo || []) << value # keep origin
          return memo
        else
          memo
        end
      end
    else
      errors
    end
  end

  def form_errors
    self.class.form_errors(errors)
  end

private

  def init_form(model, params)
    # Concern behavior
    #   - assign each params to instance variable
    self.attributes = params

    # To know records has been created or not
    @_is_new = model.nil?
    @_is_update = !@_is_new

    # Use to method: `get_permitted`
    @_params = params
  end

  def get_permitted(whitelist = [])
    # By default, will slice attributes with `PERMITTED_PARAMS`
    #   - 1. slice `params.keys` parse for patch update
    #   - 2. slice given `whitelist` which attempt to save in model
    attributes.slice(*@_params.keys).slice(*whitelist)
  end

  def has_params?(key)
    ActiveSupport::HashWithIndifferentAccess.new(@_params).key? key
  end
end
