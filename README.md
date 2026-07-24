# Countdown (Garmin Connect IQ widget)

A tiny Garmin **watch** widget that shows how many days are left until the
things you're looking forward to. You enter your events and their dates from
the Garmin Connect phone app — the watch just displays the countdowns, with
the soonest event front and center.

> Note: this is a **watch** app. Garmin doesn't make phones — the "phone"
> part is only the Garmin Connect mobile app, which is where you type in your
> events. The countdown runs on the watch.

## What it does

- Up to **5 events**, each a name + a date (`YYYY-MM-DD`).
- Sorts by soonest first; shows the next one big, with a couple more listed below.
- `TODAY!` on the day, and passed events sink to the bottom.
- Edit events any time from **Garmin Connect → device → app settings** — no rebuild needed.

## Project layout

```
manifest.xml            device list + app metadata (type: widget)
monkey.jungle           build config
resources/
  drawables/            launcher icon
  strings/              display + settings strings
  settings/             properties.xml + settings.xml (phone-editable events)
source/
  CountdownApp.mc       app entry point
  CountdownEvent.mc     load/parse/sort events from settings
  CountdownView.mc      the widget screen
```

## One-time setup (SDK not yet installed)

1. **Create a free Garmin developer account** and sign in at
   <https://developer.garmin.com/connect-iq/>.
2. **Install the Connect IQ SDK Manager**
   (<https://developer.garmin.com/connect-iq/sdk/>), open it, and download the
   **latest SDK** plus at least one **device** (e.g. Venu 3, Forerunner 265).
3. **Install VS Code**, then the **Monkey C** extension (publisher: Garmin) from
   the Marketplace.
4. In VS Code run **Ctrl+Shift+P → "Monkey C: Verify Installation"** and point
   it at the SDK if prompted.
5. **Generate a developer key** (signs your app):
   `Ctrl+Shift+P → "Monkey C: Generate a Developer Key"`. Keep this file
   private — it's already git-ignored.

## Build & run in the simulator

1. Open this folder in VS Code.
2. `Ctrl+Shift+P → "Monkey C: Build for Device"` (or press **F5** to run).
3. Pick a device — the **Connect IQ Simulator** launches with the widget.
4. In the simulator, set test events via
   **File → Edit Persistent Storage / App Settings** (or **Settings** menu),
   using dates like `2026-12-25`.

## Put it on your own watch

1. Build a `.prg` (**"Monkey C: Build for Device"**).
2. Copy the `.prg` into the `GARMIN/APPS` folder on the watch (USB), **or**
   publish privately/publicly via the **Connect IQ Store** developer portal.
3. Set your real events from **Garmin Connect (phone) → your device → the
   Countdown app → Settings**.

## Adding more devices

Add `<iq:product id="..."/>` lines in `manifest.xml`. Device ids are listed in
the SDK's **Device Reference** (SDK Manager → Devices, or the developer docs).

## License

Personal project — do what you like with it.
