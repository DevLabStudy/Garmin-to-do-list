import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TasksApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [TaskList.buildMenu(), new TaskMenuDelegate()];
    }

    // Wywoływane po zmianie zadań/notatek w ustawieniach w telefonie
    function onSettingsChanged() as Void {
        WatchUi.switchToView(TaskList.buildMenu(), new TaskMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
}
