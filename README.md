# Godot GamePad

![Github_controller_image](https://user-images.githubusercontent.com/63984796/107984996-11cad500-6f7e-11eb-8393-2051fbcd4613.png)

### Introduction
The Godot GamePad is a two part project that allows players to use there mobile devices as controllers with games made in Godot.  The mobile app will be
free to download on the Google Play and Apple App stores when it is finished.  The aim of this is project to make local multiplayer games more accessable to players and developers by replacing costly physical controllers with a device available to everyone.

___

### For Developers
> **if you are going to try and build the GamePad Mobile app yourself, you must use Godot 3.2.4 or higher and set Project Settings>Input Devices>Touch Delay = 0.  Otherwise there will be signifficant latency**

As a developer, you can allow your game to work with the gamepad by downloading the [GodotGamePad Plugin](https://github.com/ACB-prgm/Godot_GamePad/tree/main/PluginTest) from this repository and integrating it into your project ([how to install plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html)).  This plugin allows you to configure the layout of the controller as shown in the image below to be custom for your game.  This plugin also creates an autoload 
called [GamePad](https://github.com/ACB-prgm/Godot_GamePad/blob/main/PluginTest/addons/GodotGamePad/Networking/GamePad.gd) that serves as an API for receiving the controller inputs and connecting and managing GamePads.  To understand how to use it, open the script and read the comments. (this will be improved in the future).  There is also currently an [Example Lobby](https://github.com/ACB-prgm/Godot_GamePad/tree/main/PluginTest/ExampleLobby) scene in the **PluginTest** directory that shows how you might go about setting up a scene to connect controllers.

![Github_plugin_image](https://user-images.githubusercontent.com/63984796/107985163-68d0aa00-6f7e-11eb-9354-33b23a0c3f0b.png)

___

### Planned Features:
(√ = added, X = not yet added)
- √ D-Pad
- √ Joystick
- √ Action Buttons
- X Text Input (enter names or trivia answers)
- X Square Text Buttons (versitle buttons that are more customizeable. Start/menu buttons and trivia buttons are examples)
- X Steering Wheel (Gyroscope)
- X Aesthetics Editing (change background color)
