require_relative '../shared/people/person'

class Engine
	def initialize
	end
	
	def collectInfo(greet=true)
		if (greet)
			puts "\nHello, and welcome!\n\n"\
				"Please provide a little information to get started.\n\n"
		end
		puts "What's your first name?"
		firstName = gets
		firstName = firstName.chomp
		
		puts "And, your last name?"
		lastName = gets
		lastName = lastName.chomp
		
		puts "What about your birthday?"
		birthday = gets
		birthday = birthday.chomp
		
		puts "Please confirm the following information:"
		puts "Name: "+firstName+" "+lastName
		puts "Birthday: "+birthday
		puts "Is this correct? Y/N"
		
		confirmed = gets
		confirmed = confirmed.chop
		
		if (confirmed == "Y")
			person = Person.new(firstName,lastName,birthday)
			person.saveInfo
			person.greet
			person.calculateAge
			person.getAge
			puts person.countPeople
		else
			puts "OK, let's try again."
			collectInfo(false)
		end
	end
end

if __FILE__ == $0
	iou = IOUtil.new
	iou.collectInfo
end
