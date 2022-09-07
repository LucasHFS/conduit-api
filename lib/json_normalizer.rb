# frozen_string_literal: true

class JsonNormalizer
  def normalize(json)
    case json
    when Hash then json.to_h { |key, value| [key.to_s.underscore.to_sym, normalize(value)] }
    when Array then json.map { |item| normalize(item) }
    else json
    end
  end
end
