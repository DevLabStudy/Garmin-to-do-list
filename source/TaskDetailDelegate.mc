import Toybox.Lang;
import Toybox.WatchUi;

class TaskDetailDelegate extends WatchUi.BehaviorDelegate {

    private var _task as Dictionary;
    private var _item as WatchUi.MenuItem;

    function initialize(task as Dictionary, item as WatchUi.MenuItem) {
        BehaviorDelegate.initialize();
        _task = task;
        _item = item;
    }

    // Stuknięcie (dotyk) lub przycisk Select przełącza stan zadania
    function onSelect() as Boolean {
        var title = _task[:title] as String;
        var done = !TaskList.isDone(title);
        TaskList.setDone(title, done);
        _item.setSubLabel(TaskList.statusText(done));
        WatchUi.requestUpdate();
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}
