require_relative 'lib/app'

App.new(
  models: %i[], # add your models here if you models file is outside of the models folder
  hidden_list: %i[item],
  hidden_create: %i[item genre author label]
).start
