# Elm Scroll Resize Events

## [Demo with Time-traveling Debugger](https://lucamug.github.io/elm-scroll-resize-events/)

# How it works

Check out [the full writeup](https://medium.com/@l.mugnaini/scroll-and-resize-events-in-elm-ac4f0589f42)!

# Getting started

If you don't already have `elm` and `elm-live`:

> npm install -g elm elm-live

Then, to build everything:

> elm-live --output=step01.js src/Step01.elm --open --debug
> elm-live --output=step02.js src/Step02.elm --open --debug
> elm-live --output=step03.js src/Step03.elm --open --debug
> elm-live --output=step04.js src/Step04.elm --open --debug

(Leave off the `--debug` if you don't want the time-traveling debugger.)

Native code:

https://github.com/elm-lang/dom/blob/master/src/Native/Dom.js#L88

Dom-scroll:

http://package.elm-lang.org/packages/elm-lang/dom/1.1.1/Dom-Scroll
