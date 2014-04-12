

$('#ai-score').html("AI_Gordon: <%= @hand.active_game.p2_score %> ")
$('#user-score').html("<%= @hand.active_game.p1_score %>")

$('#peg-sum').html("<%= @sum %>")
$("#peg-stack").html("<%= raw render_peg_stack( @hand ) %>")


if ("<%= @hand.game_over %>" == 'true')
  $('#peg-form').remove()


if ("<%= @hand.workflow_state %>" == 'hands_counted')
  if ("<%= @hand.game_over %>" != 'true')
    $('#new-hand').css("display", "block")
  $('#peg-form').remove()
  $('#user-hand').html("<%= raw render_hand(@hand.player_hand, false, 'p_card_', '')  %>")
  $('#user-hand').append("<h3 class='score'><%= @player_hand_score %></h3>")
  $('#peg-sum').html("")
  $('#peg-stack').html('')
  $('#ai-hand').html("<%= raw render_hand(@hand.ai_hand, false, 'ai_card_', '') %>")
  $('#ai-hand').append("<h3 class='score'><%= @ai_hand_score %></h3>")

  if ("<%= @hand.dealer %>" == 'true')
    $('#user-crib').html("<%= raw render_hand(@hand.crib, false, '', 'crib') %>")
    $('#user-crib').append("<h3 class='score'><%= @player_crib_score %></h3>")
  else
    $('#ai-crib').html("<%= raw render_hand(@hand.crib, false, '', 'crib')%>")
    $('#ai-crib').append("<h3 class='score'><%= @ai_crib_score %></h3>")
else if ("<%= @hand.workflow_state %>" == 'pegging')
  $("#peg_lbl_<%= @player_peg.size + 1 %>").remove()
  $("#p_card_<%= @peg_index %>").remove()
  $('#user-hand').html("<%= raw render_hand(@player_peg, false, 'p_card_', '') %>")
  updateAiHand("<%= @hand.ai_peg_size %>")

updateAiHand = (ai_peg_size) ->

  j = $('#ai-hand').children().length
  ai_peg_as_int = ai_peg_size.to_int
  while (j > ai_peg_as_int)
    $('#ai_card_' + (j-1)).remove()    #Eventually figure out if we can somehow animate that card to the stack location :/
    j--