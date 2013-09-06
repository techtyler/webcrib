module ApplicationHelper

  def is_active?(page)
    'active' if current_page?(page)
  end

  def render_whole_card(card, index, height)
    render_card(card, index, height)
  end

  def render_card_back(index, height)
    render_card(nil,index, height)
  end

  private
  def render_card(card, index, height)

    if !card
      filename = 'svg/cards/Blue_Back.svg'
    else
      filename = 'svg/cards/' + Crib::Util::CardEncoder.convert_card_to_string(card)  + '.svg'
    end

    return "<embed class='card#{index}' style='height: #{height}px; float:left' src=" + url_to_asset(filename) + "/>"

  end

end
