gem "minitest"
require 'minitest/autorun'
require 'test/unit'
require_relative 'nim.rb'

class NimTest < Test::Unit::TestCase

	
	def test_smart_vs_dumb_20_games
		nim = Nim.new
		20.times {
			nim = Nim.new
			nim.set_board_config [1, 3, 5, 7]
			nim.set_player1_as_dumb
			nim.set_player2_as_smart
			nim.play_game
		}
		assert_equal(120, nim.get_smart_wins)
		
	end
	
	def test_smart_vs_dumb_100_games
		nim = Nim.new
		100.times {
			nim = Nim.new
			nim.set_board_config [1, 3, 5, 7]
			nim.set_player1_as_dumb
			nim.set_player2_as_smart
			nim.play_game
		}
		assert_equal(100, nim.get_smart_wins)
		
	end
	
	def test_kernel_state
		nim = Nim.new
		assert_equal( "001",nim.get_kernel_state(["000","011","101","111"]))
		assert_equal( "011",nim.get_kernel_state(["000","001","101","111"]))
		assert_equal( "001",nim.get_kernel_state(["000","001","100","100"]))
		
	end
	
	def test_xor_line
		nim = Nim.new
		assert_equal( "010",nim.xor_line("001","011"))
		assert_equal( "101",nim.xor_line("010","111"))
		assert_equal( "111",nim.xor_line("111","000"))
		
	end
	def test_get_line
		nim = Nim.new
		assert_equal( 1,nim.get_line("001",["000","011","101","111"]))
		assert_equal( 3,nim.get_line("011",["000","001","101","111"]))
		assert_equal( 2,nim.get_line("110",["000","001","101","010"]))
		
	end
	
	
	


end
