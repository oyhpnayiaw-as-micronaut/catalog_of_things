require_relative 'lib/app'

App.new(
  hidden_list: %i[item],
  hidden_create: %i[item genre author label]
).start
