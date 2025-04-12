# Ruby in Fantasy

Simple toolbox library and lean API to build great mini games in Ruby.

An upper layer over Gosu library to offer a more friendly API for an easy and lean game development.

Specially intended to use Ruby as a learning language to introduce children into programming.

**Attention**: This project is in early development phase, right now it is just an experiment.

## Use

### Hello World

```ruby
require "fantasy"

SCREEN_WIDTH = 320
SCREEN_HEIGHT = 240

on_game do
  message = HudText.new(position: Coordinates.new(10, 10))
  message.text = "Hello, World!"
  message.size = "big"
end

start!
```

### Action game

This is a full playable game. Maybe not too challenging though :)

```ruby
# Add assets dependencies
# ./images/spaceship.<any>
# ./images/enemy.<any>
# ./images/laser.<any>
# ./sounds/shoot.<any>
# ./sounds/impact.<any>
# ./sounds/game_over.<any>

require "fantasy"

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 360

on_game do
  player = Actor.new("spaceship")
  player.collision_with = "enemy"
  player.position = Coordinates.new(100, 100)
  player.move_with_cursors
  player.speed = 100

  points = HudText.new(position: Coordinates.new(10, 20))
  points.text = 0

  10.times do
    enemy = Actor.new("enemy")
    enemy.position = Coordinates.new(rand * SCREEN_WIDTH, rand * SCREEN_HEIGHT)
  end

  on_space_bar do
    Sound.play("shoot")
    laser = Actor.new("laser")
    laser.collision_with = "enemy"
    laser.position = player.position + Coordinates.new(0, -10)
    laser.speed = 400
    laser.direction = Coordinates.up
    laser.on_collision do |other|
      if other.name == "enemy"
        Sound.play("impact")
        other.destroy
        laser.destroy
        points.text += 1
      end
    end
  end

  player.on_collision do |other|
    if other.name == "enemy"
      Sound.play("game_over")
      Global.go_to_end
    end
  end
end

on_end do
  HudText.new(position: Coordinates.new(10, 100), text: "You are dead. Press space to restart")

  on_space_bar do
    Global.go_to_game
  end
end

start!
```

## Examples

