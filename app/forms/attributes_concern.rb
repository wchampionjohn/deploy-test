# frozen_string_literal: true

module AttributesConcern
  extend ActiveSupport::Concern
  include ActiveModel::AttributeAssignment

  module ClassMethods
    def attr_accessor(*args)
      merge_attributes!(args)
      super(*args)
    end

    def attr_reader(*args)
      merge_attributes!(args)
      super(*args)
    end

    def attributes
      @_attributes ||= []
      @_attributes.map(&:to_sym)
    end

  private

    def merge_attributes!(args)
      @_attributes ||= []
      @_attributes += args
      @_attributes.uniq!
    end
  end

  def initialize(attrs = {})
    assign_attributes(attrs || {})
  end

  def attributes
    self.class.attributes.inject({}) do |a, e|
      a.merge(e => public_send(e))
    end.with_indifferent_access
  end

  def attributes=(params = {})
    return if params.nil? || params.empty?
    if params.is_a?(ActionController::Parameters)
      params = params.permit!
    end
    params.to_hash.symbolize_keys!
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
