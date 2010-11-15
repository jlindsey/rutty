module Rutty
  
  ##
  # The classes defined in here are used by {Rutty::Nodes#get_tag_query_filter} and 
  # {Rutty::Nodes#recursive_build_query_proc_string}. Mostly they exist to simplify unit
  # tests, to ensure that the correct logic paths are reached in those methods for differing
  # query strings.
  # 
  # @author Josh Lindsey
  # @since 2.3.0
  module Procs
    class SingleTagQuery < Proc; end

    class MultipleTagQuery < Proc; end

    class SqlLikeTagQuery < Proc; end
  end
end
