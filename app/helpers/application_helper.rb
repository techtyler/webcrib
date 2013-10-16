module ApplicationHelper

  @@card_height = 100
  @@stack_height = 100

  def is_active?(page)
    'active' if current_page?(page)
  end

  def render_whole_card(card, id, height)
    render_card(card, id, height, false)
  end

  def render_card_back(id, height, crib)
    render_card(nil, id, height, crib)
  end

  def render_peg_sum(active_hand)
    if (active_hand.peg_sum)
      return active_hand.peg_sum.to_s
    else
      return ''
    end

  end

  def render_peg_stack(active_hand)

    val = ''
    stack = active_hand.full_peg_stack
    for i in 1..stack.size
      val = val + render_whole_card(stack[i-1], 'peg_card_' + i.to_s, @@stack_height)
    end

    return val

    #TODO Determine how to 'shade' cards not included in the sum
  end

  def render_crib_hand
    render_hand(1..4, true, 'crib', true)
  end


  def render_hand(hand, back, id_prefix, crib)
    val = ''
    (0..hand.size-1).each { |i|
      id = id_prefix + i.to_s
      if back
        val = val + render_card_back(id, @@card_height, crib)
      else
        val = val + render_whole_card(hand[i], id, @@card_height)
      end

    }

    return val;
  end


  private
  def render_card(card, id, height, crib)

    if !card
      filename = 'svg/cards/Blue_Back.svg'
    else
      filename = 'svg/cards/' + Crib::Util::CardEncoder.convert_card_to_string(card)  + '.svg'
    end

    return "<embed class='" + (if crib then 'crib-' else '' end) +
        "card' id='#{id}' style='height: #{height}px;' src=" + url_to_asset(filename) + '/>'

  end

end
