require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'

require File.expand_path('../../lib/jumio_rock.rb', __FILE__)

def create_test_image
  path = File.expand_path(File.join(File.dirname(__FILE__), "../../../tmp/filename.png"))

  png = ChunkyPNG::Image.new(16, 16, ChunkyPNG::Color::TRANSPARENT)
  png[1,1] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
  png[2,1] = ChunkyPNG::Color('black @ 0.5')
  png.save(path)

  path
end