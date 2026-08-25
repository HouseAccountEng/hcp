module Hcp
  # Something a pro wrote on a job or on an estimate option.
  class Note < Resource
    # @return [String, nil] what the note says.
    def content = @node['content']
  end
end
