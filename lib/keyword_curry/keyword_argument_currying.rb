module KeywordCurry::KeywordArgumentCurrying
  def curry(arity = arity)
    required_keywords = parameters
      .select { |param| param.first == :keyreq }
      .map    { |param| param.last }

    if required_keywords.empty?
      super
    else
      curried_proc = self
      collected_positional_args = []
      collected_keyword_args = {}

      keyword_currier = Proc.new { |keywords|
        curried_proc.call(keywords) unless keywords.is_a?(Hash)

        collected_keyword_args.merge!(keywords)

        outstanding_keywords = required_keywords - collected_keyword_args.keys

        if outstanding_keywords.empty?
          curried_proc.call(*collected_positional_args, collected_keyword_args)
        else
          keyword_currier
        end
      }

      positional_argument_handler = Proc.new { |*args|
        if arity == -1
          keyword_args = args.last if args.last.is_a?(Hash)

          if keyword_args
            positional_args = args[0..-2]
          else
            positional_args = args
            keyword_args = {}
          end
        else
          positional_args = args.take(curried_proc.arity)
          keyword_args = args[curried_proc.arity..-1].first || {}
        end

        collected_positional_args += positional_args
        keyword_currier.call(keyword_args)
      }

      if arity == 0
        keyword_currier
      else
        positional_argument_handler.curry(arity)
      end
    end
  end
end
