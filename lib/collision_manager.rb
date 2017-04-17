class CollisionManager

    def initialize(player, map, enemies)
        @player = player
        @map = map
        @enemies = enemies
        @hit_sound = Gosu::Sample.new('media/Hit_02.wav')
        @values = []
    end

    def player_map_collision
        @player_rec = [@player.x, @player.y, @player.width, @player.height]
        @player.not_on_ground
        @player.not_stuck

        @map.b_values.each do |values|
            block_rec = [values[0], values[1], 32, 32]

            collision = check_for_collision(@player_rec, block_rec)

            if collision == :left
                @player.stuck(collision)
                @player.x = values[0] + @player.width
                if (@player.y + @player.height) == values[1]
                    @player.not_stuck
                end
            elsif collision == :right
                @player.stuck(collision)
                @player.x = values[0] - @player.width
                if (@player.y + @player.height) == values[1]
                    @player.not_stuck
                end
            elsif collision == :bottom and @player.ground? == false
                @player.on_ground
                @player.y = values[1] - 32
            end

        end

    end

    def enemy_map_collision
        @enemies.each do |enemy|
            @enemy_rec = [enemy.x, enemy.y, enemy.width, enemy.height]
            enemy.not_on_ground
            @map.b_values.each do |values|
                block_rec = [values[0], values[1], 32, 32]
                collision = check_for_collision(@enemy_rec, block_rec)

                if collision == :left
                    enemy.change_direction
                elsif collision == :right
                    enemy.change_direction
                elsif collision == :bottom
                    enemy.on_ground
                    enemy.y = values[1] - 32
                end

            end
        end

    end

    def player_enemy_collision
        player_rec = [@player.x, @player.y, @player.width, @player.height]

        @enemies.each do |enemy|
            enemy_rec = [enemy.x, enemy.y, enemy.width, enemy.height]

            collision = check_for_collision(player_rec, enemy_rec)

            if collision == :left
                unless @player.damage || @player.invulnerable
                    @player.take_damage(collision)
                    @hit_sound.play
                end
            elsif collision == :right
                unless @player.damage || @player.invulnerable
                    @player.take_damage(collision)
                    @hit_sound.play
                end
            elsif collision == :bottom
                enemy.kill
                @player.on_ground
                @player.jumping

            end

        end


    end

    def check_for_collision(rect1, rect2)

        intersect = intersection([[rect1[0], rect1[1]],
                                  [rect1[0] + rect1[2], rect1[1] + rect1[3]]],
                                 [[rect2[0], rect2[1]],
                                  [rect2[0] + rect2[2], rect2[1] + rect2[3]]])

        if intersect
            top_left, bottom_right = intersect
            if (bottom_right[0] - top_left[0]) > (bottom_right[1] - top_left[1])
                if rect1[1] == top_left[1]
                    :top
                else
                    :bottom
                end
            else
                if rect1[0] == top_left[0]
                    :left
                else
                    :right
                end
            end
        else
            nil
        end

    end

    def intersection(rect1, rect2)
        x_min = [rect1[0][0], rect2[0][0]].max
        x_max = [rect1[1][0], rect2[1][0]].min
        y_min = [rect1[0][1], rect2[0][1]].max
        y_max = [rect1[1][1], rect2[1][1]].min
        return nil if ((x_max < x_min) || (y_max < y_min))
        return [[x_min, y_min], [x_max, y_max]]
    end

    def draw_collision_bodies(camera)
        draw_bounding_body(@player_rec, camera)
        draw_bounding_body(@enemy_rec, camera)
    end

    def draw_bounding_body(rect, camera, z = 10, color = Gosu::Color::GREEN)
        return unless $DEBUG
        Gosu::draw_line(rect[0] - camera, rect[1], color, rect[0] - camera, rect[1] + rect[3], color, z)
        Gosu::draw_line(rect[0] - camera, rect[1] + rect[3], color, rect[0] + rect[2] - camera, rect[1] + rect[3], color, z)
        Gosu::draw_line(rect[0] + rect[2] - camera, rect[1] + rect[3], color, rect[0] + rect[3] - camera, rect[1], color, z)
        Gosu::draw_line(rect[0] + rect[2] - camera, rect[1], color, rect[0] - camera, rect[1], color, z)
    end

    def update
        if !@player.dead
            player_enemy_collision
            player_map_collision
            if @player.x <= 0
                @player.stuck(:left)
            elsif @player.x + @player.width >= @map.b_values[-1][0]-32*5
                @player.win
            end
        else
            @player.on_ground = false
        end
        enemy_map_collision
    end

    def draw(camera)
        draw_collision_bodies(camera.x)
        @map.b_values.each do |values|
            @block = [values[0], values[1], 32, 32]
            draw_bounding_body(@block, camera.x)
        end
    end
end
