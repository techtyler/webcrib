module ApplicationHelper

  CARD_HEIGHT = 100

  def is_active?(page)
    'active' if current_page?(page)
  end

  def render_whole_card(card, id, height, clazz)
    render_card(card, id, height, clazz)
  end

  def render_card_back(id, height, crib)
    render_card(nil, id, height, (if crib then 'crib' else '' end))
  end

  def render_peg_sum(active_hand)
    if (active_hand.peg_sum)
      return active_hand.peg_sum.to_s
    else
      return ''
    end

  end

  def render_peg_stack(active_hand)

    rounds = active_hand.stack_by_round #todo: for choosing class based on who pegged the card, check vs.ai_hand, .player_hand

    player_hand = active_hand.player_hand

    for i in 0..rounds.size-1
      for j in 0..rounds[i].size-1
        tmp_card = rounds[i][j]
        rounds[i][j] = [tmp_card, player_hand.index{|x| x.number == tmp_card.number && x.suit == tmp_card.suit}]
      end
    end


    val = "<div class='stack'>" + render_stack_round(rounds.delete_at(0), 'stack_rnd_1', 'stack-card') + '</div>'

    while rounds.any?
      clazz =  if (rounds.size == 1) then 'current-round stack-card' else 'stack-card' end
      id = if (rounds.size == 1) then 'stack_rnd_c_' else 'stack_rnd_2' end
      val += "<div class='stack round' >" + render_stack_round(rounds.delete_at(0), id, clazz ) + '</div>'
    end

    return val

  end



  def render_stack_round(round_with_player, id, clazz)
    val = ''
    for i in 0..round_with_player.size-1
      card, player = round_with_player[i]
      tmp_clazz = if player then 'player-stack ' else 'ai-stack ' end
      tmp_clazz += clazz

      val += render_whole_card(card, id + i.to_s, CARD_HEIGHT, tmp_clazz)
    end

    return val


  end


  def render_crib_hand
    render_hand(1..4, true, 'crib', 'crib')
  end


  def render_hand(hand, back, id_prefix, clazz)
    val = ''
    (0..hand.size-1).each { |i|
      id = id_prefix + i.to_s
      if back
        val = val + render_card_back(id, CARD_HEIGHT, clazz)
      else
        val = val + render_whole_card(hand[i], id, CARD_HEIGHT, clazz)
      end

    }

    return val
  end


  private
  def render_card(card, id, height, clazz)

    if !card
      filename = 'svg/cards/Blue_Back.svg'
    else
      filename = 'svg/cards/' + card.filename  + '.svg'
    end

    return "<div class='" + clazz + " card' id='#{id}' ><embed style='height: #{height}px;' src=" + url_to_asset(filename) + '/></div>'

  end

end