See the [Ruby in Fantasy Games Collection](https://github.com/fguillen/RubyInFantasyGames).
It is a collection of full playable games. For fun and for educational purposes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fantasy"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fantasy

## Features

### Game Scenes

Easy to configure 3 basic game states:

- Game presentation scene
- Game game scene
- Game end scene
- Other scenes, like levels or such (TODO)

Each state should be independent and unique Actors and other elements can be created and configured for each state

Built-in mechanism to move from one state to another.

### Actor

Managing game elements which have (optionally) image, movement and collision

- Easy to set an `image`
- Managing movement through `direction` and `speed`
- Built-in movement control through cursors
- Collision detection, OnCollision callback, Collision matrix
- Jump
- Gravity
- Animations (TODO)
- Possibility to extend Actor class or instantiate it directly for simple characters
- Allowing magic instance properties (Like in OpenStruct). So programmer can do `actor.stuff = 1` and it is valid (TODO)
- Alignment "center" and "top-left" (TODO)

### Clock

Create new execution threads to program delayed behaviors, repetitive actions, animations, ...

- Run now
- Run after a delay
- Repeat
- Stop
- Callback when finished (TODO)

### Animations

Add animations to an Actor and activate them when special state triggered

- Set frames (TODO)
- Duration in seconds (TODO)
- Run once (TODO)
- Run on loop (TODO)
- Stop (TODO)
- Callback when finished (TODO)

### Events queue / Signals (TODO)

Inspiration from:

- [LÖVE](https://love2d.org/wiki/love.event)
- [Godot](https://docs.godotengine.org/en/stable/classes/class_signal.html)


### UI

#### Button (TODO)

Easy to set up a graphical component that responds to mouse hover and click events.

- Set image (TODO)
- Set image when hover (TODO)
- Set image when clicked (TODO)
- OnClicked callback (TODO)

#### HUD Elements

For easy creation of head-up display components.

- Text Element
- Image Element
- Auto update text (observer variable changes) (TODO)

### Debug Mode

Press `d` to activate it. When active debug visuals are shown:

- Position
- Collider

On top, when debug mode is active, the Actors and HUD elements become draggable.
The new position won't be persistent but it will be helpful to identify which should be the desired position.

### Camera

Setting up a camera component that we can easily move around and all the active
Actors in the game will be rendered in the relative position to this camera.

- Allow camera move
- Easy to follow one actor

### Colors palette

- Not deal with RGB or anything, just a list of colors. See [Color.palette](COLOR_PALETTE.md)


### Pause Game (TODO)

- Pause game, pause Actors, animations, clocks, ... (TODO)

### Core run

Move the core functions to the top level hierarchy so I don't need to create a `Game::Window` class

### Sound

- Direct and easy way to play a sound
- Direct and easy way to play a background music


### Background

Simple way to set up:

- Background color
- Image background
- Repeatable image background

### Data Persistance

Simple mechanism to save data in disk. For user preferences, game progress, high scores and others

### User Inputs

Easy access to keyboard and mouse inputs on any part of the code. Specially in the Actors.

- Allow "on_space_bar" and each Actor (TODO)
- Allow multiple "on_space_bar" (TODO)
- Remove "on_space_bar" when changing scene (TODO)
- Detect when key/mouse button is pressed in the actual frame in any part of the code (TODO)

### Tilemap (TODO)

For easy creation of:

- Top-down map levels
- Platformer map levels (TODO)
- Allow specific map keys like a=>actor_1, b=>actor_2 (TODO)

### Tweens (TODO)

Multiple movement animation effects like in [DoTween](http://dotween.demigiant.com/documentation.php) (TODO)

### Externalized Variables (TODO)

Values that can be changed while the game is running. They can be in a Variables file. The game "watch" this file and update the variable in real time.

## API

### Game Scenes

Configure your game elements on each Scene:

```ruby
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 360

# (Optional)
on_presentation do
  # Game elements running when the game loads
end

# (Required)
on_game do
  # Game elements running when in game Scene
end

# (Optional)
on_end do
  # Game elements running when game is ended
end
```

How to go from Scene to Scene:

```ruby
Global.go_to_presentation
Global.go_to_game
Global.go_to_end
```

#### Example

```ruby
on_presentation do
  HudText.new(position: Coordinates.new(10, 100), text: "Press space to start")

  on_space_bar do
    Global.go_to_game
  end
end

on_game do
  # [...]
  if player.dead
    Global.go_to_end
  end
end

on_end do
  HudText.new(position: Coordinates.new(10, 100), text: "You are dead. Press space to re-tart")

  on_space_bar do
    Global.go_to_presentation
  end
end
```

### Actor

Actor can be used directly:

```ruby
player = Actor.new("warrior") # ./images/warrior.png
player.position = Coordinates.new(100, 100)
player.solid = true
player.speed = 200
player.layer = 1
player.move_with_cursors
player.collision_with = ["enemy", "bullets"] # default "all"

player.on_collision do |other|
  if other.name == "enemy"
    player.destroy
  end
end

player.on_after_move do
  if player.position.x > Global.screen_width
    player.position.x = Global.screen_width
  end

  if player.position.x < 0
    player.position.x = 0
  end
end
```

Or in a subclass:

```ruby
class Player < Actor
  def initialize
    super("warrior") # ./images/warrior.png
    @position = Coordinates.new(100, 100)
    @solid = true
    @speed = 200
    @layer = 1
    @direction = Coordinates.zero
    @collision_with = ["enemy", "bullets"] # default "all"
    move_with_cursors
  end

  def on_collision_do(other)
    if other.name == "enemy"
      destroy
    end
  end

  def on_after_move_do
    if @position.x > SCREEN_WIDTH
      @position.x = SCREEN_WIDTH
    end

    if @position.x < 0
      @position.x = 0
    end
  end
end
```

Actor settings for a platformer:

```ruby
player = Actor.new("warrior") # ./images/warrior.png
player.solid = true
player.jump = 150
player.gravity = 200
player.move_with_cursors(left: true, right: true, up: false, down: false, jump: true)

player.on_jumping do
  Sound.play("jump")
  player.image = "warrior_jump"
end

player.on_floor do
  player.image = "warrior"
end
```

### Clock

```ruby
clock =
  Clock.new do
    enemy.attack
    sleep(1)
    enemy.defend
  end

clock.run_now
clock.run_on(seconds: 2)
clock.repeat(seconds: 2, times: 10)
clock.stop
```

### Background

```ruby
# Simple color
on_presentation do
  Global.background = Color.new(r: 34, g: 35, b: 35)
end

# Replicable (by default) Image
# position is relative to Camera.main
on_game do
  background = Background.new(image_name: "beach")
  # background.repeat = false # if you don't want the image to replicate
  background.scale = 6
end
```

### Data Persistance

```ruby
Disk.data.records = [120_000, 11_000, 678]
Disk.data.last_level = 3
Disk.data.sound_volume = 12
Disk.save # data stored in ./disk/data.json

# ... in another session

Disk.data.records # => [120_000, 11_000, 678]
Disk.data.last_level # => 3
Disk.data.sound_volume # => 12
```

### Camera

```ruby
on_game do
  on_loop do
    # Camera follows player
    Camera.main.position.y = player.position.y - (SCREEN_HEIGHT / 2)
  end
end
```

### Sound

Plays only once:

```ruby
Sound.play("shoot") # ./sounds/shoot.wav
```

Plays in loop:

```ruby
Music.play("music") # ./musics/music.mp3
Music.volume = 0.5
Music.stop
```

### Tilemap

```ruby
# ./maps/sky.txt
# 0     0
#  0  1
#   0   0
# 0    01

planet = Actor.new("planet")
star = Actor.new("star")
map = Tilemap.new(map_name: "sky", tiles: [planet, star], tile_size: 30)
map.spawn
```

### UI

#### HUD Text

```ruby
timer = HudText.new(position: Coordinates.new(SCREEN_WIDTH / 2, 10))
timer.text = 0
timer.alignment = "center"
timer.size = "big"

Clock.new { timer.text += 1 }.repeat(seconds: 1)
```

#### HUD Image

```ruby
icon = HudImage.new(position: Coordinates.new(SCREEN_WIDTH - 220, 8), image_name: "ring")
icon.scale = 4
icon.visible = true

Clock.new { icon.visible = !icon.visible }.repeat(seconds: 1)
```


## Credits for assets

- Font: VT323 Project Authors (peter.hull@oikoi.com)

## Bugs

- When dragging in debug mode new elements are being added to the drag (TODO)
- Rubocop is not passing
- Tests are missing
- Allow Ruby 2.5+

## Assets

- Images for the test fixtures: https://kenney.nl/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fguillen/fantasy.

## Documentation

Generate the `/docs` folder with:

```
yard doc
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
