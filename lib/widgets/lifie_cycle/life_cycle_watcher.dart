//@dart=2.9
import 'package:flutter/widgets.dart';

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
