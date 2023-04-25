require 'date'

require_relative 'table'
require_relative 'question'
require_relative 'genre'
require_relative 'music_album'

class App
  include Table
  include Question

  ITEM_HEADER = %w[Genre Author Label PublishDate].freeze

  def initialize
    @genres = []
    @authors = []
    @labels = []
    @music_albums = []
  end

  def list_music_albums
    puts 'Music Albums'
    arr = [ITEM_HEADER + ['On Spotify']]
    @music_albums.each do |album|
      arr << [
        album.genre.name,
        'Jon', # album.author.first_name,
        'Doe', # album.label.name,
        album.publish_date,
        album.on_spotify
      ]
    end
    arr.to_table
  end

  def list_genres
    puts 'Genres'
    arr = [['Name', 'Items count']]
    @genres.each do |genre|
      arr << [genre.name, genre.items.size]
    end
    arr.to_table
  end

  def create_music_album
    on_spotify = ask 'Is this album on Spotify? (y/n)'
    on_spotify = on_spotify == 'y'

    genre, author, label, publish_date = create_item

    album = MusicAlbum.new(
      genre: genre,
      author: author,
      label: label,
      publish_date: publish_date,
      on_spotify: on_spotify
    )

    @music_albums << album

    puts 'Album created'
    puts "----------------------\n\n"
  end

  private

  def create_item
    genre = ask_question(Genre, @genres, 'name')
    author = nil
    label = nil
    publish_date = ask 'What is the publish date? (YYYY-MM-DD)'
    publish_date = Date.parse(publish_date)

    [genre, author, label, publish_date]
  end
end
