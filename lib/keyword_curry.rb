require "keyword_curry/version"
require "keyword_curry/keyword_argument_currying"

if RUBY_VERSION < "2.1.0"
  warn("WARNING: KeywordCurry can only be used with Ruby 2.1.0 and above.")
end

module KeywordCurry
  def self.monkey_patch_proc
    Proc.prepend(KeywordArgumentCurrying)
  end
end
