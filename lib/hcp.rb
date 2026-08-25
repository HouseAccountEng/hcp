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
require 'hcp/errors/not_found'
require 'hcp/errors/too_many_requests'
require 'hcp/key'

# Answer before Request, which reads one, and Filter before Relation, which writes them.
require 'hcp/answer'
require 'hcp/request'
require 'hcp/filter'
require 'hcp/concerns/chainable'
require 'hcp/relation'
require 'hcp/concerns/queryable'
require 'hcp/resource'

# Every concern before the records including it, and Schedule before Scheduled, which reads one.
require 'hcp/concerns/named'
require 'hcp/concerns/timestamped'
require 'hcp/concerns/statused'
require 'hcp/resources/schedule'
require 'hcp/concerns/scheduled'

require 'hcp/resources/address'
require 'hcp/resources/employee'
require 'hcp/resources/line_item'
require 'hcp/resources/note'
require 'hcp/resources/customer'

# A job before the collections named under it, which its constant has to exist for.
require 'hcp/resources/job'
require 'hcp/resources/job/appointment'
require 'hcp/resources/job/invoice'

require 'hcp/resources/estimate'
require 'hcp/resources/estimate/option'

require 'hcp/concerns/keyed'
require 'hcp/lead'
require 'hcp/lead/pipeline'

require 'hcp/event'
