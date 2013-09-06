class ActiveHand < ActiveRecord::Base

  belongs_to :active_game

  validates_presence_of :player_id

  include Workflow

  workflow do
    state :start do
      event :deal, transition_to: :dealt
    end
    state :dealt do
      event :throw, transition_to: :peg_start
    end
    state :peg_start do
      event :first_peg, transition_to: :pegging
    end
    state :pegging do
      event :card_pegged, transition_to: :hands_counted
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


  def deal

    deck = Crib::Deck.new

    if read_attribute(:dealer)
      hand1, hand2 = deck.deal_crib_hands
    else
      hand2, hand1 = deck.deal_crib_hands
    end

    write_attribute(:p1_hand, Crib::Util::CardEncoder.encode_hand(hand1))
    write_attribute(:p2_hand, Crib::Util::CardEncoder.encode_hand(hand2))
    save
  end

  def throw(hand1, hand2, crib, cut_card)
    write_attribute(:cut_card, Crib::Util::CardEncoder.convert_card_to_string(cut_card))
    write_attribute(:p1_hand, Crib::Util::CardEncoder.encode_hand(hand1))
    write_attribute(:p2_hand, Crib::Util::CardEncoder.encode_hand(hand2))
    write_attribute(:crib_hand, Crib::Util::CardEncoder.encode_hand(crib))
    save
  end

  def first_peg(card)
    write_attribute(:peg_stack, card.number)
    write_attribute(:peg_sum, card.value)
  end

  def card_pegged(card, new_round)

    stack = read_attribute(:peg_stack)
    sum = read_attribute(:peg_sum)

    delimiter = ':'

    if new_round
      delimiter = '|'
      sum = 0
    end

    stack += "#{delimiter}#{card.number}"
    write_attribute(:peg_stack, stack)

    sum += card.value
    write_attribute(:peg_sum, sum)

  end

  def peg_complete
    write_attribute(:peg_stack, '')
    write_attribute(:peg_sum, 0)
  end

  def last_peg?
    peg_stack.empty?
  end

  def new_hand
    write_attribute(:cut_card, nil)
    write_attribute(:p1_hand, nil)
    write_attribute(:p2_hand, nil)
    write_attribute(:crib_hand, nil)
    write_attribute(:peg_stack, nil)
    write_attribute(:peg_sum, 0)
    write_attribute(:dealer, !read_attribute(:dealer))

  end

end
