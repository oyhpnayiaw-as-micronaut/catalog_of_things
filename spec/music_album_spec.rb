require 'date'

require_relative '../lib/item'
require_relative '../lib/music_album'

describe MusicAlbum do
  let(:music_album) do
    MusicAlbum.new(genre: nil, author: nil, label: nil, publish_date: Date.today, on_spotify: true)
  end

  describe '#initialize' do
    it 'creates a new instance of MusicAlbum' do
      expect(music_album).to be_an_instance_of MusicAlbum
    end
  end

  describe '#can_be_archived?' do
    it 'returns false if publish_date is less than 10 year' do
      expect(music_album.can_be_archived?).to be false
    end

    it 'returns false if the muisc album is not on Spotify' do
      music_album.on_spotify = false
      expect(music_album.can_be_archived?).to be false
    end

    it 'returns true if the music album is not on Spotify and publish_date is less than 10 year' do
      music_album.publish_date = Date.today.prev_year(11)
      expect(music_album.can_be_archived?).to be true
    end
  end
end
