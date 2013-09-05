module Crib
  module Util
    class CardEncoder

      def self.encode_hand(hand)
        cards = []
        hand.each do |c|
          cards << Crib::Util::CardEncoder.convert_card_to_string(c)
        end
        return cards.join(':')

      end

      def self.decode_hand(hand_string)
        cards = hand_string.split(':')
        hand = []
        cards.each do |c|
          hand << Crib::Util::CardEncoder.convert_string_to_card(c)
        end
        return hand
      end


      def self.convert_string_to_card(string)

        if string.size == 2
          return Crib::Card.new(convert_string_to_number(string[0]), convert_string_to_suit(string[1]))
        else
          return Crib::Card.new(convert_string_to_number(string[0..1]), convert_string_to_suit(string[2]))
        end
      end

      def self.convert_card_to_string(card)
        return convert_number_to_string(card.number) + convert_suit_to_string(card.suit)
      end

      def self.convert_string_to_number(string_num)
        case (string_num)
          when 'A'
            return 1
          when 'J'
            return 11
          when 'Q'
            return 12
          when 'K'
            return 13
          else
            return string_num.to_i
        end
      end

      def self.convert_number_to_string(number)

        case (number)
          when 1
            return 'A'
          when 11
            return 'J'
          when 12
            return 'Q'
          when 13
            return 'K'
          else
            if (number != nil)
              return number.to_s
            end
        end
      end

      def self.convert_string_to_suit(string_suit)

        case (string_suit)
          when 'C'
            return 1
          when 'H'
            return 2
          when 'D'
            return 3
          when 'S'
            return 4
        end

      end


      def self.convert_suit_to_string(suit)
        case (suit)
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
end


