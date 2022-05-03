# ThinkPad X1 Yoga Gen 5

Scripts to enable tablet mode, etc on my laptop.

## Context and problems

As of April 2022, I have this new (last year's model) convertible laptop. I like the
look and the features. The keyboard layout is a bit annoying, but I can work with it.
I prefer a Plasma desktop, so I installed Kubuntu. A lot of things work fine
out-of-the-box, but there are a few missing features.

* Flipping the screen to "tablet mode" disables the keyboard and touchpad, but
  I was confused, because my finger on the screen triggered a long-press event on the
  desktop background, putting Plasma into Edit Mode.
* Once in tablet mode, the screen should rotate based on the accelerometer, but it doesn't.
* The pen works, and disables the touch screen when it's in proximity, but the lower
  button doesn't work (hardware issue?).
* Plasma has settings for touchscreen gestures, but if that's enabled, tapping on the panel
  doesn't generate clicks correctly (it's a little weird), and scrolling is way too fast.
* None of the standard options for the compose key seems convenient to me. I usually use
  the Pause key, but the built-in keyboard doesn't have one.

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
Pause to be compose in the usual KDE settings, which should work with full-sized
external keyboards.

(Needs testing after restart.)
