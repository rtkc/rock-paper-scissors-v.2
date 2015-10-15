class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize(score=0)
    set_name
    @score = score
    @move_log = []
  end

  def add_score
    if score != 10
      self.score += 1
    end
  end

  def reset_score
    self.score = 0
  end
end

class Human < Player
  attr_accessor :move_log

  def set_name
    n = " "
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper or scissors."
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "Sorry, invalide choice."
    end
    self.move = Move.new(choice)
    move_log << choice
    puts "#{move_log}"
  end

  def pattern?
    if 0.6 <= move_log.count('rock') / move_log.size.to_f
      'paper'
    elsif 0.6 <= move_log.count('paper') / move_log.size.to_f
      'scissors'
    elsif 0.6 <= move_log.count('scissors') / move_log.size.to_f
      'rock'
    else
      'no pattern'
    end
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'AI'].sample
  end

  def choose(pattern)
    if pattern != 'no pattern'
      self.move = Move.new(pattern)
      puts "Pattern found: #{pattern}"
    else
      self.move = Move.new(Move::VALUES.sample)
    end
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock Paper Scissors"
  end

  def display_goodbye_message
    puts "Thanks for playing! Goodbye!"
  end

  def display_winner
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"

    if human.move > computer.move
      puts "#{human.name} won!"
      human.add_score
      puts "#{human.name}'s score is: #{human.score}. #{computer.name}'s score is: #{computer.score}"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      computer.add_score
      puts "#{human.name}'s score is: #{human.score}. #{computer.name}'s score is: #{computer.score}"
    else
      puts "It's a tie!"
    end
    # case human.move
    # when 'rock'
    #   puts "It's a tie!" if computer.move == 'rock'
    #   puts "#{human.name} won!" if computer.move == 'scissors'
    #   puts "#{computer.name} won!" if computer.move == 'paper'
    # when 'paper'
    #   puts "It's a tie!" if computer.move == 'paper'
    #   puts "#{human.name} won!" if computer.move == 'rock'
    #   puts "#{computer.name} won!" if computer.move == 'scissors'
    # when'scissors'
    #   puts "It's a tie!" if computer.move == 'scissors'
    #   puts "#{human.name} won!" if computer.move == 'paper'
    #   puts "#{computer.name} won!" if computer.move == 'rock'
    # end
  end

  def announce_winner_or_play_again
    if human.score == 10
      puts "#{human.name} has 10 points and wins the game!"
      human.reset_score
      computer.reset_score
      start_new_game?
    elsif computer.score == 10
      puts "#{computer.name} has 10 points and wins the game!"
      human.reset_score
      computer.reset_score
      start_new_game?
    else
      play_again?
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? Y/N"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, please input y or n"
    end

    return true if answer == 'y'
    return false
  end

  def start_new_game?
    answer = nil
    loop do
      puts "Would you like to start a new game? Y/N"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, please input y or n"
    end

    return true if answer == 'y'
    return false
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose(human.pattern?)
      display_winner
      break unless announce_winner_or_play_again 
    end
    display_goodbye_message
  end
end

RPSGame.new.play
