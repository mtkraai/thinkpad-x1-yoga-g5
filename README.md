# ThinkPad X1 Yoga Gen 5 | Kubuntu 22.04

Scripts to improve tablet mode, etc on my laptop, with Kubuntu 22.04.

## Context and problems

As of April 2022, I have this new (last year's model) convertible laptop. I like the
look and the features. The keyboard layout is a bit annoying, but I can work with it.
I prefer a Plasma desktop, so I installed Kubuntu. A lot of things work fine
out-of-the-box, but there are a few missing features.

* [x] Flipping the screen to "tablet mode" disables the keyboard and touchpad, but
  I was confused, because my finger on the screen triggered a long-press event on the
  desktop background, putting Plasma into Edit Mode.
* [x] Once in tablet mode, the screen should rotate based on the accelerometer, but it doesn't.
* [x] The pen works, and disables the touch screen when it's in proximity, but the lower
  button doesn't work (hardware issue?). Turns out, holding the lower button changes the pen to
  eraser mode. Not the design I would wish for, but it'll do.
* [x] Plasma has settings for touchscreen gestures, but if that's enabled, tapping on the panel
  doesn't generate clicks correctly (it's a little weird), and scrolling is way too fast.
* [x] None of the standard options for the compose key seems convenient to me. I usually use
  the Pause key, but the built-in keyboard doesn't have one.
* [ ] Apparently, LibreOffice doesn't support touch or stylus. It's all just treated
  as a mouse.
* [ ] VS Code scrolls fine on my Kubuntu 18.04 all-in-one touchscreen desktop, but not
  on this Kubuntu 22.04 2-in-1 laptop. Tapping makes a click event, but dragging just moves
  the mounse cursor around.

I've seen [this](https://askubuntu.com/a/1257454) that indicates that some of these
things work in Plasma on Wayland, but my workflow isn't ready for Wayland yet.

## What I want to do

I'd like to keep it simple, with as few non-default or custom pieces as possible. For
quick, one-and-done settings, shell scripts are fine, but anything running in the
background (services), I'd prefer Python.

Here is my [list](https://github.com/stars/mtkraai/lists/thinkpad-x1-yoga-g5) of some
interesting related repos.

## Solutions

### Touch gestures

I installed the latest [Touchégg](https://github.com/JoseExposito/touchegg) from the PPA,
then the latest [Touché](https://github.com/JoseExposito/touche) from FlatHub to go with
it. This seems to solve the touch gesture support. However, I need two-finger swipes for
scrolling on the touchscreen, but Touché only presents three or four fingers for swipes
because the touchpad driver steals two-finger swipes for its own scrolling support.

Actually, KDE applications scroll with one finger. Any applications that don't work will
need to be dealt with individually.

A Firefox touch scrolling hint can be found
[here](https://superuser.com/questions/1151161/enable-touch-scrolling-in-firefox).
I modified the Firefox (snap) entry in the Plasma applications editor to include
`MOZ_USE_XINPUT2=1` after `env`.

### Compose key

With some hints from [here](https://askubuntu.com/questions/957513/how-can-i-set-the-compose-key-to-end)
and [here](https://wiki.archlinux.org/title/Xmodmap), I created `~/.Xmodmap` like this:

```
keycode 164 = Multi_key NoSymbol Multi_key
```

This makes the "Favorites" key (Fn+F12, star) the compose key. I can simultaniously set
Pause to be compose in the usual KDE settings, which works with full-sized external keyboards.

### Tablet orientation

In this repo, see the `rotate_desktop.sh` script. It's not Python, but a major part of it uses
awk, which makes me happy. It's based on the
[mildmojo/rotate_desktop.sh](https://gist.github.com/mildmojo/48e9025070a2ba40795c) gist, with ideas
from elsewhere mixed in with some original thoughts. I put it in `~/bin` and added it as a startup
script in KDE.
