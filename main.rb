require_relative 'lib/app'

APP = App.new

def end_app
  puts 'Thank you for using our app'
  APP.save_data
  exit
end

def run
  puts "Welcome to our App
  1) List all books
  2) List all music albums
  3) List all games
  4) List all genres
  5) List all labels
  6) List all authors
  7) Add a book
  8) Add a music album
  9) Add a game
  0) Exit
"
  option = gets.chomp.to_i

  case option
  when 1
    APP.list_books
  when 2
    APP.list_music_albums
  when 3
    puts 'Option 3'
  when 4
    APP.list_genres
  when 5
    APP.list_labels
  when 6
    puts 'Option 6'
  when 7
    APP.create_book
  when 8
    APP.create_music_album
  when 9
    puts 'Option 9'
  when 0
    end_app
  else
    puts 'Invalid option'
  end
rescue Interrupt
  end_app
end

loop { run }
