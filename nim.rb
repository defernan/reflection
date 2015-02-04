
class ComputerPlayer

end

class Nim
  #set board configurations as class variables
  @@board_config1 = [1, 3, 5, 7]
  @@board_config2 = [4, 3, 7]

  def initialize
    @opponent
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
    elsif selection == "2"
      @board = @@board_config2
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
      @opponent = option_hash[selection.to_i]
    else
      puts "Please enter '1'-'#{option}'"
      select_opponent 
    end
  
  end

  def smart_computer_player
    #use for converting to binary
    binary_array = get_binary_array     
    puts binary_array
    puts ""
    
    #get kernel state 
    kernel_state = get_kernel_state(binary_array)
    puts "kernel_state is #{kernel_state}"
    
    #get line to return to winning state
    conversion_line = get_line(kernel_state, binary_array)
 
    #xor desired line
    line = xor_line(kernel_state, binary_array[conversion_line])
    puts "xord line is #{line}" 

    #TODO find optimal line and change the array
    number = line.to_i(2)
    puts "#{number}"
    
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

  def dumb_computer_player

  end 

  def human_player
    display_board
    
    row = select_row
    sticks = select_sticks row 

    @board[row] = @board[row] - sticks
  end

  #helper functions for human move
  def select_row
    puts "Select the row (1-#{@board.size}): "
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
  
  def display_board
    for i in 0...@board.size
      print "Row #{i + 1}: "
      @board[i].times{ print "X"}
      puts "" 
    end
  end
  def play_game
    select_config
    select_opponent
    while( @play == true )
      human_player
      smart_computer_player
    end
  end


end

nim = Nim.new
nim.play_game
