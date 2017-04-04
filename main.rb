require 'gosu'
require_relative 'lib/boyert_adventures'
require_relative 'lib/player'
require_relative 'lib/map'
require_relative 'lib/collision_manager'
require_relative 'lib/camera'
require_relative 'lib/enemy'
require_relative 'lib/game'
require_relative 'lib/start_menu'

s = Game.new
s.show
