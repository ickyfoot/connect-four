require_relative 'player'

class Engine
	playerCount = 0
	@@playerOne
	@@playerTwo
	
	attr_accessor :playerOne, :playerTwo
	
	def initialize
		@@playerOne = Player.new
		@@playerTwo = Player.new
	end
	
	def startGame
		puts "Hello, and welcome to Connect Four! \n\n"\
			"Would you like to start a new game? Y/N"
		confirm = gets
		confirm = confirm.chomp
		if (confirm == "Y")
			puts "Great! You need to players to play"\
				"Connect Four. \n\nPlease enter info"\
				"for Player 1."
			@@playerOne.collectInfo
			@@playerTwo.collectInfo
		end
	end
end

if __FILE__ == $0
	engine = Engine.new
	engine.startGame
end
