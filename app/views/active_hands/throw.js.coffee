
$('#throw_form').remove()

#render cut card
$('#cut_card').html("<%= raw render_whole_card(@cut_card, 0, 200)  %>")


#display crib hand

$('#crib_hand').append("<div class='card' style='margin: 10px; float:left'><%= raw render_whole_card(@crib_hand[0], 0, 150) %></div>")
$('#crib_hand').append("<div class='card' style='margin: 10px; float:left'><%= raw render_whole_card(@crib_hand[1], 1, 150)  %></div>")
$('#crib_hand').append("<div class='card' style='margin: 10px; float:left'><%= raw render_whole_card(@crib_hand[2], 2, 150)  %></div>")
$('#crib_hand').append("<div class='card' style='margin: 10px; float:left'><%= raw render_whole_card(@crib_hand[3], 3, 150)  %></div>")

#remove cards from player and ai hand divs

$('#ai_card_' + "<%= j @ai_throw1.to_s %>").remove()
$('#ai_card_' + "<%= j @ai_throw2.to_s %>").remove()
$('#p_card_' + "<%= j @p_throw1.to_s %>").remove()
$('#p_card_' + "<%= j @p_throw2.to_s %>").remove()


$('#ai-hand-score').html("<%= j @ai_hand_score %>")
$('#player-hand-score').html("<%= j @player_hand_score %>")
$('#crib-hand-score').html("<%= j @crib_hand_score %>")


#refresh player scores (for cut and hand scores)
#render count_hands


#render peg form (eventually)







