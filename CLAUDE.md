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

A company-scoped key refuses `X-Company-Id` with a 401 on every endpoint, so the header can only
be exercised with an application key. `GET /company` answers `locations` only to the latter, and
nests: a location holds locations of its own, several levels deep.
