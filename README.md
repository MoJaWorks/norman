MoJaWorks Norman Engine
===========

This is an internal game framework experiment used by MoJaWorks Games. It is not currently intended for wider use. It is still in development and most parts are incomplete or non-existant at this moment in time.

##Aim

This will be a library for haxe in a similar vein to Lime and Snow that has abstracted implementations for major platforms and is usable as a single haxe layer. The eventual target platforms will be as follows:

####Desktop (Windows/OSX/Linux)
These will use an SDL layer and the haxe code will be compiled to C++

####Android
This will use the Android SDKs directly and will be compiled to Java

####iOS
This will use the iOS sdks directly and will be compiled to C++

####Windows Phone 8+
This will use either a c# or c++ compile and will use the windows phone SDK directly. This will likely need to be coded with DirectX or ANGLE.

####Flash
This will use stage3D and will give an accelerated experience similar to Starling

####HTML5
This will aim to use WebGL but may fall back to canvas if required. Compiled to JS.

##Norman
The norman engine will be built on top of these other technologies to provide a single abstracted layer to use when coding games. It will be object oriented in approach and focus on 2D rendering and interactions. Everything is theoretical up to now so don't expect any major progress in the near future.

