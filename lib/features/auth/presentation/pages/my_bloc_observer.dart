import 'package:flutter_bloc/flutter_bloc.dart';

class MyBLocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print("==========================bloc=================================");
    print(bloc);
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print("==========================Change=================================");
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print("==========================Event=================================");
    print(event);
    super.onEvent(bloc, event);
  }
}
