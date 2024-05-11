# frozen_string_literal: true

module ApplicationHelper
  def flash_class(flash_type)
    case flash_type.to_sym
    when :success then 'bg-green-400 text-white text-xl font-mono font-bold p-4'
    when :danger then 'bg-red-400 text-gray-100 text-xl font-mono font-bold p-4'
    else 'bg-blue-400 text-white text-xl font-mono font-bold p-4'
    end
  end
end
