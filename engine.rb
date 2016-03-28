require_relative 'player'
require 'gtk3'

class Engine
	@g_id
	@gameName
	@turnCount
	@players
	@colors
	
	attr_accessor :players, :colors
	
	def initialize
		@colors = Array['yellow','red']
		connect_four = Gtk::Application.new(
		'com.github.ickyfoot.connect_four', :flags_none)
		connect_four.signal_connect "activate" do |application|
			window = Gtk::ApplicationWindow.new(application)
			window.set_title("Connect Four")
			window.set_default_size(400,400)
			window.set_border_width(10)
			
			welcomeBox = Gtk::Box.new(:vertical, 10)
			
			greetingBox = Gtk::Box.new(:vertical, 10)
			greetingLabel = Gtk::Label.new("Hello, and welcome to "\
											"Connect Four!")
			greetingBox.add(greetingLabel)
			
			gameNameLabelBox = Gtk::Box.new(:vertical,10)
			gameNameLabel = Gtk::Label.new("Please enter a name for "\
											"this game:")
			gameNameLabelBox.add(gameNameLabel)
			
			gameNameEntryBox = Gtk::Box.new(:vertical,10)
			gameNameEntry = Gtk::Entry.new
			gameNameEntryBox.add(gameNameEntry)
			
			gameNameSubmissionBox = Gtk::Box.new(:vertical,10)
			gameNameSubmissionButton = Gtk::Button.new("Submit")
			gameNameSubmissionBox.add(gameNameSubmissionButton)
			
			welcomeBox.pack_start(greetingBox, false)
			welcomeBox.pack_start(gameNameLabelBox, false)
			welcomeBox.pack_start(gameNameEntryBox, false)
			welcomeBox.pack_start(gameNameSubmissionBox, false)
			
			window.add(welcomeBox)
			
			window.show_all
		end
	
		puts connect_four.run
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
	
	# def resumeGame end
	
	# def saveGame end
	
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
end

if __FILE__ == $0
	engine = Engine.new
	# Person.clearPeople
	# engine.startGame
end
