require_relative 'player'
require 'gtk3'

class UIManager
	@window
	
	def initialize
	end
	
	def finalizePlayerSetup(finalizeSetupLabelText, colors, players)
		finalizeSetupBox = Gtk::Box.new(:vertical,10)
		finalizeSetupLabel = Gtk::Label.new(
			finalizeSetupLabelText
		)
		finalizeSetupLabel.set_alignment(0,1)
		finalizeSetupColorEntry = Gtk::Entry.new
		finalizeSetupColorSubmit = Gtk::Button.new('Submit')
		finalizeSetupBox.pack_start(
			finalizeSetupLabel,
			false
		)
		finalizeSetupBox.pack_start(
			finalizeSetupColorEntry,
			false
		)
		finalizeSetupBox.pack_start(
			finalizeSetupColorSubmit,
			false
		)
		
		finalizeSetupColorSubmit.signal_connect "clicked" do
			colorSelection = finalizeSetupColorEntry.text.downcase
			if (colors.index colorSelection)
				md = Gtk::MessageDialog.new(
					:parent => nil, 
					:flags => :destroy_with_parent,
					:type => :info, 
					:buttons_type => :none, 
					:message => "Are you sure you would like to be "+
						colorSelection+"?"
				)
				md.add_button('Confirm',Gtk::ResponseType::ACCEPT)
				md.add_button('Change',Gtk::ResponseType::REJECT)
				response = md.run
				
				if (response == Gtk::ResponseType::ACCEPT)
					players[1].color = colorSelection
					players[0].color = if 
						colorSelection == 
						'red' then 'yellow' else 'red' end
					@window.remove(finalizeSetupBox)
					confirmPlayerInfo = Gtk::Box.new(:vertical,10)
					confirmPlayerInfoLabel = Gtk::Label.new(
						'Please review information about the players'
					)
					confirmPlayerInfoLabel.set_alignment(0,1)
					
					firstPlayerInfo = Gtk::Label.new(
						"First Player\n"\
						"Name: "+players[0].name+"\n"\
						"Color: "+players[0].color
					)
					firstPlayerInfo.set_alignment(0,1)
					
					secondPlayerInfo = Gtk::Label.new(
						"Second Player\n"\
						"Name: "+players[1].name+"\n"\
						"Color: "+players[1].color
					)
					secondPlayerInfo.set_alignment(0,1)
					
					confirmPlayerInfo.pack_start(
						confirmPlayerInfoLabel,false
					)
					confirmPlayerInfo.pack_start(firstPlayerInfo,false)
					confirmPlayerInfo.pack_start(secondPlayerInfo,false)
					@window.add(confirmPlayerInfo)
					@window.show_all
				end
				md.destroy
			else
				md = Gtk::MessageDialog.new(
					:parent => nil, 
					:flags => :destroy_with_parent,
					:type => :info, 
					:buttons_type => :none, 
					:message => "You must choose either "+colors[0]+
								" or "+colors[1]+". You chose \""+colorSelection+"\"."
				)
				md.add_button('OK',Gtk::ResponseType::CLOSE)
				md.run
				md.destroy
			end
		end
		@window.add(finalizeSetupBox)
		@window.show_all
	end
	
	def newWindow(application)
		@window = Gtk::ApplicationWindow.new(application)
		@window.set_title("Connect Four")
		@window.set_default_size(400,400)
		@window.set_border_width(10)
		return @window
	end
	
	def setupPlayerSetupBox(player, playerNumber, callback, restart)
		@window.set_title("Player "+playerNumber.to_s+" Setup")
		playerSetupBox = Gtk::Box.new(:vertical,10)
		playerSetupLabel = Gtk::Label.new(
			"Please enter information for Player "+playerNumber.to_s+"."
		)
		playerSetupLabel.set_alignment(0,1)
		
		playerFirstNameLabel = Gtk::Label.new('First Name:')
		playerFirstNameLabel.set_alignment(0,1)
		playerFirstNameEntry = Gtk::Entry.new
		
		playerLastNameLabel = Gtk::Label.new('Last Name:')
		playerLastNameLabel.set_alignment(0,1)
		playerLastNameEntry = Gtk::Entry.new
		
		playerBirthdayLabel = Gtk::Label.new('Birthday:')
		playerBirthdayLabel.set_alignment(0,1)
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
			else
				@window.remove(playerSetupBox)
				restart.call
			end
			
			md.destroy
		end
	end
	
	def setupWelcomeBox(callback)
		welcomeBox = Gtk::Box.new(:vertical, 10)
		
		greetingBox = Gtk::Box.new(:vertical, 10)
		greetingLabel = Gtk::Label.new("Hello, and welcome to "\
										"Connect Four!")
		greetingLabel.set_alignment(0,1)
		greetingBox.add(greetingLabel)
		
		gameNameLabelBox = Gtk::Box.new(:vertical,10)
		gameNameLabel = Gtk::Label.new("Please enter a name for "\
										"this game:")
		gameNameLabel.set_alignment(0,1)
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
				newTitleLabel.set_alignment(0,1)
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
