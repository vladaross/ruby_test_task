require 'yaml'
require 'pry'

config = YAML.load_file(ARGV.first || 'config.yml')

class ATM
	
	attr_reader :config, :account, :acc_number, :account_number, :balance, :amount, :name, :remaining_amount, :total_amount_of_specific_banknote

	def initialize(config)
		@config =config
	end

	
	def enter_system()
		account_numbers = config['accounts'].keys
		puts "Enter your account number: "
		acc_number = $stdin.gets.chomp.to_i
		@balance = config['accounts'][acc_number]['balance'].to_i
		@name = config['accounts'][acc_number]['name']
		if account_numbers.include?(acc_number)
			puts "enter password"
			password = $stdin.gets.chomp

			if password ==config['accounts'][acc_number]['password']
				puts "Hello, #{config['accounts'][acc_number]['name']}!"
			else
				puts "You entered wrong password"

			end
		else
			puts "ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
		end
	end


	def display_balance
		
		puts "Your Current Balance is #{balance}"
	end

	
	def withdraw()
		@balance 
		puts "Enter Amount You Wish to Withdraw:"
		amount = $stdin.gets.to_i
		
		if amount > balance
			puts "INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT: "
			amount = $stdin.gets.to_i
			#remaining_amount = (balance -= amount)
		else 
			
			remaining_amount = balance - amount
			puts "#{remaining_amount}"

		end
	end

	
	def banknotes()
		@banknotes = []
		remaining_amount = amount
		while remaining_amount != 0
			banknote = get_highest_banknote(remaining_amount)
			banknotes << banknote
			remaining_amount = remaining_amount - banknote
		end
		banknotes
	end

	
	def get_highest_banknote()
		binding.pry
		total_amount_of_specific_banknote = []
		 config['banknotes'].map do |banknote, number_of_baknotes|
		   
		   number_of_baknotes.times do
		 	 total_amount_of_specific_banknote << banknote

		   end
		   total_amount_of_specific_banknote.flatten
		end
		index = 0
		banknote =total_amount_of_specific_banknote[index]
		until amount >= banknote
			index = index + 1
			banknote = total_amount_of_specific_banknote[index]
		end
		puts "#{amount}, #{banknote}"
		banknote
	end
	

	def log_out
		puts "#{name}, Thank You For Using Our ATM. Good-Bye!"
  
	end


	def options
		loop do 
			
		puts "Please Choose From the Following Options:
 				1. Display Balance
 				2. Withdraw
 				3. Log Out"
 		choise =$stdin.gets.chomp
 		case choise
 		when  '1' 
 			display_balance
 			
 		when '2'
 			withdraw
 			get_highest_banknote
			
		else '3'
			log_out


		end

		end		
	end

	 

	
end



atm = ATM.new(config)
atm.enter_system
atm.options






