require_relative 'nim.rb'

nim = Nim.new
20.times{
	nim = Nim.new
	nim.set_board_config [1, 3, 5, 7]
	nim.set_player1_as_dumb
	nim.set_player2_as_smart
	nim.play_game
}
print "Smart player won " 
print nim.get_smart_wins
puts " times"

