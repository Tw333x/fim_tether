class EventEmitter {
  Map<String, List<Function>> _eventListeners = new Map();
  Map<String, List<Function>> _onceEventListeners = new Map();

  void _ensureEventNameIn(Map listeners, String name) {
    if (!listeners.containsKey(name)) {
      listeners[name] = new List();
    }
  }

  void on(String event, void handler(dynamic data)) {
    _ensureEventNameIn(_eventListeners, event);
    _eventListeners[event].add(handler);
  }

  void once(String event, void handler(dynamic data)) {
    _ensureEventNameIn(_onceEventListeners, event);
    _onceEventListeners[event].add(handler);
  }

  void off(String event, void handler(dynamic data)) {
    if (!_eventListeners.containsKey(event)) return;
    _eventListeners[event].remove(handler);
  }

  void offOnce(String event, void handler(dynamic data)) {
    if (!_onceEventListeners.containsKey(event)) return;
    _onceEventListeners[event].remove(handler);
  }

  void emit(String event, dynamic data) {
    emitAll(_eventListeners, event, data);
    emitAll(_onceEventListeners, event, data);
    _onceEventListeners.remove(event);
  }

  void emitAll(Map listeners, String event, dynamic data) {
    _ensureEventNameIn(_eventListeners, event);

    // Function type doesn't please the static type checker
    for (dynamic handler in _eventListeners[event]) {
      try {
        handler(data);
      } catch (err) {
        // do something?
      }
    }
  }
}
