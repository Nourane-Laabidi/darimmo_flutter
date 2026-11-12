import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main()=>runApp(const ProviderScope(child:DarImmoApp()));
class  DarImmoApp extends StatelessWidget{
  const DarImmoApp({super.key});
  @override
  Widget build(BuildContext){
    return MaterialApp.router(
      title:'DarImmo',
      theme:buildTheme(),
      routerConfig:router,
      debugShowCheckedModeBanner:false,
    );
  }
}
