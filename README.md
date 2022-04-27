# ThinkPad X1 Yoga Gen 5

Scripts to enable tablet mode, etc on my laptop.

## Context and problems

As of April 2022, I have this new (last year's model) convertible laptop. I like the
look and the features. The keyboard layout is a bit annoying, but I can work with it.
I prefer a Plasma desktop, so I installed Kubuntu. A lot of things work fine
out-of-the-box, but there are a few missing features.

* Flipping the screen to "tablet mode" should disable the keyboard and touchpad, but
  it doesn't.
* Once in tablet mode, the screen should rotate based on the accelerometer.
* The pen works, and disables the touch screen when it's in proximity, but the lower
  button doesn't work (hardware issue?).
* Plasma has settings for touchscreen gestures, but if that's enabled, tapping on the
  panel doesn't generate clicks correctly (it's a little weird).

I've seen [this](https://askubuntu.com/a/1257454) that indicates that some of these
things work in Plasma on Wayland, but my workflow isn't ready for Wayland yet.

## What I want to do

I'd like to keep it simple, with as few non-default or custom pieces as possible. For
quick, one-and-done settings, shell scripts are fine, but anything running in the
background (services), I'd prefer Python.

## Solutions

### Touch gestures

I installed the latest [Touchégg](https://github.com/JoseExposito/touchegg) from the PPA, then the latest [Touché](https://github.com/JoseExposito/touche) from FlatHub to
go with it. This seems to solve the touch gesture support.
