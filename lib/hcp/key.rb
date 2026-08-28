module Hcp
  class << self
    # The Housecall Pro API key every request is read with, where a thread holds none of its own.
    attr_writer :key

    # @return [String, nil] the key this thread was handed, the one this module was given, or
    #   the one the environment carries.
    def key = ActiveSupport::IsolatedExecutionState[:hcp_key] || @key || ENV['HCP_KEY']

    # Reads as this key for the block, on this thread alone, so a process serving several
    # accounts can hold a key on every thread without any of them seeing another's.
    # @param key [String] the key to read with.
    # @param company_id [String, nil] the location to read as, where the account has several.
    # @yieldparam access [Access] the account the key opens.
    # @return [Object] what the block answered.
    def with_key(key, company_id: nil)
      previous = ActiveSupport::IsolatedExecutionState[:hcp_key]
      ActiveSupport::IsolatedExecutionState[:hcp_key] = key
      yield Access.new(company_id: company_id)
    ensure
      ActiveSupport::IsolatedExecutionState[:hcp_key] = previous
    end
  end
end
