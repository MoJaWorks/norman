The Basics
===

## GameObjects 

`GameObjects` are the foundation of the Norman framework and are essentially the entities of the ECS model. They are simply containers for a group of `Components`. A `GameObject` should never be extended, an individual `GameObject's` properties should be defined by the `Components` it contains. `GameObjects` should only be instantiated through `Factories`.

## Components

`Components` are blocks of code that define a `GameObject`. For example a renderable `GameObject` should have a renderer `Component` such as the built in `ImageRenderer` which holds information about the texture the `GameObject` is using. When combined with the `Transform` component, an image can be drawn to the screen in any given position. All objects will be automatically assigned a `Transform` component on creation. While `Components` can provide functionality, they must be invoked by a `System`.

`Components` can be extended and they will allow for polymorphic behaviour so for example you have a `Weapon` component that is extended by a `Sword` component and a `Gun` component. Retrieving all `Weapon` components from a `GameObject` will fetch all `Weapons`, `Swords` and `Guns` that have been added to that `GameObject`. Fetching all `Swords` will only fetch `Swords` and all components that have extended `Sword` so `Guns` and `Weapons` will not be retrieved.

## Systems

`Systems` are the driving force of your game. They run continuously and update `GameObjects` through their `Components`. Usually, when a `Component` is added to a `GameObject`, the `Component` will register itself with a `System`. This allows the `System` to keep track and update all of it's `Components` accordingly. New `Systems` should be registered with the `Governor`. The `Governor` updates all `Systems` in order of priority and is the best method to synchronise and update your game.

`Systems` can be split into `SubSystems`; the parent `System` would get the update from the `Governor` and it will in turn execute code, calling on it's `SubSystems` when necessary.

## Factories

`Factories` are the best (and only) way to construct `GameObjects`. They are static utility classes that can add a set of `Components` to a `GameObject` before returning it for use in your game. The most basic `GameObject` can be constructed using the `ObjectFactory` however there are other factories available to build more complex objects such as the `SpriteFactory` for various visual objects. One factory method can call another factory method to create a starting `GameObject` and then build on that. For example your own factory might call upon `SpriteFactory` to provide an image rendering `GameObject` before adding another set of `Components` to extend the `GameObject's` functionality.



