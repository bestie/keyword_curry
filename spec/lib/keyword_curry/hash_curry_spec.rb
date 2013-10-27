require "spec_helper"

require "keyword_curry/hash_curry"

describe HashCurry do
  describe "#hash_curry" do
    before(:all) {
      Proc.prepend(HashCurry)
    }

    let(:proc_to_curry) {
      Proc.new { |*args| spy.proc_was_called(*args) }
    }

    let(:spy) {
      double(:spy, :proc_was_called => "return value")
    }

    let(:proc_return_value) { double(:proc_return_value) }

    let(:arg_one) {
      { one: 1 }
    }

    let(:arg_two) {
      { two: 2 }
    }

    let(:arg_three) {
      { three: 3 }
    }

    it "returns another proc_to_curry" do
      expect(proc_to_curry.hash_curry(1)).to  be_a Proc
    end

    context "with an arity of 1" do
      let(:arity) { 1 }

      it "immediately calls the proc_to_curry with args given" do
        curried = proc_to_curry.hash_curry(arity)

        curried.call(arg_one)

        expect(spy).to have_received(:proc_was_called).with(arg_one)
      end
    end

    context "with an arity greater than 1" do
      let(:arity) { 3 }

      it "calls the proc_to_curry after receiving `arity` hashes" do
        curried = proc_to_curry.hash_curry(arity)

        curried_called_once = curried.call(arg_one)
        curried_called_twice = curried_called_once.call(arg_two)
        curried_called_thrice = curried_called_twice.call(arg_three)

        expect(spy).to have_received(:proc_was_called)
      end

      it "can receive more than one hash at a time" do
        curried = proc_to_curry.hash_curry(arity)

        curried_called_once_with_two = curried.call(arg_one, arg_two)
        curried_called_twice = curried_called_once_with_two.call(arg_three)

        expect(spy).to have_received(:proc_was_called)
      end

      it "does not call the proc_to_curry before it receives `arity` hashes" do
        curried = proc_to_curry.hash_curry(arity)

        curried_called_once = curried.call(arg_one)
        curried_called_twice = curried_called_once.call(arg_two)

        expect(spy).not_to have_received(:proc_was_called)
      end

      it "calls the proc_to_curry with a single hash argument" do
        curried = proc_to_curry.hash_curry(arity)

        curried_called_once = curried.call(arg_one)
        curried_called_twice = curried_called_once.call(arg_two)
        curried_called_thrice = curried_called_twice.call(arg_three)

        expect(spy).to have_received(:proc_was_called) do |*args|
          expect(args.length).to eq(1)
        end
      end

      it "calls the proc_to_curry with a hash that is the merge result of all passed hashes" do
        curried = proc_to_curry.hash_curry(arity)

        curried_called_once = curried.call(arg_one)
        curried_called_twice = curried_called_once.call(arg_two)
        curried_called_thrice = curried_called_twice.call(arg_three)

        expect(spy).to have_received(:proc_was_called).with(
          :one => 1,
          :two => 2,
          :three => 3,
        )
      end

      it "merges the hashes in the order they are given" do
        curried = proc_to_curry.hash_curry(arity)

        curried_called_once = curried.call(
          :overwrite_me => "not_overwritten",
        )

        curried_called_twice = curried_called_once.call(
          :whatever => "whatever",
        )

        curried_called_thrice = curried_called_twice.call(
          :overwrite_me => "overwritten",
        )

        expect(spy).to have_received(:proc_was_called).with(
          :whatever => "whatever",
          :overwrite_me => "overwritten",
        )
      end
    end
  end
end
