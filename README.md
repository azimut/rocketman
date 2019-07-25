# rocketman

TCP client for [rocket/rocket](https://github.com/rocket/rocket).

Based on [Contraz/pyrocket](https://github.com/Contraz/pyrocket/)

## Usage

Launch `editor`. Then connect to it from lisp and launch the update loop.

```lisp
ROCKETMAN > (connect *rocket*)
ROCKETMAN > (run-standalone)
```

You can now add a track from lisp and it will appear on the `editor`.

```
ROCKETMAN > (add-track *rocket* "sky:clouds")
```

Or alternatively load a xml file, exported from rocket. (notice there is shared state to keep).

```
ROCKETMAN > (load-file *rocket* "/home/user/projects/pyrocket/example.xml")
```

The protocol ONLY allows filling new values on the `editor` from the `editor`. The update loop would get those new values into lisp.

Then unpause with space on the `editor` and query at any moment for the value of the row with:

```
ROCKETMAN > (get-track "sky:clouds")
3.2f0
```

Note: you will likely won't use (run-standalone) but use your own render loop calling `(update)` on it.

## Status

"it works?"

Pending support for [emoon/rocket](https://github.com/emoon/rocket).

## License

MIT

