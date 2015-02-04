
class ComputerPlayer

end

class Nim
  #set board configurations as class variables
  @@board_config1 = [1, 3, 5, 7]
  @@board_config2 = [4, 3, 7]

  def initialize
    #defaults player 1 to human can change with setters
    @player1 = "human_player" 
    @player2
    @board
    @play = true
    
    #use for binary bit rep, specifies how many bits to use 
    @binary_bits = 3
  end

  #select board configuration
  def select_config
    puts "1: #{@@board_config1}"
    puts "2: #{@@board_config2}"
    print "Select board configuration (1-2): "
    selection = gets.chomp

    #if selections valid, sets board
    #otherwise recall method
    if selection == "1"
      @board = @@board_config1
      puts ""
    elsif selection == "2"
      @board = @@board_config2
      puts ""
    else
      puts "Please enter '1' or '2'"
      select_config 
    end
  
  end
 
  #select opponent through reflection
  def select_opponent
    
    #option used to display choice
    option = 0
    #option_hash used to save opponent chosen
    option_hash = {}

    #display appropriate opponents if method contains 'computer_player' in it
    self.methods.each do |method|
      if (method.to_s.include? "computer_player")
	option += 1
	puts "#{option}: #{method.to_s}"
	#populate option_hash with opponents
	option_hash[option] = method.to_s
      end
    end

    #get option
    print "Select computer player (1-#{option}): "
    selection = gets.chomp
    #check if selection was valid
    if ("1".."#{option}") === selection 
      @player2 = option_hash[selection.to_i]
    else
      puts "Please enter '1'-'#{option}'"
      select_opponent 
    end
    puts ""
  
  end

  def smart_computer_player
    #use for converting to binary
    binary_array = get_binary_array     
    
    #get kernel state 
    kernel_state = get_kernel_state(binary_array)
    
    #get line to return to winning state
    conversion_line = get_line(kernel_state, binary_array)
 
    #xor desired line
    line = xor_line(kernel_state, binary_array[conversion_line])

    #TODO find optimal line and change the array
    number = line.to_i(2)
    
    #display number taken
    #add 1 to conversion_line to adjust for base of 1. Was at base 0 to compensate for array starting index
    puts "Smart computer took #{@board[conversion_line] - number} sticks from row #{conversion_line + 1}"
    @board[conversion_line] = number
    puts "" 
  end
  
  #HELPER functions for smart_computer player
  #returns binary version of board 
  def get_binary_array
    binary_array = []
    #push binary version of elements into binary array
    @board.each{ |elem| binary_array << ( "%0#{@binary_bits}b" % elem) }
    binary_array
  end
  
  # returns current state of board
  def get_kernel_state binary_array
    kernel_state = ""
    for i in 0...@binary_bits
      sum_of_bits = 0
      binary_array.each{ |elem| 
        sum_of_bits += elem[i].to_i 
      }
      if (sum_of_bits %  2) == 0
        kernel_state << "0"
      else
        kernel_state << "1"
      end 
    end
    kernel_state
  end
  
  #get optimal line to change
  def get_line(kernel_state, binary_array)
    location = 0
    line = 0 
    #find location of leftmost one 
    for i in 0...kernel_state.size
      if kernel_state[i] == "1"
        location = i
        break
      end
    end
   
    #find line to xor
    for i in 0...binary_array.size
      if (binary_array[i][location] == "1")
        line = i
        break 
      end 
    end
    line 
  end
 
  #xors desired string 
  def xor_line(kernel_state, line)
    converted = ""
    for i in 0...@binary_bits
      if kernel_state[i] == line[i]
        converted << "0"
      else
        converted << "1"
      end
    end
    converted 
  end
  #END HELPER FUNCTIONS FOR SMART

  def dumb_computer_player
    invalid_row = true

    #pick random valid row 
    while(invalid_row)
      row = rand(0...@board.size)
      if @board[row] > 0 then invalid_row = false end
    end
    
    sticks_taken = rand(1..@board[row])
    
    #adjust row to start at base 1
    puts "Dumb computer took #{sticks_taken} sticks from row #{row + 1}"
    puts ""

    @board[row] = @board[row] - sticks_taken
  end 

  def human_player
    display_board
    
    row = select_row
    sticks = select_sticks row 
    puts ""
    @board[row] = @board[row] - sticks
  end

  #HELPER functions for human move
  def select_row
    print "Select the row (1-#{@board.size}): "
    row= gets.chomp
    if ( ("1".."#{@board.size}") === row && @board[row.to_i - 1] > 0 )
      #adjust row to be base 0 so array can access
      row = row.to_i - 1
    elsif ("1".."#{@board.size}") === row 
      puts "No sticks left in that row"
      select_row
    else
      puts "Please enter row (1-#{@board.size})"
      select_row 
    end 
  end

  def select_sticks row
    #adjust row so base index is zero for array access
    print "Select the number of matches (1-#{@board[row]}): "
    num_matches = gets.chomp
    if ( "1".."#{@board[row]}" ) === num_matches
      sticks = num_matches.to_i
    else
      puts "The number of stick must be between (1-#{@board[row]})"
      select_sticks row
    end
  end 
  #END HELPER FUNCTIONS FOR HUMAN
  
  def display_board
    for i in 0...@board.size
      print "Row #{i + 1}: "
      @board[i].times{ print "X"}
      puts "" 
    end
  end

  def play_game

    #used for switching turns
    player1_turn= true
    
    while( @play == true )
      if( player1_turn )
        self.send(@player1)
      else 
        self.send(@player2)
      end
      determine_winner player1_turn
      
      #change turn
      player1_turn = !player1_turn
    end
  end

  def determine_winner player1_turn
    win = true 
    for i in 0...@board.size
      if @board[i] !=0 then win = false end
    end
    if (win)
      @play = false
      if ( player1_turn )
        winner = @player1
      else
        winner = @player2
      end
      puts "#{winner} wins the game!\nThanks for playing"
    end
  end
  
  #HELPER FUNCTIONS FOR UNIT TESTS
  def set_board_config

  end

  def set_player1_as_dumb
    @player1 = "dumb_computer_player"
  end

  def set_player2_as_smart
    @player2 = "smart_computer_player"
  end
  #END HELPER FUNCTIONS FOR UNIT TEST
end

if "nim.rb" == $0
  nim = Nim.new

  #select board config
  nim.select_config

  #select opponent
  nim.select_opponent
  nim.play_game
end
