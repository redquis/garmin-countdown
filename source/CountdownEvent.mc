using Toybox.Application as App;
using Toybox.Time;
using Toybox.Time.Gregorian;

// A single "thing I'm looking forward to": a label plus the whole-days count
// until its date. daysLeft is negative once the date has passed, 0 on the day.
class CountdownEvent {
    var name;
    var daysLeft;

    function initialize(eventName, days) {
        name = eventName;
        daysLeft = days;
    }
}

module Events {

    const MAX_EVENTS = 5;
    const SECONDS_PER_DAY = 86400;

    // Reads the configured events from app settings and returns them sorted
    // with the soonest upcoming event first. Blank/invalid rows are skipped.
    function load() {
        var result = [];
        for (var i = 1; i <= MAX_EVENTS; i += 1) {
            var name = App.Properties.getValue("event" + i + "Name");
            var date = App.Properties.getValue("event" + i + "Date");

            if (name == null || name.toString().length() == 0) {
                continue;
            }
            var days = daysUntil(date);
            if (days == null) {
                continue;
            }
            result.add(new CountdownEvent(name.toString(), days));
        }
        return sortByDaysLeft(result);
    }

    // Whole days from local midnight-today to the event date. null if the
    // string is not a valid YYYY-MM-DD date.
    function daysUntil(dateStr) {
        var parts = parseDate(dateStr);
        if (parts == null) {
            return null;
        }

        var eventMoment = Gregorian.moment({
            :year   => parts[0],
            :month  => parts[1],
            :day    => parts[2],
            :hour   => 0,
            :minute => 0,
            :second => 0
        });

        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var todayMoment = Gregorian.moment({
            :year   => now.year,
            :month  => now.month,
            :day    => now.day,
            :hour   => 0,
            :minute => 0,
            :second => 0
        });

        var diffSeconds = eventMoment.subtract(todayMoment).value();
        // Truncate toward zero so a moment later today still reads as 0 days.
        return diffSeconds / SECONDS_PER_DAY;
    }

    // Parses "YYYY-MM-DD" into [year, month, day]. Returns null on anything
    // that isn't three numeric fields with sane ranges.
    function parseDate(dateStr) {
        if (dateStr == null) {
            return null;
        }
        var s = dateStr.toString();
        if (s.length() < 10) {
            return null;
        }

        var year  = s.substring(0, 4).toNumber();
        var month = s.substring(5, 7).toNumber();
        var day   = s.substring(8, 10).toNumber();

        if (year == null || month == null || day == null) {
            return null;
        }
        if (month < 1 || month > 12 || day < 1 || day > 31) {
            return null;
        }
        return [year, month, day];
    }

    // Simple insertion sort (event count is tiny). Upcoming events come first
    // in ascending order; already-passed events sink to the bottom.
    function sortByDaysLeft(events) {
        for (var i = 1; i < events.size(); i += 1) {
            var current = events[i];
            var j = i - 1;
            while (j >= 0 && rank(events[j].daysLeft) > rank(current.daysLeft)) {
                events[j + 1] = events[j];
                j -= 1;
            }
            events[j + 1] = current;
        }
        return events;
    }

    // Upcoming (>= 0) sort naturally; passed (< 0) get pushed past everything
    // upcoming, with the most-recently-passed first.
    function rank(daysLeft) {
        if (daysLeft >= 0) {
            return daysLeft;
        }
        return 1000000 - daysLeft;
    }
}
