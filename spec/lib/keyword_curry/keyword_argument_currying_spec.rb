require "spec_helper"

require "keyword_curry"
require "keyword_curry/keyword_argument_currying"

describe KeywordCurry::KeywordArgumentCurrying do
  before(:all) {
    KeywordCurry.monkey_patch_proc
  }

  describe "#curry" do
    let(:spy) {
      double(:spy, :proc_was_called => "return value")
    }

    let(:proc_return_value) { double(:proc_return_value) }

    let(:pos1) { double(:pos1) }
    let(:pos2) { double(:pos2) }
    let(:key1) { double(:key1) }
    let(:key2) { double(:key2) }

    context "with positional args" do
      let(:proc_to_curry) {
        Proc.new { |pos1, pos2|
          spy.proc_was_called(pos1, pos2)
          proc_return_value
        }
      }

      context "when less then the required args have been passed" do
        it "does not call the proc_to_curry" do
          proc_to_curry.curry.call(pos1)

          expect(spy).not_to have_received(:proc_was_called)
        end

        it "returns another proc_to_curry" do
          curried = proc_to_curry.curry.call(pos1)

          expect(curried).to be_a Proc
        end
      end

      context "when all required arguments are passed together" do
        it "immediately calls the proc_to_curry" do
          proc_to_curry.curry.call(pos1, pos2)

          expect(spy).to have_received(:proc_was_called).with(pos1, pos2)
        end

        it "returns the proc_to_curry's return value" do
          return_value = proc_to_curry.curry.call(pos1, pos2)

          expect(return_value).to be proc_return_value
        end
      end

      context "when all required args are passed separately" do
        it "calls the proc_to_curry" do
          proc_to_curry.curry
            .call(pos1)
            .call(pos2)

          expect(spy).to have_received(:proc_was_called).with(pos1, pos2)
        end

        it "returns the proc_to_curry's return value" do
          return_value = proc_to_curry.curry
            .call(pos1)
            .call(pos2)

          expect(return_value).to be proc_return_value
        end
      end
    end

    context "with keyword arguments" do
      context "with only optional keyword arguments" do
        let(:proc_to_curry) {
          Proc.new { |key1: nil|
            spy.proc_was_called(key1: key1)
            proc_return_value
          }
        }

        it "immediately calls the proc_to_curry" do
          proc_to_curry.curry.call(key1: key1)

          expect(spy).to have_received(:proc_was_called).with(key1: key1)
        end

        it "returns the proc_to_curry's return value" do
          return_value = proc_to_curry.curry.call(key1: key1)

          expect(return_value).to be proc_return_value
        end
      end

      context "with required keyword arguments" do
        let(:proc_to_curry) {
          Proc.new { |key1:, key2:|
            spy.proc_was_called(key1: key1, key2: key2)
            proc_return_value
          }
        }

        context "before all required keywords are received" do
          it "does not call the proc_to_curry" do
            proc_to_curry.curry.call(key1: key1)

            expect(spy).not_to have_received(:proc_was_called)
          end

          it "returns another proc_to_curry" do
            curried_proc_to_curry = proc_to_curry.curry.call(key1: key1)

            expect(curried_proc_to_curry).to be_a Proc
          end
        end

        context "when all required keywords are received together" do
          it "calls the proc_to_curry with all keyword arguments" do
            proc_to_curry.curry.call(key1: key1, key2: key2)

            expect(spy).to have_received(:proc_was_called)
              .with(key1: key1, key2: key2)
          end

          it "returns the proc_to_curry's return value" do
            return_value = proc_to_curry.curry.call(key1: key1, key2: key2)

            expect(return_value).to be proc_return_value
          end
        end

        context "when all required args are passed separately" do
          it "calls the proc_to_curry" do
            proc_to_curry.curry
              .call(key1: key1)
              .call(key2: key2)

            expect(spy).to have_received(:proc_was_called)
              .with(key1: key1, key2: key2)
          end

          it "returns the proc_to_curry's return value" do
            return_value = proc_to_curry.curry
              .call(key1: key1)
              .call(key2: key2)

            expect(return_value).to be proc_return_value
          end
        end
      end
    end

    context "with mixed positional and keyword args" do
      let(:proc_to_curry) {
        Proc.new { |pos1, pos2, key1:, key2:|
          spy.proc_was_called(pos1, pos2, key1: key1, key2: key2)
          proc_return_value
        }
      }

      let(:pos1) { double(:pos1) }
      let(:pos2) { double(:pos2) }
      let(:key1) { double(:key1) }
      let(:key2) { double(:key2) }

      context "when all args are passed together" do
        it "immediately calls the proc_to_curry" do
          proc_to_curry.curry
            .call(pos1, pos2, key1: key1, key2: key2)

          expect(spy).to have_received(:proc_was_called)
            .with(pos1, pos2, key1: key1, key2: key2)
        end

        it "returns the proc_to_curry's return value" do
          return_value = proc_to_curry.curry
            .call(pos1, pos2, key1: key1, key2: key2)

          expect(return_value).to be proc_return_value
        end
      end

      context "when all positional arguments are passed" do
        context "but no keywords are passed" do
          it "does not call the proc_to_curry" do
            proc_to_curry.curry.call(pos1, pos2)

            expect(spy).not_to have_received(:proc_was_called)
          end

          it "returns another proc_to_curry" do
            curried_proc_to_curry = proc_to_curry.curry.call(pos1, pos2)

            expect(curried_proc_to_curry).to be_a Proc
          end
        end

        context "before all required keywords have been received" do
          it "does not call the proc_to_curry" do
            proc_to_curry.curry
              .call(pos1, pos2)
              .call(key1: key1)

            expect(spy).not_to have_received(:proc_was_called)
          end

          it "returns another proc_to_curry" do
            curried_proc_to_curry = proc_to_curry.curry
              .call(pos1, pos2)
              .call(key1: key1)

            expect(curried_proc_to_curry).to be_a Proc
          end
        end

        context "and all required keywords have been received" do
          it "calls the proc_to_curry" do
            proc_to_curry.curry
              .call(pos1, pos2)
              .call(key1: key1)

            expect(spy).not_to have_received(:proc_was_called)
          end

          it "returns the proc_to_curry's return value" do
            return_value = curried_proc_to_curry = proc_to_curry.curry
              .call(pos1, pos2)
              .call(key1: key1)
              .call(key2: key2)

            expect(return_value).to be proc_return_value
          end
        end
      end
    end

    context "with splatted positional arguments and keyword arguments" do
      let(:proc_to_curry) {
        Proc.new { |*positional_args, key1:, key2:|
          spy.proc_was_called(*positional_args, key1: key1, key2: key2)
          proc_return_value
        }
      }

      it "only accepts positional args on the first call" do
        curred_with_pos1 = proc_to_curry.curry.call(pos1)

        expect {
          curred_with_pos1.call(pos2)
        }.to raise_error(/missing keywords: key1, key2/)
      end

      it "will accept any number of positional arguemnts on the first call" do
        curried_with_positional_args = proc_to_curry.curry.call(
          pos1, pos2, "something else"
        )

        curried_with_positional_args.call(key1: key1, key2: key2)

        expect(spy).to have_received(:proc_was_called)
          .with(pos1, pos2, "something else", key1: key1, key2: key2)
      end

      it "can curry keywords with the first call" do
        curred_with_pos1_key1 = proc_to_curry.curry.call(pos1, key1: key1)

        curred_with_pos1_key1.call(key2: key2)

        expect(spy).to have_received(:proc_was_called)
          .with(pos1, key1: key1, key2: key2)
      end

      it "can curry keywords after first call" do
        curred_with_pos1 = proc_to_curry.curry.call(pos1)

        curred_with_pos1
          .call(key1: key1)
          .call(key2: key2)

        expect(spy).to have_received(:proc_was_called)
          .with(pos1, key1: key1, key2: key2)
      end

      context "when two positional and all keyword arguments are passed together" do
        it "immediately calls the proc with all positional and keyword arguments" do
          proc_to_curry.curry
            .call(pos1, pos2, key1: key1, key2: key2)

          expect(spy).to have_received(:proc_was_called)
            .with(pos1, pos2, key1: key1, key2: key2)
        end
      end

      context "when two positional and all keyword arguments are passed together" do
        it "immediately calls the proc with all positional and keyword arguments" do
          proc_to_curry.curry
            .call(pos1, pos2, key1: key1)

          expect(spy).not_to have_received(:proc_was_called)
        end
      end
    end
  end
end
