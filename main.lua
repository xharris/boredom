io.stdout:setvbuf("no")

require "plugins/misc_functions"
require "plugins/tile_manager"
class = require "plugins/middleclass/middleclass"
hc = require "plugins/Hardon-Collider"
anim8 = require 'plugins/anim8/anim8'

require "player"

player = nil
collider = nil

function love.conf(t)
    t.identity = nil                   -- The name of the save directory (string)
    t.version = "0.9.2"                -- The LÖVE version this game was made for (string)
    t.console = true                  -- Attach a console (boolean, Windows only)
 
    t.window.title = "Untitled"        -- The window title (string)
    t.window.icon = nil                -- Filepath to an image to use as the window's icon (string)
    t.window.width = 800               -- The window width (number)
    t.window.height = 600              -- The window height (number)
    t.window.borderless = false        -- Remove all border visuals from the window (boolean)
    t.window.resizable = false         -- Let the window be user-resizable (boolean)
    t.window.minwidth = 1              -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1             -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false        -- Enable fullscreen (boolean)
    t.window.fullscreentype = "normal" -- Choose between "normal" fullscreen or "desktop" fullscreen mode (string)
    t.window.vsync = true              -- Enable vertical sync (boolean)
    t.window.fsaa = 0                  -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1               -- Index of the monitor to show the window in (number)
    t.window.highdpi = false           -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.srgb = false              -- Enable sRGB gamma correction when drawing to the screen (boolean)
    t.window.x = nil                   -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                   -- The y-coordinate of the window's position in the specified display (number)
end

function love.load()

    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.setDefaultFilter("nearest","nearest")

    -- load level 1
    load_level('level1')
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    draw_level()
    player:draw()
end