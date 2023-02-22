# frozen_string_literal: true

# Main helper of App
module ApplicationHelper
  def get_nested_value(obj, key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      res = nil
      obj.find { |*a| res = get_nested_value(a.last, key) }
      res
    end
  end
end
