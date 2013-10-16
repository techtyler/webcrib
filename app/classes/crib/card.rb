module Crib  #TODO: Move Card/Deck to a PlayingCards Module/Gem?
  class Card

    def initialize (a = 1 + rand(13), b = 1 + rand(4))
      #Check if a and b are integers (0 < a < 4, 0 < b < 13)
      @number = a
      @suit = b

    end

    def suit
      @suit
    end

    def number
      @number
    end

    def value

      if @number > 10
        return 10
      end
      return @number
    end


  end
end