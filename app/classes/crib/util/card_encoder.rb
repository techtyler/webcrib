module Crib
  module Util
    class CardEncoder

      def self.decode_stack_by_round(stack)
        unless stack.include?('|')
          return [decode_full_stack(stack)]
        end

        rounds = stack.split(/[|]/)
        r_stack = []

        (0..rounds.size-1).each { |i|
          r_stack[i] = decode_hand(rounds[i])
        }

        return r_stack

      end

      def self.decode_full_stack(stack)

        cards = stack.split(/[:|]/)
        card_stack = []
        cards.each do |c|
          card_stack << Crib::Util::CardEncoder.convert_string_to_card(c)
        end
        return card_stack

      end

      def self.decode_current_stack(stack)

        unless stack.include?('|')
          return decode_full_stack(stack)
        end

        last = stack.rindex('|')
        return decode_full_stack(stack[(last + 1)..-1])

      end

      def self.encode_hand(hand)
        cards = []
        hand.each do |c|
          cards << c.to_s
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
          else
            return nil
        end

      end



    end
  end
end


