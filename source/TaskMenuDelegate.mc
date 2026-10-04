import Toybox.Lang;
import Toybox.WatchUi;

class TaskMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();

        if (id == :clear) {
            TaskList.clearDone();
            WatchUi.switchToView(TaskList.buildMenu(), new TaskMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
            return;
        }
        if (id == :empty) {
            return;
        }

        // Stuknięcie zadania otwiera ekran szczegółów
        var task = id as Dictionary;
        WatchUi.pushView(
            new TaskDetailView(task),
            new TaskDetailDelegate(task, item),
            WatchUi.SLIDE_LEFT
        );
    }
}
