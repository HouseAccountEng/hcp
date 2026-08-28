module Hcp
  # A slot the account's online booking settings leave open for work to be booked into.
  class BookingWindow < Resource
    # How Housecall Pro writes the moment a range is looked at from.
    STAMP = '%Y-%m-%dT%H:%M:%S'

    class << self
      # Where Housecall Pro keeps them.
      def path = 'company/schedule_availability/booking_windows'

      # What Housecall Pro calls a list of them.
      def key = 'booking_windows'

      # Housecall Pro answers these whole rather than a page at a time, so they are read in one
      # request rather than walked, and there is no list left to narrow, order or cut.
      # @param starts_at [Date, Time, nil] where to look from; the next day holding a free
      #   window where left out.
      # @param days [Integer, nil] how many days of the schedule to look at; seven where left out.
      # @param minutes [Integer, nil] how wide to cut each window; the service's own duration,
      #   or thirty minutes, where left out.
      # @param service_id [String, nil] the service whose assigned pros to look at.
      # @param price_form_id [String, nil] the price form whose assigned pros to look at.
      # @param employee_ids [Array<String>, nil] the pros to look at, rather than all of them.
      # @param company_id [String, nil] the location to read as, where the account has several.
      # @return [Array<BookingWindow>] every window in the range, free and taken alike.
      def all(starts_at: nil, days: nil, minutes: nil, service_id: nil, price_form_id: nil,
        employee_ids: nil, company_id: nil)
        params = { start_date: stamp(starts_at), show_for_days: days, service_id: service_id,
          service_duration: minutes, price_form_id: price_form_id, employee_ids: employee_ids, }
        read(params, company_id).fetch(key).
          map { |node| new node: node, company_id: company_id }
      end

    private

      def stamp(value) = value&.strftime(STAMP)

      def read(params, company_id)
        Request.new(path: path, params: params, company_id: company_id).body
      end
    end

    # @return [Time, nil] when the window opens.
    timestamp :starts_at, :start_time

    # @return [Time, nil] when the window closes.
    timestamp :ends_at, :end_time

    # @return [Boolean] whether the account is free to take work in the window.
    def available? = @node['available']
  end
end
