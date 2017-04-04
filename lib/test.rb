# def xyt(vel_x, vel_y, t, org_x, org_y, g)
#     x = vel_x * t + org_x
#     y = -1 * (((-g*t**2)/2) + vel_y * t + org_y) + org_y
#     puts "#{x};#{y}"
# end
#
# t = 0
#
# while t < 20
#     xyt(2, 3, t, 0, 0, 0.5)
#     t = t + 1
# end
class Rectangle

    def initialize(x, y, width, height)
        @x = x
        @y = y
        @height = height
        @width = width
    end

    def top
        @y
    end

    def bottom
        (@y + @height)
    end

    def left
        @x
    end

    def right
        (@x + @width)
    end

    def intersect(rect1, rect2)
        !(rect2.left > rect1.right ||
        rect2.right < rect1.left ||
        rect2.top > rect1.bottom ||
        rect2.bottom < rect1.top)
    end

end
