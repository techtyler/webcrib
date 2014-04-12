# To change this template, choose Tools | Templates
# and open the template in the editor.

module Crib
  class Deck

    def initialize
      initialize_deck
    end

    def initialize_deck
      @cards = []
      (1..4).each { |i|
        (1..13).each { |j|
          @cards << Card.new(j, i)
        }
      }
      @cards.shuffle!
    end

    def deal_card
      @cards.pop
    end

    def cut_deck(excluded_cards)


      initialize_deck

      excluded_cards.each { |tmp|
        @cards.delete_if { |x| x.number == tmp.number && x.suit == tmp.suit }
      }

      #TODO Validate sizing?
      @cards[rand(32) + 4]

    end


    def deal_crib_hands

      initialize_deck
      hand_1 = []
      hand_2 = []
      (0..11).each { |i|
        card = deal_card

        if (i % 2 == 0)
          hand_2 << card
        else
          hand_1 << card
        end
      }

      return hand_1, hand_2

    end

  end
end