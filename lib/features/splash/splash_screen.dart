import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});
  @override
  State<SplashScreen>createState()=> _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds:2),(){
      if(mounted)context.go('/login');
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Container(
        width:double.infinity,
        decoration:const BoxDecoration(
          gradient:LinearGradient(
            begin:Alignment.topLeft,
            end:Alignment.bottomRight,
            colors:[Color(0xFF1E3A8A), Color(0xFF0F766E)],
          ),
        ),
        child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Container(
              width:112,
              height:112,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius:BorderRadius.circular(32),
              ),
              child:const Icon(Icons.home_rounded,
              size:64,
              color:Color(0xFF1E3A8A)),
            ),
            const SizedBox(height:20),
            Text(
              'DarImmo',
              style:GoogleFonts.poppins(
                fontSize:40,
                fontWeight:FontWeight.w700,
                color:Colors.white,
              ),
              ),
              const SizedBox(height:8),
              const Text(
                'Votre prochain chez-vous commence ici',
                style:TextStyle(color:Color(0xFFE0F2FE),fontSize:16),
              ),
          ],
        ),
      ),
      );
  }
}