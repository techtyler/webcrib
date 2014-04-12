module Crib  #TODO: Move Card/Deck to a PlayingCards Module/Gem?
  class Card

    def initialize (a = 1 + rand(13), b = 1 + rand(4))
      #Check if a and b are integers (0 < a < 5, 0 < b < 14)
      @number = a
      @suit = b

    end

    def from_id(id)
      #id = 1 -> 52
      #id =1 ==> AC (1,1) id = 13 ==> KC(13,1), id = 14 ==> AH(1,2)

      @suit = (id - 1)/13 + 1
      @number = (id - 13*(@suit - 1)) + 1
    end

    def to_id
      return (@suit-1) * 13 + (@number)
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

    #String rep used for FILENAME/DB_HAND_ENCODING/MESSAGES(UI)

    def filename
      return convert_number_to_string + convert_suit_to_string
    end


    def to_s
      return filename
    end

    private

    def convert_number_to_string

      case (@number)
        when 1
          return 'A'
        when 11
          return 'J'
        when 12
          return 'Q'
        when 13
          return 'K'
        else
          if (@number != nil)
            return @number.to_s
          end
      end
    end

    def convert_suit_to_string
      case (@suit)
        when 1
          return 'C'
        when 2
          return 'H'
        when 3
          return 'D'
        when 4
          return 'S'
        else
          return nil       #probably redundant
      end
    end

  end
end