require_relative 'player'
require 'gtk3'

class UIManager
	@window
	
	def initialize
	end
	
	def newWindow(application)
		@window = Gtk::ApplicationWindow.new(application)
		@window.set_title("Connect Four")
		@window.set_default_size(400,400)
		@window.set_border_width(10)
		return @window
	end
	
	def setupPlayerSetupBox(player, playerNumber, callback)
		@window.set_title("Player "+playerNumber.to_s+" Setup")
		playerSetupBox = Gtk::Box.new(:vertical,10)
		playerSetupLabel = Gtk::Label.new(
			"Please enter information for Player "+playerNumber.to_s+"."
		)
		
		playerFirstNameLabel = Gtk::Label.new('First Name:')
		playerFirstNameEntry = Gtk::Entry.new
		
		playerLastNameLabel = Gtk::Label.new('Last Name:')
		playerLastNameEntry = Gtk::Entry.new
		
		playerBirthdayLabel = Gtk::Label.new('Birthday:')
		playerBirthdayEntry = Gtk::Entry.new
		
		playerSubmit = Gtk::Button.new('Submit')
		
		playerSetupBox.pack_start(playerSetupLabel, false)
		playerSetupBox.pack_start(playerFirstNameLabel, false)
		playerSetupBox.pack_start(playerFirstNameEntry, false)
		playerSetupBox.pack_start(playerLastNameLabel, false)
		playerSetupBox.pack_start(playerLastNameEntry, false)
		playerSetupBox.pack_start(playerBirthdayLabel, false)
		playerSetupBox.pack_start(playerBirthdayEntry, false)
		playerSetupBox.pack_start(playerSubmit, false)
		@window.add(playerSetupBox)
		@window.show_all
		
		playerSubmit.signal_connect 'clicked' do
			md = Gtk::MessageDialog.new(
				:parent => nil, 
				:flags => :destroy_with_parent,
				:type => :info, 
				:buttons_type => :none, 
				:message => "Pease confirm Player "+playerNumber.to_s+
					"information:\n\n"\
					"First Name: "+playerFirstNameEntry.text+"\n"\
					"Last Name: "+playerLastNameEntry.text+"\n"\
					"Birthday: "+playerBirthdayEntry.text
			)
			md.add_button('Confirm',Gtk::ResponseType::ACCEPT)
			md.add_button('Change',Gtk::ResponseType::REJECT)
			response = md.run
			
			if (response == Gtk::ResponseType::ACCEPT)
				player.firstName = playerFirstNameEntry.text
				player.lastName = playerLastNameEntry.text
				player.birthday = playerBirthdayEntry.text
				@window.remove(playerSetupBox)
				callback.call(playerNumber, true)
			end
			
			md.destroy
		end
	end
	
	def setupWelcomeBox(callback)
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
				newTitleLabel = Gtk::Label.new(
					"The name of the game is "+@gameName+". Click "\
					"'Continue' to enter player information."
				)
				newTitleBox.add(newTitleLabel)
				
				continueBox = Gtk::Box.new(:vertical,10)
				continueButton = Gtk::Button.new("Continue")
				continueBox.add(continueButton)
				
				confirmBox.pack_start(newTitleBox, false)
				confirmBox.pack_start(continueBox, false)
				
				@window.add(confirmBox)
				@window.show_all
				
				continueButton.signal_connect "clicked" do
					@window.remove(confirmBox)
					callback.call
				end
			end
			
			md.destroy
		end
	end # end setupWelcomeBox
end

if __FILE__ == $0
	engine = Engine.new
	# Person.clearPeople
	# engine.startGame
end
