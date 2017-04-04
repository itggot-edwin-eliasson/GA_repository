$DEBUG = false

class BoyertAdventures

    def initialize(window)
        @window = window
        @background_image = Gosu::Image.new('media/background.jpg')

        setup
    end

    def setup
        @player = Player.new(@window)
        @camera = Camera.new(@player, @window)
        @map = Map.new(@camera)
        @enemies = [Enemy.new]
        @collision_manager = CollisionManager.new(@player, @map, @enemies)

        @score = 10000000
        @score_text = Gosu::Font.new(@window, 'Fipps-Regular', 32)
    end

    def draw
        @player.draw(@camera)
        @enemies.each do |enemy|
            unless enemy.alive?
                enemy.draw(@camera)
            end
        end
        @collision_manager.draw(@camera)
        @background_image.draw(0,0,-2)
        @map.draw
        @score_text.draw("Score: #{@score}", 480, 10, 3, 1.0, 1.0, 0xff_ffffff)

        @player.lives.each_with_index do |life, i|
            life.draw(10 + (life.width + 10) * i, 10, 3)
        end
    end

    def button_down(id)
        @player.button_down(id)
    end

    def update
        unless @player.damage
            if Gosu::button_down? Gosu::KbRight
                @player.move(:right)
            elsif Gosu::button_down? Gosu::KbLeft
                @player.move(:left)
            else
                @player.not_walking
            end
        end
        # if !Gosu::button_down? Gosu::KbLeft and !Gosu::button_down? Gosu::KbRight
        #     @player.standing_still
        # end
        @player.update
        @collision_manager.update
        @camera.update(@map)
        @enemies.each do |enemy|
            unless enemy.alive?
                enemy.update
            end
        end
        @enemies.reject! {|enemy| enemy.alive?}
        if @player.y > @window.height + 100
            exit
        end
        @score = 10000000 - Gosu::milliseconds
    end

end
