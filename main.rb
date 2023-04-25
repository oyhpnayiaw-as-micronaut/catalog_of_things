def run
  puts "Welcome to our App
    1.
    2.
    3.Quit"
  option = gets.chomp.to_i
  return unless option == 3

  exit
  puts 'Thank you for using our app'
end

loop { run }
