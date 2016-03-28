require_relative '../shared/people/person'

class Player < Person

	@id
	@p_id
	@username
	@color # red or yellow, oldest player chooses
	@piecesRemaining = 21
	
	attr_accessor :color, :username
	
	def initialize; end
	
	def collectInfo
		puts "What's your first name?"
		firstName = gets
		@firstName = firstName.chomp
		
		puts "And, your last name?"
		lastName = gets
		@lastName = lastName.chomp
		
		puts "What about your birthday?"
		birthday = gets
		@birthday = birthday.chomp
		
		puts "Please confirm the following information:"
		puts "Name: "+@firstName+" "+@lastName
		puts "Birthday: "+@birthday
		puts "Is this correct? Y/N"
		
		confirmed = gets
		confirmed = confirmed.chomp
		
		if (confirmed == "Y")
			self.saveInfo
			self.greet
			self.calculateAge
			self.getAge
			puts self.countPeople
			return true
		else
			puts "OK, let's try again."
			return self.collectInfo
		end
	end
	
	def playPiece; end
end
