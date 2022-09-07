# frozen_string_literal: true

class AcceptJsonConstraint
  VALID_ACCEPT_VALUE = 'application/json'

  def matches?(request)
    VALID_ACCEPT_VALUE == request.format
  end
end
