# The Housecall Pro API Ruby client

Every method in this gem is one Housecall Pro endpoint. Where Housecall Pro has no endpoint,
this gem has no method — so a resource answers `update` only where Housecall Pro takes a `PUT`,
and a job, which it takes none for, answers none.

This release reads. Writing — beyond the leads that were here before it — comes next.

## How to install

```sh
gem install hcp
```

Or, in a Gemfile, pinned to the current major:

```ruby
gem 'hcp', '~> 1.3'
```

`~> major.minor` means `bundle update` never crosses a breaking change.

## The key, and the location

Set the key once. Left unset, the gem reads `HCP_KEY` from the environment:

```ruby
Hcp.key = ENV['HCP_KEY']
```

An account with more than one location passes `company_id:` per call, since one process may
serve several:

```ruby
Hcp::Job.find id, company_id: company_id
Hcp::Job.all(company_id: company_id).where(work_status: :scheduled)
```

## Reading

A list is walked lazily, a page read only once the one before it runs out, so asking for three
records costs one request rather than all of them:

```ruby
Hcp::Job.all
Hcp::Job.find id
Hcp::Job.limit 50
Hcp::Job.order updated_at: :desc
Hcp::Job.where scheduled_at: ..2.days.ago
Hcp::Job.where(customer_id: id).order(created_at: :asc).limit 10
Hcp::Job.all.count
```

A condition written as a range is sent as the two ends Housecall Pro takes, and an end left
open is left out:

```ruby
Hcp::Job.where scheduled_at: 2.days.ago..    # scheduled_start_min
Hcp::Job.where scheduled_at: ..2.days.ago    # scheduled_start_max
Hcp::Job.where scheduled_at: 1.week.ago..Time.now
```

Housecall Pro narrows a list by one set of words and answers with another, so this gem speaks
the narrower's words on both sides: `where(work_status: :in_progress)` and `job.work_status`
both say `:in_progress`.

Nothing comes back unasked. `includes` asks for what Housecall Pro otherwise leaves out:

```ruby
Hcp::Job.includes(:appointments).limit 20
```

A condition, an order or an expansion Housecall Pro does not take is refused here rather than
sent — it answers an unknown condition by ignoring it and handing back the whole account:

```ruby
Hcp::Job.where bogus: 1
# => Hcp::Error: bogus is not one of: scheduled_at, ends_at, customer_id, ...
```

### What each resource reads

```ruby
job = Hcp::Job.find id
job.description, job.work_status, job.total_amount, job.invoice_number
job.customer.name, job.address.city, job.assigned_employees, job.notes, job.tags
job.schedule.starts_at, job.schedule.time_zone, job.completed_at
job.appointments, job.line_items, job.invoices

customer = Hcp::Customer.where(q: 'Ada').first
customer.name, customer.email, customer.phone, customer.kind, customer.addresses

estimate = Hcp::Estimate.find id
estimate.estimate_number, estimate.options.map(&:total_amount)
```

Housecall Pro counts money in cents; this gem reads it in dollars, as a `BigDecimal`.

## Errors

Everything descends from `Hcp::Error`, so one rescue still catches the lot.

```ruby
Hcp::NotFound         # Housecall Pro has no record under that ID
Hcp::TooManyRequests  # refused for rate; #reset_at says when it lifts
```

Nothing here sleeps. A caller told to come back later has a queue that can bring the whole job
back, which is worth more than a worker asleep holding a connection open.

## Leads

Opening a lead, and moving one through the pipeline, are unchanged:

```ruby
lead = Hcp::Lead.new key:, company_id:
lead.create name: 'Ada', phone: '5550000001', email: 'ada@example.com',
  address: { street: '1 Example Street', city: 'Springfield', state: 'CA', zip: '90210' },
  note: 'Very interested in buying', source: 'The Lead Generator'

pipeline = Hcp::Lead::Pipeline.new id:, key:, company_id:
pipeline.update status_name: 'Won'
```

## Webhooks

`Hcp::Event` reads a webhook payload, and reaches the network for nothing:

```ruby
event = Hcp::Event.new params
event.type            # :job_scheduled
event.job_id, event.customer_id, event.scheduled_at, event.invoice_amount
```
