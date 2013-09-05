
module Crib
  class CribPlayer

    def initialize
      @score = 0

      @cards = []
    end

    def new_hand(cards)
      @cards = cards
    end

    def set_crib( cards )
      @is_dealer = true
      @crib = cards
    end


    def peg_card(peg_stack, stack_sum)


      if (@peg_hand.empty?)
        return -1
      end
      if (stack_sum < 22)
        return @peg_hand.last
      else
        return @peg_hand.first
      end

    end

    def accept_card(card)

    end

    def score_cards(cut_card)
      HandCountingMethods.score_hand(@hand << cut_card, false)
    end

    def start_new_hand(cards)
      cards.sort
      @hand = cards.dup
      @peg_hand = cards.dup
    end

    def score
      @score
    end
  end
end