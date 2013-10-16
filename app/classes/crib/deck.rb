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
      excluded_cards = hand1.dup
      excluded_cards.concat(hand2.dup)

      for tmp in excluded_cards do
        @cards.delete_if{|x| x.number == tmp.number && x.suit == tmp.suit}
      end

      #TODO Validate sizing?
      @cards[rand(32) + 4]

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