import 'package:flutter/material.dart';
import 'package:test_manabie/home/home.dart';

const int STATE_INIT = 0;
const int STATE_LOADING = 1;
const int STATE_SUCCESS = 2;

void main() => runApp(MyApp());


abstract class BlocBase {
  ///clear and close all resource please. Make sure we closed all stream after this method
  void dispose();
}
class BlocProvider<T extends BlocBase> extends InheritedWidget {
  final T bloc;

  BlocProvider({Key key, @required T bloc, Widget child})
      : this.bloc = bloc,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Type _typeOf<T>() => T;

  static T of<T extends BlocBase>(BuildContext context) {
    var type = _typeOf<BlocProvider<T>>();
    return (context.inheritFromWidgetOfExactType(type) as BlocProvider<T>).bloc;
  }
}
