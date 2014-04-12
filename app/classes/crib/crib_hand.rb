module Crib
  class CribHand

    attr_accessor :state_index
    attr_accessor :dealer
    attr_accessor :p1_cards
    attr_accessor :p2_cards
    attr_accessor :crib
    attr_accessor :cut
    attr_accessor :peg_stack

    @states = %w(new dealt thrown cut pegging counted)
    @state_index = 0
    @p1_cards = []
    @p2_cards = []
    @crib = []
    @cut = nil
    @peg_stack = []
    @dealer = true

    def state
      @states[@state_index]
    end

    def deal(deck)
      deck = Deck.new unless deck
      @p1_cards, @p2_cards = deck.deal_crib_hands
      @state_index += 1
    end

    #Expects choices as an array of indices 1-4 [1,2,1,2] or [1,2,3,4]
    #each pair must contain unique indices [1,1,3,3] is INVALID
    def throw(choices)

      #TODO return unless state_index = 1?

      (0..3).each do |i|
        if i < 2
          @crib << @p1_cards.delete_at(choices[i])
        else
          @crib << @p2_cards.delete_at(choices[i])
        end
      end
      @state_index += 1

    end

    def cut

      #TODO Return unless state_index = 2 ?

      deck = Deck.new
      @cut = deck.cut_deck(@p1_cards + @p2_cards + @crib)
      @state_index += 1

    end

    def peg(is_player_2, index)

      if is_player_2
        index += 4 #indices correspond to 1-8 (1-4 being player 1) and 5-8 being player 2
      end

      @peg_stack << index
      #will @state_index be moved to counted later?

    end

    def count

      #TODO: somewhere have an option to count the hand with breakdown (use it for HELP or NEWBS)

      #Does this need to actually return the values of each players hands?

      if @dealer
        p1_score += Crib::Util::HandCountingMethods.score_hand(@crib + @cut, true)
      end

      p1_score


    end

  end
end