require_relative 'lib/app'

App.new(
  extra_models: %i[],
  hidden_list: %i[item],
  hidden_add: %i[item genre author label],
  questions: {
    music_album: {
      on_spotify?: 'Is this album on Spotify?'
    },
    book: {
      publisher: 'Who is the publisher?',
      cover_state: 'Is the book cover good or bad?'
    },
    game: {
      multiplayer?: 'Is this game multiplayer?',
      last_played_at_date: 'When was the last time you played this game?'
    }
  }
).start
