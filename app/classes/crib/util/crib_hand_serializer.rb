
module Crib
  module Util
    class CribHandSerializer

      #turns CribHand into 15 byte blob
      def serialize(crib_hand)

        state_dealer_byte = serialize_state_dealer(crib_hand)
        blob_as_bytes = [state_dealer_byte]

        if crib_hand.state_index == 1
          blob_as_bytes += write_hand_bytes(crib_hand.p1_hand + crib_hand.p2_hand)
        elsif crib_hand.state_index >= 2
          blob_as_bytes += write_hand_bytes(crib_hand.p1_hand + crib_hand.p2_hand + crib_hand.crib)
          if crib_hand.state_index > 2
            blob_as_bytes += write_hand_bytes([crib_hand.cut])
            if crib_hand.state_index == 4
              blob_as_bytes << serialize_peg_stack(crib_hand)
            end
          end

        end


        return blob_as_bytes.pack('c*')

      end

      #turns 15 byte blob into new CribHand with proper state
      def deserialize(blob_as_string)

        bytes = blob_as_string.unpack('c*')
        hand = Crib::CribHand.new
        hand.state_index, hand.dealer = deserialize_state_dealer(bytes.first)

        if hand.state_index == 1

          cards = deserialize_hand(bytes[1..12])
          hand.p1_cards = cards[0..5]
          hand.p2_cards = cards[6..11]

        elsif hand.state_index >= 2

          if hand.state_index > 2
            cards = deserialize_hand(bytes[1..13])
            hand.cut = cards[12]
            if hand.state_index == 4
              hand.peg_stack = deserialize_peg_stack(bytes[14])
            end
          else
            cards = deserialize_hand(bytes[1..12])
          end

          hand.p1_cards = cards[0..3]
          hand.p2_cards = cards[4..7]
          hand.crib = cards[8..11]

        end

        return hand

      end

      private

      def serialize_state_dealer(hand)

        if hand.dealer
          dealer = 0
        else
          dealer = 16
        end
        case hand.state_index
          when 5
            return 15 + dealer
          when 4
            return 8 + hand.peg_stack.size + dealer
          when 3
            return 7 + dealer
          when 2
            return 3 + dealer
          else
            return hand.state_index  # 0 and 1 map to themselves
        end

      end

      def deserialize_state_dealer(byte) #ignores first half of byte (only needs 4 bits)

        #Trying it with decimal
        dealer = true
        if (byte > 15)
          byte -= 16
          dealer = false
        end
        case (byte)
          when 15
            return 5, dealer
          when 7
            return 3, dealer
          when 3
            return 2, dealer
          else
            if byte > 7 && byte < 15
              return 4, dealer
            else
              return byte, dealer #0 and 1 map to themselves
            end
        end
      end

      def serialize_hand(hand)

        bytes = []

        hand.each do |c|
          bytes << c.to_id
        end

        return bytes

      end


      def deserialize_hand(bytes)

        hand = []
        bytes.each do |b|
          card = Card.new        #TODO try card.new.tap{card.from_id(c_id)}
          card.from_id(b)
          hand << card
        end
        return hand

      end


      def serialize_peg_stack(crib_hand)

        number = 0
        index = 1
        crib_hand.peg_stack.each do |c|
          number += (c * index)
          index *= 10
        end

        return number

      end

      def deserialize_peg_stack(byte)

        stack = []
        if byte != 0
          tmp = byte
          while tmp > 0
            digit = tmp % 10
            stack << digit
            tmp /= 10
          end
        end

        return stack

      end
    end
  end
end