import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Ekran szczegółów: pełna nazwa zadania, notatka, status
class TaskDetailView extends WatchUi.View {

    private var _task as Dictionary;

    function initialize(task as Dictionary) {
        View.initialize();
        _task = task;
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var maxW = (w * 0.66).toNumber();
        var bottom = (h * 0.68).toNumber();
        var y = (h * 0.16).toNumber();

        var title = _task[:title] as String;
        var note = _task[:note] as String;
        var done = TaskList.isDone(title);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Tytuł (do 3 linii)
        var tf = Graphics.FONT_SMALL;
        var th = dc.getFontHeight(tf);
        var tl = wrapText(dc, title, tf, maxW);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < tl.size() && i < 3; i++) {
            dc.drawText(cx, y, tf, tl[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += th;
        }
        y += th / 3;

        // Notatka (tyle linii, ile się zmieści)
        var nf = Graphics.FONT_XTINY;
        var nh = dc.getFontHeight(nf);
        var nl = wrapText(dc, note, nf, maxW);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        for (var j = 0; j < nl.size(); j++) {
            if (y + nh > bottom) {
                break;
            }
            var line = nl[j];
            if (y + 2 * nh > bottom && j < nl.size() - 1) {
                line = line + "...";
            }
            dc.drawText(cx, y, nf, line, Graphics.TEXT_JUSTIFY_CENTER);
            y += nh;
        }

        // Status
        dc.setColor(done ? Graphics.COLOR_GREEN : Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, (h * 0.70).toNumber(), Graphics.FONT_SMALL, TaskList.statusText(done), Graphics.TEXT_JUSTIFY_CENTER);

        // Podpowiedź
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, (h * 0.84).toNumber(), Graphics.FONT_XTINY,
            WatchUi.loadResource(Rez.Strings.Hint) as String, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Zawijanie tekstu po słowach
    private function wrapText(dc as Dc, text as String, font, maxW as Number) as Array<String> {
        var lines = [] as Array<String>;
        var words = splitWords(text);
        var cur = "";
        for (var i = 0; i < words.size(); i++) {
            var word = words[i];
            var test = (cur.length() == 0) ? word : (cur + " " + word);
            if (dc.getTextWidthInPixels(test, font) <= maxW) {
                cur = test;
            } else {
                if (cur.length() > 0) {
                    lines.add(cur);
                }
                cur = word;
            }
        }
        if (cur.length() > 0) {
            lines.add(cur);
        }
        return lines;
    }

    private function splitWords(text as String) as Array<String> {
        var out = [] as Array<String>;
        var len = text.length();
        var start = 0;
        for (var i = 0; i <= len; i++) {
            if (i == len || text.substring(i, i + 1).equals(" ")) {
                if (i > start) {
                    out.add(text.substring(start, i) as String);
                }
                start = i + 1;
            }
        }
        return out;
    }
}
