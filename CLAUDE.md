# hcp

A Ruby client for the Housecall Pro API.

## Follow the coding guidelines

https://raw.githubusercontent.com/HouseAccountEng/guidelines/refs/heads/main/STYLE.md

Read them before writing, not after review. They are stricter than this code alone suggests: one
line of comment above every public declaration and none above a private one, no metaprogramming
except on an explicit instruction, no method that nothing calls, no rescue for an error that has
never happened, and a cap of 100 lines to a file and 50 Ruby files to a folder — both enforced by
`bundle exec rake`, which is the gate for everything here.

Two rules are easy to miss and expensive to undo: a commit message carries no trailer naming its
author, and a CHANGELOG entry says which of fix, feature or breaking change it is, because that is
what picks the version.

## Probe the API rather than trust its spec

The authoritative OpenAPI spec is at

    https://stoplight.io/api/v1/projects/housecallpro/housecall-public-api/nodes/reference/housecall.v1.yaml

docs.housecallpro.com renders it client-side, so fetching that HTML gets nothing worth reading.

**The spec disagrees with the live API.** Send a real request before writing code against a
documented shape. What has been found so far:

- A refusal comes back three ways -- `{"error":{"message":…}}`, `{"error":"…"}` and `{"message":…}`.
  The spec describes only the first.
- `PUT /pipeline/statuses` is answered with an empty body.
- `GET /jobs/{id}/line_items` answers `{"object":"list","data":[…]}`, not the documented
  `{url, data}`.
- `page_size` is capped at 200. The spec publishes no maximum.
- A job answers `schedule.appointments` only with `expand[]=appointments`, and `expand` must be
  sent as an array: a bare string is refused. A job's `scheduled_start` and `scheduled_end`
  are computed from its appointments, so a job booked across a window carries every
  appointment in it. An appointment has no address of its own.
- A job's `original_estimate_id` is the ID of the estimate **option** it was created from, an
  `est_` ID. `GET /estimates/{id}` takes the estimate's own `csr_` ID and answers
  `Estimate not found` for an option's, so an option is found by listing
  `GET /estimates?customer_id=` and searching the options. Probed live 2026-09-09.

A company-scoped key refuses `X-Company-Id` with a 401 on every endpoint, so the header can only
be exercised with an application key. `GET /company` answers `locations` only to the latter, and
nests: a location holds locations of its own, several levels deep.
