require_relative 'player'
require 'gtk3'

class Engine
	@g_id
	@gameName
	@turnCount
	@players
	@colors
	@window
	
	attr_accessor :players, :colors
	
	def initialize
		@colors = Array['yellow','red']
		connect_four = Gtk::Application.new(
		'com.github.ickyfoot.connect_four', :flags_none)
		connect_four.signal_connect "activate" do |application|
			@window = Gtk::ApplicationWindow.new(application)
			@window.set_title("Connect Four")
			@window.set_default_size(400,400)
			@window.set_border_width(10)
			startGame
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
	
	# def resumeGame; end
	
	# def saveGame; end
	
	def playerSetup
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
	
	def startGame
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
		
		@window.add(welcomeBox)
		
		@window.show_all
		
		gameNameSubmissionButton.signal_connect "clicked" do
			md = Gtk::MessageDialog.new(
				:parent => nil, 
				:flags => :destroy_with_parent,
				:type => :info, 
				:buttons_type => :none, 
				:message => "Your game name will be "+
							gameNameEntry.text
			)
			
# see response IDs here: 
# http://ruby-gnome2.osdn.jp/hiki.cgi?Gtk%3A%3ADialog#ResponseType
			md.add_button('Confirm',Gtk::ResponseType::ACCEPT)
			md.add_button('Change',Gtk::ResponseType::REJECT)
			response = md.run
			
			if (response == Gtk::ResponseType::ACCEPT)
				@window.remove(welcomeBox)
				@gameName = gameNameEntry.text
				@window.set_title(@gameName)
				confirmBox = Gtk::Box.new(:vertical,10)
				newTitleBox = Gtk::Box.new(:vertical,10)
				newTitleLabel = Gtk::Label.new("The name of the "\
												"game is "+@gameName)
				newTitleBox.add(newTitleLabel)
				
				continueBox = Gtk::Box.new(:vertical,10)
				continueButton = Gtk::Button.new("Continue")
				continueBox.add(continueButton)
				
				confirmBox.pack_start(newTitleBox, false)
				confirmBox.pack_start(continueBox, false)
				
				continueButton.signal_connect "clicked" do
					playerSetup
				end
				
				@window.add(confirmBox)
				@window.show_all
			end
			
			md.destroy
		end
	end # end startGame
end

if __FILE__ == $0
	engine = Engine.new
	# Person.clearPeople
	# engine.startGame
end
