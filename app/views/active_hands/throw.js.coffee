


#remove unnecessary throw form
$('#throw-form').remove()
#Show peg form
$('#peg-form').css("display", "block")

##render cut card
$('#cut-card').html("<%= raw render_whole_card(@hand.cut_card_decoded, '', 100, '')  %>")

##remove cards from player and ai hand divs
$('#ai_card_4').remove()
$('#ai_card_5').remove()
$('#user-hand').html("<%= raw render_hand(@hand.player_hand, false, 'p_card_', '')  %>")

#Toggle span classes so that labels will line up correctly and cards aren't put below any others
$('#user-hand').toggleClass('span7 span6')
$('#user-crib').toggleClass('span4 span6')
$('#ai-hand').toggleClass('span7 span6')
$('#ai-crib').toggleClass('span4 span6')

$('#ai-score').html("AI: <%= @hand.active_game.p2_score %> ")
$('#user-score').html("<%= @hand.active_game.p1_score %>")

$('#peg-sum').html("<%= @hand.peg_sum %>")
$("#peg-stack").html("<%= raw render_peg_stack( @hand ) %>")

if ("<%= @hand.dealer %>" == 'true')
  $("#user-crib").html("<%= raw render_crib_hand %>")
  $("#peg-stack").html("<%= raw render_peg_stack( @hand ) %>")

  #    Remove card that AI pegged
  $("#ai_card_3").remove()

else
  $("#ai-crib").html("<%= raw render_crib_hand %>")








