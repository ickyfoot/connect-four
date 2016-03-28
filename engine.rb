require_relative 'player'

class Engine
	@game
	@players
	@colors
	
	attr_accessor :players, :colors
	
	def initialize
		@colors = Array['yellow','red']
	end
	
	def startGame
		puts "Hello, and welcome to Connect Four! \n\n"\
			"Would you like to start a new game? Y/N"
		confirm = gets
		confirm = confirm.chomp
		if (confirm == "Y")
			@players = Array.new
			playerOne = Player.new
			playerTwo = Player.new
			
			puts "Great! You need two players to play"\
				" Connect Four. \n\nPlease enter info"\
				" for Player 1."
			playerOneReady = playerOne.collectInfo
			
			puts "And, now enter info for Player 2."
			playerTwoReady = playerTwo.collectInfo
			
			if (playerOneReady && playerTwoReady)
				if (playerOne.age < playerTwo.age)
					@players.push(playerOne).push(playerTwo)
				else
					@players.push(playerTwo).push(playerOne)
				end
			end
			puts @players[0].firstName+" is youngest and goes first."
			puts @players[1].firstName+" is oldest and gets to choose "\
			"a color. "+@players[1].firstName+", please choose yellow "\
			"or red:"
			chooseColor
		end
	end # end startGame
	
	def chooseColor
		playerOneColor = gets
		playerOneColor = playerOneColor.chomp
		if (@colors.index playerOneColor)
			@players[1].color = playerOneColor
			@players[0].color = if playerOneColor == 'red' then 'yellow'
				else 'red'
			end
			puts @players[1].firstName+" chose "+@players[1].color+" "\
			"so "+@players[0].firstName+" is "+@players[0].color+"."
		else
			puts 'You must choose "yellow" or "red":'
			chooseColor
		end
	end
	
	def endGame
		
	end
end

if __FILE__ == $0
	engine = Engine.new
	Person.clearPeople
	engine.startGame
end
