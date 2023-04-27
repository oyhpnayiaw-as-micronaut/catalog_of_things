require_relative 'lib/app'

App.new(
  models: %i[],
  hidden_list: %i[item],
  hidden_create: %i[item genre author label],
  questions: {
    music_album: {
      on_spotify?: 'Is this album on Spotify?'
    }
  }
).start
