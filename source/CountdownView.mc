using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class CountdownView extends Ui.View {

    hidden const ACCENT = 0x1E90FF; // matches the launcher icon blue

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var events = Events.load();
        var width = dc.getWidth();
        var centerX = width / 2;
        var height = dc.getHeight();

        if (events.size() == 0) {
            drawEmpty(dc, centerX, height / 2);
            return;
        }

        drawFeatured(dc, events[0], centerX, height);
        drawUpcomingList(dc, events, centerX, height);
    }

    // The soonest event, front and center: big day count + phrase + name.
    hidden function drawFeatured(dc, event, centerX, height) {
        var numberY = (height * 0.30).toNumber();
        var phraseY = (height * 0.52).toNumber();
        var nameY   = (height * 0.13).toNumber();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, nameY, Gfx.FONT_SMALL, event.name,
            Gfx.TEXT_JUSTIFY_CENTER);

        var days = event.daysLeft;
        var bigText;
        var phrase;
        if (days == 0) {
            bigText = "★"; // star
            phrase = Ui.loadResource(Rez.Strings.Today);
        } else if (days > 0) {
            bigText = days.toString();
            phrase = Ui.loadResource(
                days == 1 ? Rez.Strings.DayOne : Rez.Strings.DayMany);
        } else {
            bigText = (-days).toString();
            phrase = Ui.loadResource(Rez.Strings.DayMany) + " "
                + Ui.loadResource(Rez.Strings.Passed);
        }

        dc.setColor(ACCENT, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, numberY, Gfx.FONT_NUMBER_HOT, bigText,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, phraseY, Gfx.FONT_TINY, phrase,
            Gfx.TEXT_JUSTIFY_CENTER);
    }

    // A couple of the next events listed small near the bottom.
    hidden function drawUpcomingList(dc, events, centerX, height) {
        var lineY = (height * 0.68).toNumber();
        var step = Gfx.getFontHeight(Gfx.FONT_XTINY) + 2;
        var shown = 0;

        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        for (var i = 1; i < events.size() && shown < 2; i += 1) {
            var e = events[i];
            var suffix = e.daysLeft == 0
                ? Ui.loadResource(Rez.Strings.Today)
                : e.daysLeft.toString() + "d";
            dc.drawText(centerX, lineY + (shown * step), Gfx.FONT_XTINY,
                e.name + "  " + suffix, Gfx.TEXT_JUSTIFY_CENTER);
            shown += 1;
        }
    }

    hidden function drawEmpty(dc, centerX, centerY) {
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY, Gfx.FONT_SMALL,
            Ui.loadResource(Rez.Strings.NoEvents),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }
}
