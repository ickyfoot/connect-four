require_relative 'player'
require 'gtk3'

class UIManager
	
	def initialize
	end
	
	def newWindow(application)
		window = Gtk::ApplicationWindow.new(application)
		window.set_title("Connect Four")
		window.set_default_size(400,400)
		window.set_border_width(10)
		return window
	end
end

if __FILE__ == $0
	engine = Engine.new
	# Person.clearPeople
	# engine.startGame
end
