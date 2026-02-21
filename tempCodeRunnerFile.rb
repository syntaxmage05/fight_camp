# frozen_string_literal: true

require "gosu"
require_relative "lib/animation"

# Main class
class GameWindow < Gosu::Window
  BACKGROUND = media_path("country_field.png")

  def initialize(width = 800, height = 600, fullscreen: false)
    super
    self.caption = "Hello Animation"
    @background = Gosu::Image.new(self, BACKGROUND, false)
    @music = Gosu::Song.new(self, media_path("menu_music.mp3"))
    @music.volume = 0.5
    @music.play(true)
    @animation = Explosion.load_animation(self)
    @sound = Explosion.load_sound(self)
    @explosions = []
  end

  def update
    @explosions.reject!(&:done?)
    @explosions.map(&:update)
  end

  def button_down(id)
    close if id == Gosu::KbEscape

    return unless id == Gosu::MsLeft

    @explosions.push(
      Explosion.new(
        @animation, @sound, mouse_x, mouse_y
      )
    )
  end

  def needs_cursor?
    true
  end

  def needs_redraw?
    !@scene_ready || @explosions.any?
  end

  def draw
    @scene_ready ||= true
    @background.draw(0, 0, 0)
    @explosions.map(&:draw)
  end
end

window = GameWindow.new
window.show
