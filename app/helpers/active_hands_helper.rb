module ActiveHandsHelper

  def hand_class(is_dealt)
    is_dealt ? 'span7' : 'span6'
  end

  def crib_class(is_dealt)
    is_dealt ? 'span4' : 'span6'
  end





  def render_user_crib(pegging, hands_counted, crib)

    if pegging
      render_crib_hand
    elsif hands_counted
      render_hand(crib, false, '', 'crib')
    end

  end


  def render_ai_hand(pegging, hands_counted, ai_hand, ai_peg)

    id = 'ai_card_'
    if pegging
      render_hand(ai_peg, true, id, '')
    else
      render_hand(ai_hand, !hands_counted, id, '')
    end

  end

  def render_user_hand(pegging, player_hand, player_peg )

    id = 'p_card_'

    if !pegging
      render_hand(player_hand,  false, id, '')
    else
      render_hand(player_peg, false, id, '' )
    end

  end

  def render_ai_crib(pegging, hands_counted, crib)

    if pegging
       render_crib_hand
    elsif hands_counted
       render_hand(crib, false, 'ai_crib_', '')
    end

  end

  private


  def render_new_hand

    #render the dealt hands with a throw form


  end

  def transition_to_pegging

  end


  def transition_to_hands_counted

    #remove decision forms
    #remove face-down crib cards
    #remove pegging hands

  end

  def render_hands_counted

    #render hands with crib facing up
    #render scores for each hand
  end








end
