def run 
    puts "Welcome to our App
    1.
    2.
    3.Quit"
    option = gets.chomp.to_i
    if option == 3 
        exit
        puts 'Thank you for using our app'
    end
end

loop { run }