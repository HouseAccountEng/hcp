module Hcp
  # One condition a list is narrowed by, as the parameters Housecall Pro takes it as.
  class Filter
    # @param bounds [Array<Symbol>] the parameter for each end of a range, or the single one.
    # @param value [Object] a range, or the one value to match.
    def initialize(bounds:, value:)
      @bounds = bounds
      @value = value
    end

    # @return [Hash] the parameters to send, without the end the caller left open.
    def params
      return { @bounds.first => @value } unless @value.is_a? Range

      refuse
      low, high = @bounds
      { low => stamp(@value.begin), high => stamp(@value.end) }.compact
    end

  private

    # Housecall Pro reads both ends inclusively, so an excluded end would come back anyway.
    def refuse
      raise Error, "#{@bounds.first} takes one value, not a range" if @bounds.one?
      raise Error, "#{@bounds.last} cannot exclude its end" if @value.exclude_end? && @value.end
    end

    def stamp(value)
      case value
        when Time then value.utc.iso8601
        when Date then value.iso8601
        else value
      end
    end
  end
end
