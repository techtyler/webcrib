
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

        sorted = cards.sort {|a,b| a.number <=> b.number}  #these might already be sorted?
        if (sum + sorted.first.value > 31)
          return -1 #value for not being able to play
        end

        # last_valid = 0
        # if sorted.last.number + sum < 32  #We can assume last is not the same card as first
        #   last_valid = sorted.size - 1
        # else
        #   (1..sorted.size-1).each do |i|
        #     if (sorted[i].number + sum > 31)
        #       last_valid = i-1
        #       break
        #     else
        #       last_valid += 1
        #     end
        #   end
        # end
        #
        # if last_valid == 0  #Don't bother looking for better plays, this is your only one!
        #   return cards.first
        # end
        #
        # highest_score = determine_highest_score(peg_stack, cards[0..last_valid], sum)


        #plays highest card if possible. otherwise smallest
        if sorted.last.value + sum < 32
          return sorted.last
        else
          return sorted.first
        end

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

      def eval_throw(card1, card2)
        #returns a negative number representing the avg crib advantage
        #if card1 and card2 are enough to score (pair or sum = 15), then return -2 + avg 4card including
      end


      def self.throw_to_crib(cards, dealer)



        #todo: score_hand and mark used cards
        #numbers; 0,2,3,4,5,6
        #when 0
          #ex 2 4 6 8 10 J
            #your crib,
        #when 2
          #find best 2 to keep, other best to throw?
          #ex 2 4 6 8 J J (my crib throw 68, opp opp. crip throw 2 8 HARD DECISION THO
          #ex 1 3 10 J K 8

        #when 3
          #find best hand potential - crib
        #when 4
          #throw other two (dealer doesn't matter)
        #when 5
        #ex (1 5 6 6 7 K) [Throw K1 either way since you would rather throw the king instead of a 5,6, or 7] (Ace doesn't help score)
        #ex (4 5 7 7 8 J) (5 cards used, not all are used together (two full house really))  [my crib J5, opp J4]
        #ex (8 10 J Q Q K) (throw K8 to opp and 10 8 to myself)
          #ex ( 6 7 8 9 6 J) (#personal choice is throw J 6 to opp crib and J9 to my crib)
                                  #reasoning (6678 and 6789 are actually both 8pts (not taking cut potential into account) and J6 is harder to chain than J9)
          #assume that you are going to throw the 6th card

          #max of hands minus a card ( destroying a pair may reduce score more than the (4X2) run for example )

        #ex 6 7 7 7 8 K

        #ex 2 2 3 5 J K (your crib: throw J5, opp throw K 2 )

          #keep the one with the highest potential with cut included?
          #this would mean you would thrown the 7 instead of the 6 since 6778 could be 24 with a 6/8 and 7778 can only be 20 with an 7/8 and 21 with a 9/6
        #when 6
          #ex (4 4 5 5 6 6)
            #do 5 to eliminate throws like (55, 66, 44) since they reduce score a lot
            #then remove dups to reduce total decisions? (if i'm throwing a 4, it often doesn't matter which)
                #essentially, try to make the suit a secondary decision if you are breaking up a pair
                  #EX: you want to throw the 4 and the 6 of the same suit to your own crib, and the opposite to the opponent crib


          #ex (1 2 3 4 5 6)



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
