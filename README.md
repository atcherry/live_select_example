# live_select_example

This repo demonstrates an issue with live_select's selection_recover event.
All the necessary code is provided under `./lib/phx_playground_web/live/home`.
The example is contrived, but is meant to replicate a similar setup in a repository
with this issue.

Setup the repo with `mix setup`

## Steps to reproduce the issue

 * Run the server with `mix phx.server`
 * Select a dealer:

 ![dealer](./docs/assets/dealer-select.png)

 * Select a car and do not submit the form:

 ![car](./docs/assets/car-select.png)

 * Abort phx.server:

 ![abort](./docs/assets/abort.png)

 * Run `mix phx.server` to see the console spam that the parent LiveView has no
   function that handles event `selection_recovery`

## Steps to reproduce the fix

 * Modify the `reconnected()` callback in `./deps/live_select/priv/static/live_select.min.js` by changing `this.pushEventTo(...)`:

```javascript
// Before
reconnected() { this.selection && this.selection.length > 0 && this.pushEventTo(this.el, "selection_recovery", this.selection) }
// After                                                                       change --↴
reconnected() { this.selection && this.selection.length > 0 && this.pushEventTo(this.el.id, "selection_recovery", this.selection) }

```
 > before

 ![before](./docs/assets/before.png)

 > after: call `this.el.id` instead of `this.el`

```javascript
```

 ![after](./docs/assets/after.png)

 * Run `mix deps.compile`
 * Perform the same steps to reproduce the issue.
 * submit the form to see that the selection was conserved.
