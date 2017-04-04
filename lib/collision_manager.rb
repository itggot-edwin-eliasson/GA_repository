class CollisionManager

    def initialize(player, map, enemies)
        @player = player
        @map = map
        @enemies = enemies
        @values = []
    end

    # def on_ground
    #     @map.array.each_with_index do |row, y|
    #         row.each_with_index do |object, x|
    #             if object == "b"
    #                 map_range_x = 0
    #                 map_range_y = 0
    #                 p_range_x = 1
    #                 while map_range_x < 33
    #                     while map_range_y < 33
    #                         while p_range_x < @player.width
    #                             if (@player.y + @player.height).round > (y*32 + map_range_y) and (@player.x + p_range_x) == (x*32 + map_range_x)
    #                                 @player.on_ground
    #                             end
    #                             p_range_x += 1
    #                         end
    #                         map_range_x += 1
    #                         map_range_y += 1
    #                     end
    #                 end
    #             end
    #         end
    #     end
    # end

    # def on_ground_2
    #     @map.b_values.each do |values|
    #         rect1_left = @player.x
    #         rect1_right = @player.x + @player.width
    #         rect2_left = values[0]
    #         rect2_right = values[0] + 32
    #         rect1_top = @player.y
    #         rect1_bottom = @player.y + @player.height
    #         rect2_top = values[1]
    #         rect2_bottom = values[1] + 32
    #         if !(rect2_left > rect1_right || rect2_right < rect1_left || rect2_top > rect1_bottom || rect2_bottom < rect1_top)
    #             p rect2_left, rect2_top, @player.ground?
    #             @player.on_ground
    #             @player.dont_move
    #             @player.y = rect2_top-32
    #         else
    #             @player.not_on_ground
    #         end
    #     end
    # end

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
                p values[0], values[1], @player.x, @player.y
            elsif collision == :right
                @player.stuck(collision)
                @player.x = values[0] - @player.width
            elsif collision == :bottom and @player.ground? == false
                @player.on_ground
                @player.y = values[1] - 32
            elsif collision == nil

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

            # p enemy.x + enemy.width, enemy.y

            collision = check_for_collision(player_rec, enemy_rec)

            if collision == :left
                unless @player.damage || @player.invulnerable
                    @player.take_damage(collision)
                end
            elsif collision == :right
                unless @player.damage || @player.invulnerable
                    @player.take_damage(collision)
                end
            elsif collision == :bottom
                @player.on_ground
                @player.jumping
                enemy.kill
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
        player_enemy_collision
        player_map_collision
        enemy_map_collision
        if @player.x <= 0
            @player.stuck(:left)
        elsif @player.x + @player.width >= @map.b_values[-1][0]
            @player.stuck(:right)
        end
    end

    def draw(camera)
        draw_collision_bodies(camera.x)
        @map.b_values.each do |values|
            @block = [values[0], values[1], 32, 32]
            draw_bounding_body(@block, camera.x)
        end
    end
end
