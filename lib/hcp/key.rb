module Hcp
  class << self
    # The Housecall Pro API key every request is read with.
    attr_writer :key

    # @return [String, nil] the key this module was given, or the one the environment carries.
    def key = @key || ENV['HCP_KEY']
  end
end
