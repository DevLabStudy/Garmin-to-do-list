import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

module TaskList {

    const MAX_TASKS = 10;

    // Czyta zadania (task1..task10) i ich notatki (note1..note10) z ustawień
    function readTasks() as Array<Dictionary> {
        var out = [] as Array<Dictionary>;
        for (var i = 1; i <= MAX_TASKS; i++) {
            var v = Application.Properties.getValue("task" + i);
            if (v != null && v instanceof String) {
                var title = v as String;
                if (title.length() > 0) {
                    var note = "";
                    var n = Application.Properties.getValue("note" + i);
                    if (n != null && n instanceof String) {
                        note = n as String;
                    }
                    out.add({ :title => title, :note => note });
                }
            }
        }
        return out;
    }

    function isDone(title as String) as Boolean {
        var v = Application.Storage.getValue("done_" + title);
        return (v != null && v == true);
    }

    function setDone(title as String, done as Boolean) as Void {
        Application.Storage.setValue("done_" + title, done);
    }

    function statusText(done as Boolean) as String {
        if (done) {
            return WatchUi.loadResource(Rez.Strings.Done) as String;
        }
        return WatchUi.loadResource(Rez.Strings.Todo) as String;
    }

    function buildMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({ :title => WatchUi.loadResource(Rez.Strings.AppName) as String });
        var tasks = readTasks();

        if (tasks.size() == 0) {
            menu.addItem(new WatchUi.MenuItem(
                WatchUi.loadResource(Rez.Strings.Empty) as String,
                WatchUi.loadResource(Rez.Strings.EmptyHint) as String,
                :empty,
                {}
            ));
            return menu;
        }

        for (var i = 0; i < tasks.size(); i++) {
            var t = tasks[i];
            var title = t[:title] as String;
            menu.addItem(new WatchUi.MenuItem(title, statusText(isDone(title)), t, {}));
        }

        menu.addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.ClearDone) as String,
            null,
            :clear,
            {}
        ));
        return menu;
    }

    function clearDone() as Void {
        var tasks = readTasks();
        for (var i = 0; i < tasks.size(); i++) {
            Application.Storage.deleteValue("done_" + (tasks[i][:title] as String));
        }
    }
}
