module Hcp
  # Extends a class handed its own key, as everything was before the key became global.
  module Keyed
  private

    def headers
      {
        'Authorization' => "Token #{@key}",
        'Content-Type' => 'application/json',
        'X-Company-Id' => @company_id,
      }.compact
    end
  end
end
