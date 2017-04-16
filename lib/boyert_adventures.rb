$DEBUG = false

class BoyertAdventures

    def initialize(window)
        @window = window
        @background_image = Gosu::Image.new('media/background.jpg')
        @win_txt = Gosu::Image.from_text('YOU WIN!', 72, {font: 'media/Fipps-Regular.ttf'})
        @lose_txt = Gosu::Image.from_text('GAME OVER', 72, {font: 'media/Fipps-Regular.ttf'})
        @lvl_txt = Gosu::Font.new( 32, {name: 'media/Fipps-Regular.ttf'})


        setup
    end

    def setup
        @player = Player.new(@window)
        @camera = Camera.new(@player, @window)
        @map = Map.new(@camera)
        @enemies = [Enemy.new]
        @collision_manager = CollisionManager.new(@player, @map, @enemies)

        @score = 10000000
        @score_text = Gosu::Font.new(32, {name: 'media/Fipps-Regular.ttf'})
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
        @score_text.draw("SCORE: #{@score}", 480, 10, 10, 1.0, 1.0, 0xff_ffffff)

        @player.lives.each_with_index do |life, i|
            life.draw(10 + (life.width + 10) * i, 10, 3)
        end

        @lvl_txt.draw("LEVEL: #{@map.level}", @window.width/2 - 25, 10, 10, 1.0, 1.0, 0xff_Ffffff)

        if @player.winner
            @win_txt.draw_rot(@window.width/2, @window.height/2 - 30, 10, 0, 0.5, 0.5, 1, 1, 0xff_Ffffff)
        end

        if @player.y > @window.height + 300 || @player.dead
            @lose_txt.draw_rot(@window.width/2, @window.height/2 - 30, 10, 0, 0.5, 0.5, 1, 1, 0xff_Ffffff)
        end
    end

    def button_down(id)
        @player.button_down(id)
    end

    def update
        unless @player.damage
            if Gosu::button_down? Gosu::KbRight
                if !@player.winner
                    @player.move(:right)
                end
            elsif Gosu::button_down? Gosu::KbLeft
                if !@player.winner
                    @player.move(:left)
                end
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
        if @player.y > @window.height + 300 && !@player.dead
            @player.dead?
        end
        if !@player.winner && !@player.dead
            @score = 10000000 - Gosu::milliseconds
        end

    end

end
