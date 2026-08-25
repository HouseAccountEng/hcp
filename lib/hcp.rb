require 'bigdecimal'
require 'date'
require 'json'
require 'net/http'
require 'time'

# Only the Active Support files whose methods are used, rather than the whole of it: a name
# Housecall Pro holds nothing for arrives as readily empty as null, and its queries carry
# arrays in the bracketed form `to_query` writes.
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_query'

require 'hcp/error'
require 'hcp/not_found'
require 'hcp/too_many_requests'
require 'hcp/key'

# Answer before Request, which reads one, and Filter before Relation, which writes them.
require 'hcp/answer'
require 'hcp/request'
require 'hcp/filter'
require 'hcp/chainable'
require 'hcp/relation'
require 'hcp/queryable'
require 'hcp/resource'

# Every concern before the records including it, and Schedule before Scheduled, which reads one.
require 'hcp/timestamped'
require 'hcp/statused'
require 'hcp/schedule'
require 'hcp/scheduled'

require 'hcp/address'
require 'hcp/employee'
require 'hcp/line_item'
require 'hcp/note'
require 'hcp/customer'

# A job before the collections named under it, which its constant has to exist for.
require 'hcp/job'
require 'hcp/job/appointment'
require 'hcp/job/invoice'

require 'hcp/estimate'
require 'hcp/estimate/option'

require 'hcp/keyed'
require 'hcp/lead'
require 'hcp/lead/pipeline'

require 'hcp/event'
