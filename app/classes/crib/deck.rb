# To change this template, choose Tools | Templates
# and open the template in the editor.

module Crib
  class Deck

    def initialize
      initialize_deck
    end

    def initialize_deck
      @cards = []
      for i in 1..4
        for j in 1..13
          @cards << Card.new(j,i)
        end
      end
      @cards.shuffle!
    end

    def deal_card
      @cards.pop
    end

    def cut_deck(hand1, hand2)

      initialize_deck
      begin
        cut_index = rand(32) + 4
        card = @cards[cut_index]
      end while (hand1.contains(card) || hand2.contains(card))

      return card

    end


    def deal_crib_hands

      initialize_deck
      hand_1 = []
      hand_2 = []
      for i in 0..11
        card = deal_card

        if (i % 2 == 0)
          hand_2 << card
        else
          hand_1 << card
        end
      end

      return hand_1, hand_2

    end

  end
end