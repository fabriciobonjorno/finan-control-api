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

  def self.password_regex(password)
    password =~ /\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{8,}\z/
  end

  def self.company_data(document)
    url = "https://publica.cnpj.ws/cnpj/#{document}"
    HTTParty.get(url)
  rescue StandardError => e
    Rails.logger.error("Erro ao buscar dados da empresa: #{e.message}")
    nil
  end

  def self.normalize_customer_name(document, legal_name)
    document = document.gsub(/\D/, "").strip
    "#{document}_#{legal_name}".parameterize(separator: "_")
  end
end
