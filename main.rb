require_relative 'lib/app'

APP = App.new

def end_app
  puts 'Thank you for using our app'
  APP.save_data
  exit
end

puts "Welcome to the app\n\n"

def run
  puts <<~OPTIONS
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
  OPTIONS

  option = gets.chomp.to_i

  case option
  when 1
    APP.list_books
  when 2
    APP.list_music_albums
  when 3
    APP.list_games
  when 4
    APP.list_genres
  when 5
    APP.list_labels
  when 6
    APP.list_authors
  when 7
    APP.create_book
  when 8
    APP.create_music_album
  when 9
    APP.create_game
  when 0
    end_app
  else
    puts 'Invalid option'
  end
rescue Interrupt
  end_app
end

loop { run }
