#update the peg sum and stack

#Render AI Peg Hand (Updated afer AI has made his moves)

$('#ai-score').html("AI: <%= @hand.active_game.p2_score %> ")
$('#user-score').html("<%= @hand.active_game.p1_score %>")

$('#peg-sum').html("<%= @sum %>")
$("#peg-stack").html("<%= raw render_peg_stack( @hand ) %>")

procPegging = (hand)->

  if hand.hand.workflow_state == 'hands_counted'

    $('#new-hand').css("display", "block")
    $('#peg-form').remove()
    $('#user-hand').html("<%= raw render_hand(@hand.player_hand, false, 'p_card_', false)  %>")
    $('#user-hand').append("<h3 class='score'><%= @player_hand_score %></h3>")

    $('#ai-hand').html("<%= raw render_hand(@hand.ai_hand, false, 'ai_card_', false) %>")
    $('#ai-hand').append("<h3 class='score'><%= @ai_hand_score %></h3>")

    if hand.hand.dealer
      $('#user-crib').html("<%= raw render_hand(@hand.crib, false, '', true) %>")
      $('#user-crib').append("<h3 class='score'><%= @player_crib_score %></h3>")
    else
      $('#ai-crib').html("<%= raw render_hand(@hand.crib, false, '', true) %>")
      $('#ai-crib').append("<h3 class='score'><%= @ai_crib_score %></h3>")
  else
    #Update Peg Form and Hand

    $("#peg_lbl_<%= @player_peg.size + 1 %>").remove()
    $("#p_card_<%= @peg_index %>").remove()
    $('#user-hand').html("<%= raw render_hand(@player_peg, false, 'p_card_', false) %>")
    $('#ai-hand').html("<%= raw render_hand(@ai_peg, true, 'ai_card_', false ) %>")

gon.watch('hand', url: 'hand', procPegging )