
class StartMenu

    def initialize(window)
        @window = window
        @game_title = Gosu::Image.from_text('BOYERT ADVENTURES', 72, {font: 'media/Fipps-Regular.ttf'})
        @start_game_txt = Gosu::Image.from_text('Start', 40, {font: 'media/Fipps-Regular.ttf'})
        @quit_game_txt = Gosu::Image.from_text('Quit', 40, {font: 'media/Fipps-Regular.ttf'})
        @move_sound = Gosu::Sample.new('media/Menu_Navigate_00.wav')

        @options = [:start, :quit]
    end

    def selected
        @options.first
    end

    def move
        @options.rotate!(1)
        @move_sound.play
    end

    def sel
        return @options[0]

    end

    def draw
        @game_title.draw_rot(@window.width/2, 120, 10, 0, 0.5, 0.5, 1, 1, 0xff_E19A00)
        if @options[0] == :start
            @start_game_txt = Gosu::Image.from_text('Start', 56, {font: 'media/Fipps-Regular.ttf'})
            @quit_game_txt = Gosu::Image.from_text('Quit', 48, {font: 'media/Fipps-Regular.ttf'})
        else
            @start_game_txt = Gosu::Image.from_text('Start', 48, {font: 'media/Fipps-Regular.ttf'})
            @quit_game_txt = Gosu::Image.from_text('Quit', 56, {font: 'media/Fipps-Regular.ttf'})
        end
        @start_game_txt.draw_rot((@window.width/2), @window.height/2, 10, 0, 0.5, 0.5, 1, 1, 0xff_ffffff)
        @quit_game_txt.draw_rot(@window.width/2, @window.height/2 + 40, 10, 0, 0.5, 0.5, 1, 1, 0xff_ffffff)
    end


end
