## [Unreleased]

- [Feature] Read when the account is free to be booked into: `Hcp::BookingWindow.all`, taking
  `starts_at:`, `days:`, `minutes:`, `service_id:`, `price_form_id:` and `employee_ids:`.
  Housecall Pro answers this list whole rather than a page at a time, so it comes back as an
  `Array` rather than as a relation.

## [1.3.0] - 2026-08-25

- [Feature] Read customers, estimates, jobs and job appointments as an Active Record relation:
  `Hcp::Job.all`, `.where`, `.order`, `.limit`, `.includes`, `.find`, `.count` and `.first`,
  walked lazily a page at a time.
- [Feature] Set the API key once, with `Hcp.key` or `HCP_KEY`, and pass `company_id:` per call.
- [Feature] Narrow a list by a range — `where(scheduled_at: ..2.days.ago)` — and refuse a
  condition, an order or an expansion Housecall Pro does not take, which it answers by
  ignoring rather than by refusing.
- [Feature] Raise `Hcp::NotFound` where Housecall Pro has no such record, and
  `Hcp::TooManyRequests`, carrying `reset_at`, where it refuses one for rate. Both descend
  from `Hcp::Error`, so an existing rescue still catches them.
- [Fix] `require 'hcp'` defines `Hcp::VERSION`, which until now was only set as a side effect
  of Bundler evaluating the gemspec.
- [Breaking change] `Hcp::Lead#lead_for`, `#customer_for` and `#uri` are now private, and
  neither `Hcp::Lead` nor `Hcp::Lead::Pipeline` inherits from `Hcp::Resource`, which is now a
  record rather than a holder of credentials. Nothing documented ever called them.

## [1.2.4] - 2026-06-17

- [Fix] Set event.type when params is nil

## [1.2.3] - 2026-06-15

- [New] Parse estimate_id for :estimate_sent event

## [1.2.2] - 2026-06-15

- [Fix] Replace Net::HTTPOK with broader Net::HTTPSuccess

## [1.2.1] - 2026-06-10

- [Fix] Raise if Lead.create is not successful

## [1.2.0] - 2026-06-08

- [Fix] Raise if Lead::Pipeline.update is not successful

## [1.1.1] - 2026-05-28

- [Fix] Don't include query params in PUT /pipeline/statuses

## [1.1.0] - 2026-05-27

- [New] Add Hcp::Event

## [1.0.0] - 2026-05-15

- Initial release: Lead and Lead::Pipeline classes
