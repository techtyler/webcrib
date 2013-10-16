#update the peg sum (add label if first peg)
#update peg form if not last peg

#if it is the last peg, render 'hands_counted'?? We can still leave peg stack alone if we want to


player_peg = @player_peg_index

$('#peg_sum').show().html("<%= j @sum %>")

$('#peg_stack').append($('#player_hand').children()[player_peg])


ai_pegs "<%= j @ai_peg_cards %>"

#loop over pegs and do
  #add the card to the peg_stack (face up)
  #remove a card back from ai_hand (doesn't matter which)








