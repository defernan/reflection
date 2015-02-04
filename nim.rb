
class ComputerPlayer

end

class Nim
  #set board configurations as class variables
  @@board_config1 = [1, 3, 5, 7]
  @@board_config2 = [4, 3, 7]

  def initialize
    @opponent 
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
      board = @@board_config1
    elsif selection == "2"
      board = @@board_config2
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

  end

  def dumb_computer_player

  end 

 
  def play_game
    select_config
    select_opponent
  end


end

nim = Nim.new
nim.play_game
