require 'bigdecimal'
require 'json'
require 'net/http'
require 'time'

# Only the Active Support files whose methods are used, rather than the whole of it: a name
# Housecall Pro holds nothing for arrives as readily empty as null, a query is written the
# way `to_query` writes one, and a moment minus a duration is a moment.
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_query'

# The vocabulary the account answers in.
require 'company'

require 'hcp/version'
require 'hcp/error'
require 'hcp/too_many_requests'

# Answer before Client, which reads one, and Client before everything that talks through it.
require 'hcp/answer'
require 'hcp/client'
require 'hcp/business'
require 'hcp/lead'
require 'hcp/leads'

# Every record before the one that reads it beside itself, and the job before its list.
require 'hcp/customer'
require 'hcp/location'
require 'hcp/line'
require 'hcp/quote'
require 'hcp/visit'
require 'hcp/job'
require 'hcp/jobs'
require 'hcp/visits'
require 'hcp/account'
require 'hcp/event'
