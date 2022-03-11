# Ruby in Fantasy

An upper layer over Gosu library to offer a more friendly API for an easy and lean game development.

Specially intended to use Ruby as a learning language to introduce children into programming.

**Attention**: This project is in early development phase, right now it is just an experiment

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

### Actor

Managing game elements which have (optionally) image, movement and collision

- Easy to set an `image`
- Managing movement through `direction` and `speed`
- Built-in movement control through cursors
- Collision detection, OnCollision callback
- Jump (TODO)
- Gravity (TODO)
- Animations (TODO)
- Possibility to extend Actor class or instantiate it directly for simple characters

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

When active different attributes from all the Actors and HUD elements will be visible in the screen.

- Position
- Collider

On top, when debug mode is active, the Actors and HUD elements become draggable.
The new position won't be persistent but it will be helpful to identify which should be the desired position.

### Camera

Setting up a camera component that we can easily move around and all the active
Actors in the game will be rendered in the relative position to this camera.

- Allow camera move
- Easy to follow one actor

### Colors palette (TODO)

- Not deal with RGB or anything, just a list of colors (TODO)

### Game Scene transitions

Easy to configure 3 basic game states:

- Game presentation scene
- Game game scene
- Game end scene
- Other scenes, like levels or such (TODO)

Each state should be independent and unique Actors and other elements can be created and configured for each state

Built-in mechanism to move from one state to another.

### Pause Game (TODO)

- Pause game, pause Actors, animations, clocks, ... (TODO)

### Core run

Move the core functions to the top level hierarchy so I don't need to create a `Game::Window` class

### Sound

Direct and easy way to play a sound

### Background

Simple way to set up:

- Background color
- Image background (TODO)
- Repeatable image background (TODO)

### Data Persistance (TODO)

Simple mechanism to save data in disk. For user preferences, game progress, high scores and others

### User Inputs

Easy access to keyboard and mouse inputs on any part of the code. Specially in the Actors.

- Allow "on_space_bar" and each Actor (TODO)
- Allow multiple "on_space_bar" (TODO)
- Remove "on_space_bar" when changing scene (TODO)

## API



## Credits for assets

- Sprites: www.kenney.nl
- Font: VT323 Project Authors (peter.hull@oikoi.com)

## Bugs

- When dragging in debug mode new elements are being added to the drag (TODO)
- Rubocop is not passing

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fguillen/fantasy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
