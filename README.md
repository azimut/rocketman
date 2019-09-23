# rocketman

TCP client for [rocket/rocket](https://github.com/rocket/rocket) or [emoon/rocket](https://github.com/emoon/rocket) sync-trackers.

Based on [Contraz/pyrocket](https://github.com/Contraz/pyrocket/)

## Usage

### Live

Launch `editor` or `RocketEditor`. Then connect to it from lisp and launch the update loop.

```lisp
ROCKETMAN > (connect *rocket*)
ROCKETMAN > (run-standalone)
```

You can now add a track from lisp and it will appear on the `editor`.

```
ROCKETMAN > (add-track *rocket* "sky:clouds")
```

Or alternatively load a xml file, exported from rocket.

```
ROCKETMAN > (load-file *rocket* "/home/user/projects/pyrocket/example.rocket")
```

The protocol ONLY allows filling new values on the `editor` from the `editor`, so you will need to load the file also from the editor.

Then unpause with space on the `editor` and query at any moment for the value of the row with:

```
ROCKETMAN > (get-track "sky:clouds")
3.2d0
```

Note: you will likely won't use `(run-standalone)` and use instead your own render loop calling `(update)` on it.

### Offline

You can replay a .rocket file by just loading a file into a rocketman:rocket object with `(load-file)` and proceed normally running `(update)` and `(get-track "sometrack:x)`.

## TODO
- Clean up events old events when (update) starts after stopped running for a while
- Clean up state instead of re-instantiate

## License

MIT

