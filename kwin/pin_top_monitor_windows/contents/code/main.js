const primaryScreen = workspace.activeScreen;

function update(window) {
    window.onAllDesktops = window.output !== primaryScreen;
}

function setup(window) {
    if (!window.normalWindow) return;
    update(window);
    window.outputChanged.connect(() => update(window));
}

workspace.windowAdded.connect(setup);
workspace.windowList().forEach(setup);

/*
  // Top monitor size
  var TOP_MONITOR_WIDTH = 3840;
  var TOP_MONITOR_HEIGHT = 1200;

  function find_top_monitor_id_by_size() {
    for (var i=0; i<workspace.numScreens; ++i) {
      var geom = workspace.screenGeometry(i);
      if (geom.width === TOP_MONITOR_WIDTH && geom.height === TOP_MONITOR_HEIGHT) {
        return i;
      }
    }
    return -1;
  }

  var top_monitor_id = find_top_monitor_id_by_size();

  workspace.windowAdded.connect(function(client) {
    setTimeout(function() {
      if (top_monitor_id === -1) {
        return;
      }
      var window_screen = workspace.screenNumber(client.geometry.center());
      if (window_screen === top_monitor_id) {
        client.onAllDesktops = true;
      }
    }, 100);
});
*/
