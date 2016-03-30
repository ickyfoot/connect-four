require_relative 'player'
require_relative 'ui_manager'
require 'gtk3'

class Engine
	@g_id
	@gameName
	@turnCount
	@players
	@playerOne
	@playerTwo
	@colors
	@uiManager
	
	attr_accessor :players, :colors
	
	def initialize
		@colors = Array['yellow','red']
		connect_four = Gtk::Application.new(
			'com.github.ickyfoot.connect_four',
			:flags_none
		)
		@uiManager = UIManager.new
		
		connect_four.signal_connect "activate" do |application|
			@uiManager.newWindow(application)
		end
		
		connect_four.run
	end
	
	def nextTurn; end
	
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
	
	def endGame(reason)
		abort(reason)
	end
	
	# def getOpenGames end
	
	def isWinner; end
	
	# def resumeGame; end
	
	# def saveGame; end
	
	def playerSetup
		@players = Array.new
		@playerOne = Player.new
		@playerTwo = Player.new
		@playerOneReady = false
		@playerTwoReady = false
		
		Person.clearPeople
		
		def setPlayerReady(playerNumber, status)
			if playerNumber == 1
				@playerOne.saveInfo
				@playerOne.calculateAge
				@playerOneReady = status
				@uiManager.setupPlayerSetupBox(@playerTwo,2,
					method(:setPlayerReady))
			else
				@playerTwo.saveInfo
				@playerTwo.calculateAge
				@playerTwoReady = status
				finalizePlayerSetup = ""
				if (@playerOneReady && @playerTwoReady)
					if (@playerOne.age > @playerTwo.age)
						@players.push(@playerOne).push(@playerTwo)
						finalizeSetupLabelText = 
							"Player 2 is youngest and goes first. "\
							"Player 1 gets to choose their color "\
							"(yellow or red)"
					else
						@players.push(@playerTwo).push(@playerOne)
						finalizeSetupLabelText = 
							"Player 1 is youngest and goes first. "\
							"Player 2 gets to choose their color "\
							"(yellow or red)"
							
					end
					@uiManager.finalizePlayerSetup(
						finalizeSetupLabelText,
						@colors,
						@players
					)
				end
			end
		end
		
		@uiManager.setupPlayerSetupBox(@playerOne,1,
			method(:setPlayerReady))
		#chooseColor
	end
	
	def startGame
		# pass anonymous function as callback
		@uiManager.setupWelcomeBox(Proc.new do playerSetup end)
	end
end

if __FILE__ == $0
	engine = Engine.new
	engine.startGame
end
