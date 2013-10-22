class ActiveHand < ActiveRecord::Base

  belongs_to :active_game

  validates_presence_of :player_id

  include Workflow

  workflow do
    state :start do
      event :deal, transition_to: :dealt
    end
    state :dealt do
      event :throw, transition_to: :pegging
      event :new_hand, transition_to: :start
    end
    state :pegging do
      event :card_pegged, transition_to: :hands_counted
      event :new_hand, transition_to: :start
    end
    state :hands_counted do
      event :new_hand, transition_to: :start
    end
  end

  def player_hand
    return Crib::Util::CardEncoder.decode_hand(read_attribute(:p1_hand))
  end

  def ai_hand
    return Crib::Util::CardEncoder.decode_hand(read_attribute(:p2_hand))
  end

  def crib
    return Crib::Util::CardEncoder.decode_hand(read_attribute(:crib_hand))
  end

  def cut_card_decoded
    return Crib::Util::CardEncoder.convert_string_to_card(cut_card)
  end

  def full_peg_stack
    return Crib::Util::CardEncoder.decode_full_stack(read_attribute(:peg_stack))
  end

  def stack_by_round
    return Crib::Util::CardEncoder.decode_stack_by_round(read_attribute(:peg_stack))
  end

  def current_peg_stack
    return Crib::Util::CardEncoder.decode_current_stack(read_attribute(:peg_stack))
  end

  def ai_peg_hand
    return peg_hands[1]
  end

  def peg_round_complete

    stack = read_attribute(:peg_stack)
    stack += '|'
    write_attribute(:peg_stack, stack)
    write_attribute(:peg_sum, 0)
    save

  end

  def peg_hands

    player_full = player_hand
    player_peg = player_full.dup
    ai_peg = ai_hand.dup
    full_peg_stack.each do |card|
      if player_full.index{|x| x.number == card.number and x.suit == card.suit} != nil
        player_peg.delete_if {|x| x.number == card.number and x.suit == card.suit}
      else
        ai_peg.delete_if {|x| x.number == card.number and x.suit == card.suit}
      end
    end

    return player_peg, ai_peg

  end

  def deal

    deck = Crib::Deck.new

    if read_attribute(:dealer)
      hand1, hand2 = deck.deal_crib_hands
    else
      hand2, hand1 = deck.deal_crib_hands
    end

    hand1.sort! { |a,b| a.number <=> b.number  }
    hand2.sort! { |a,b| a.number <=> b.number  }

    write_attribute(:p1_hand, Crib::Util::CardEncoder.encode_hand(hand1))
    write_attribute(:p2_hand, Crib::Util::CardEncoder.encode_hand(hand2))
    save

  end

  def throw(hand1, hand2, crib, cut_card)

    write_attribute(:cut_card, Crib::Util::CardEncoder.convert_card_to_string(cut_card))
    write_attribute(:p1_hand, Crib::Util::CardEncoder.encode_hand(hand1))
    write_attribute(:p2_hand, Crib::Util::CardEncoder.encode_hand(hand2))
    write_attribute(:crib_hand, Crib::Util::CardEncoder.encode_hand(crib))

    write_attribute(:peg_sum, 0)
    write_attribute(:peg_stack, '')
    save

  end

  def card_pegged(card)  #TODO: To determine classes, could we just embed the 'who' into the db? (EG: 2 hearts by User = '1-22' or by AI = '2-22')

    stack = read_attribute(:peg_stack)
    sum = read_attribute(:peg_sum)

    if current_peg_stack.empty?
      delimiter = '' #dont need a separator for first card
    else
      delimiter = ':'
    end

    stack += delimiter + Crib::Util::CardEncoder.convert_card_to_string(card)
    card_stack = Crib::Util::CardEncoder.decode_full_stack(stack)

    if card_stack.size < 9
      sum += card.value
      write_attribute(:peg_stack, stack)
      write_attribute(:peg_sum, sum)

      #more cards to come, dont change state to hands_counted
      halt unless card_stack.size == 8
    end

    save

  end

  def peg_complete

    write_attribute(:peg_stack, '')
    write_attribute(:peg_sum, 0)

  end

  def new_hand

    write_attribute(:cut_card, nil)
    write_attribute(:p1_hand, '')
    write_attribute(:p2_hand, '')
    write_attribute(:crib_hand, '')
    write_attribute(:peg_stack, '')
    write_attribute(:peg_sum, 0)

    #change dealer on new hand
    write_attribute(:dealer, !read_attribute(:dealer))

  end

end
