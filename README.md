MoJaWorks Norman Engine
===========

This is an internal game framework experiment used by MoJaWorks Games. It is not currently intended for wider use. It is still in development and most parts are incomplete or non-existant at this moment in time.

##Aim

This will be a framework for Haxe based on Lime and Snow that has abstracted implementations for major platforms and is usable as a single haxe layer. The eventual target platforms will be as follows:

####Desktop ( Windows / OSX / Linux )
Using the default Lime implementation and OpenGL calls to render.

####Mobile ( Android / iOS )
Using lime as the backend and OpenGL to render.

####Flash
This will use stage3D and will give an accelerated experience similar to Starling

####HTML5
This will aim to use WebGL but may fall back to canvas if required. Compiled to JS.

##Norman
The norman engine will be built on top of lime to provide a single abstracted layer to use when coding games. It will be object oriented in approach and focus on 2D rendering and interactions. It will provide an alternative to OpenFL that is not constrained by the Flash API. 

##Development
Development will initially focus on the Flash and Windows targets. Android will be the first mobile target added and will build on the Windows implementation. iOS and HTML5 will follow after and then once all targets are available, investigation will begin into other platforms such as Windows Phone 8.1.

