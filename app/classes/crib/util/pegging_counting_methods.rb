module Crib
  module Util
    class PeggingCountingMethods


      #stack is an array of ints
      def self.full_run_stack(stack)

        sorted_stack = stack.sort { |a,b| a.number <=> b.number  }
        sorted_stack.uniq! {|x| x.number }
        if (stack.size != sorted_stack.size)
          return false
        end
        return (sorted_stack.last.number - sorted_stack.first.number == sorted_stack.size - 1)

      end


      #should send in a dup of the stack, this removes stuff
      def self.score_run(stack)

        if (stack.size > 2)
          if (PeggingCountingMethods.full_run_stack(stack))
            return stack.size
          end

          stack.delete_at(0)
          return PeggingCountingMethods.score_run(stack)

        end
        return 0
      end


      def self.score_pair(stack)
        if (stack.size < 2)
          return 0
        end

        tmp_stack = stack.dup
        last_card = tmp_stack.pop
        score = 0

        next_card = tmp_stack.pop

        while (next_card.number == last_card.number)

          if (score == 0)
            score += 2
          elsif (score == 2)
            score += 4
          elsif (score == 6)
            score += 6
            break
          end

          if (tmp_stack.empty?)
            break
          else
            next_card = tmp_stack.pop
          end


        end

        return score

      end


      def self.score_stack(stack, sum)

        if sum == 31
          score = 2
        else
          score = 0
        end

        if sum == 15
          score += 2
        end



        score += score_run(stack)

        score += score_pair(stack)

        return score
      end

    end


  end
end

