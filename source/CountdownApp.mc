using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class CountdownApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new CountdownView() ];
    }

    // Fires when the user changes settings from the phone/desktop; redraw
    // so the new events/dates show without relaunching the widget.
    function onSettingsChanged() {
        Ui.requestUpdate();
    }
}
