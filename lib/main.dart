import 'dart:developer' as developer show log;

import 'package:bloc/bloc.dart';
import 'package:bloc_todo_app/views/pages/homepage/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  Bloc.observer = PostBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class PostBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    'Bloc:$bloc'.log();
    super.onTransition(bloc, transition);
  }

  @override
  void onCreate(BlocBase bloc) {
    'Post bloc created'.log();
    super.onCreate(bloc);
  }
}

extension Log on Object {
  void log() => developer.log(toString());
}
