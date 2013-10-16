
module Crib
  module Util
    class CribAIGordon

      def self.peg_card(cards, peg_stack, sum)
        return nil if (not cards) || cards.empty?


        if cards.size == 1
          if cards.first.value + sum < 32
            return cards.first
          else
            return -1
          end
        end

        sorted = cards.sort {|a,b| a.number <=> b.number}
        if (sum + sorted.first.value > 31)
          return -1 #value for not being able to play
        end

        return sorted.first

        #TODO Make this algorithm more intelligent, consider the following
          #Stats (run a lot of cases and see what works out?)
          #Always pair (sometimes defend triples?)
          #always 31, 15?
          #always run? (prevent if a longer run is possible?)
          #never start with a 5 if possible
          #2, 10, 3 combo
          # never 15 with 7/8
          # never allow combos (runs, sum, pairs, etc)


      end


      def self.throw_to_crib(cards, dealer)

        #validate we have 6 cards?

        #if dealer
        #
        #else
        #
        #end
        return 0,1 #throw first two cards

        #TODO Next (Keep highest scoring 4card hand, if multiple choose first)


        #TODO Make this algorithm more intelligent, consider the following
          #Stats(run a lot of rounds and see what works best?)
          #never throw 7/8, to opponent crib
          #attempt to make your own crib as good as possible
          #attempt to keep good cards for pegging if needed
          #attempt to keep cards with good cut opportunities


      end


    end
  end
end
