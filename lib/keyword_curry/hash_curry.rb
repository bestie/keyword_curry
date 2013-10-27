module HashCurry
  def hash_curry(hash_count)
    curried_proc = self
    hashes = []

    curry_again = Proc.new { |*args|
      hashes = hashes.concat(args)

      if hashes.size >= hash_count
        final_hash = hashes.reduce({}) { |agg, hash|
          agg.merge(hash)
        }

        curried_proc.call(final_hash)
      else
        curry_again
      end
    }
  end
end
