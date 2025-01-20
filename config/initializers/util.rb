# frozen_string_literal: true

module Util
  def self.capitalize_name(name)
    names = name.split(" ")
      names_capitalizes = names.map do |n|
        if %w[da de do dos das e].include?(n.downcase)
          n.downcase
        else
          n.capitalize
        end
      end
    names_capitalizes.join(" ")
  end
end
