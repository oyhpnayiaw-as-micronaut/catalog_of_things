require 'date'

require_relative 'store'
require_relative 'table'
require_relative 'question'
require_relative 'genre'
require_relative 'music_album'
require_relative 'book'
require_relative 'label'
require_relative 'game'
require_relative 'author'

class App
  include Store
  include Table
  include Question

  ITEM_HEADER = %w[Genre Author Label PublishDate].freeze

  def initialize
    @genres = []
    @authors = []
    @labels = []
    @books = []
    @music_albums = []
    @games = []

    hash = load_all_data

    hash.each do |key, value|
      instance_variable_set("@#{key}", value || [])
    end
  end

  def create_book
    publisher = ask 'Who published this book?'
    cover_state = ask 'Is the book cover good or bad?'

    book = Book.new(**create_item, publisher: publisher, cover_state: cover_state)

    @books << book

    puts 'Book created'
    puts "----------------------\n\n"
  end

  def create_music_album
    on_spotify = ask 'Is this album on Spotify? (y/n)'
    on_spotify = on_spotify == 'y'

    album = MusicAlbum.new(**create_item, on_spotify: on_spotify)

    @music_albums << album

    puts 'Album created'
    puts "----------------------\n\n"
  end

  def create_game
    multiplayer = ask 'Is this a multiplayer? (y/n)'
    multiplayer = multiplayer == 'y'

    last_played_at = ask 'When was it last played? (YYYY-MM-DD)'
    last_played_at = Date.parse(last_played_at)

    game = Game.new(**create_item, multiplayer: multiplayer, last_played_at: last_played_at)

    @games << game

    puts 'Game created'
    puts "----------------------\n\n"
  end

  private

  # this method will ask common questions to create an item
  def create_item
    genre = ask_question(Genre, @genres)
    author = ask_question(Author, @authors)
    label = ask_question(Label, @labels)
    publish_date = ask 'What is the publish date? (YYYY-MM-DD)'
    publish_date = Date.parse(publish_date)

    { genre: genre, author: author, label: label, publish_date: publish_date }
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('list_')
      list_handler(method_name)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('list_') || super
  end

  def list_handler(method_name)
    list = method_name.to_s.split('_')[1..].join('_')
    var = instance_variable_get("@#{list}")

    if var.nil? || !var.is_a?(Array)
      puts "The #{list.split('_').join(' ')} is not a list."
      return
    end

    if var.empty?
      puts "There are no items in the #{list.split('_').join(' ')}."
      return
    end

    if var.first.instance_variables.empty?
      puts "The #{list.split('_').join(' ')} is not a list of items."
      return
    end

    puts list.split('_').map(&:capitalize).join(' ')

    arr = []
    arr << var.first
      .instance_variables.map { |v| v.to_s.delete('@') }
      .map { |v| v.split('_').map(&:capitalize).join(' ') }

    var.each do |item|
      arr << item.instance_variables.map do |v|
        val = item.instance_variable_get(v)
        if val.is_a?(Array)
          val.size
        else
          val
        end
      end
    end

    arr.to_table
  end
end
