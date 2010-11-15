module Rutty
  module TagQueryGrammar
    class Tag < Treetop::Runtime::SyntaxNode; end

    class QueryGroup < Treetop::Runtime::SyntaxNode; end

    class GroupStart < Treetop::Runtime::SyntaxNode; end

    class GroupEnd < Treetop::Runtime::SyntaxNode; end

    class AndLiteral < Treetop::Runtime::SyntaxNode; end

    class OrLiteral < Treetop::Runtime::SyntaxNode; end
  end
end
