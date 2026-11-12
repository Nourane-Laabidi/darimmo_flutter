/*import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import '../../models/listing.dart';
import '../home/property_service.dart';

class DetailScreen extends StatefulWidget{
  final String id;
  const DetailScreen({super.key,required this.id});
  @override 
  State<DetailScreen>createState()=>_DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen>{
  late Future<Listing>_future;
  @override
  void initState();
  _future=PropertyService().fetchOne(widget.id);
}
Widget _stat(IconData icon,String value,String label)=>Expanded(
  child:Container(
    padding:const EdgeInsets.symmetric(vertical:12),
    decoration:BoxDecoration(
      color:Colors.white,
      borderRadius:BorderRadius.circular(12),
      border:Border.all(color:AppColors.border),
    ),
    child:Column(
      children:[
        Icon (icon,color:AppColors.primary),
        const SizedBox(height:4),
        Text(value,style:const TextStyle(fontWeight:FontWeight.w700)),
        Text(label,style:const TextStyle(fontSize:12,color:AppColors.muted)),
      ]
    ),
  ),
);
Widget _header (Listing l){
  final placeholder=Container(
    height:300,
    decoration:const BoxDecoration(
      gradient:LinearGradient(
        begin:Alignment.topLeft,
        end:Alignment.bottomRight,
        colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
      ),
    ),
    child : const Center(
      child:Icon(Icons.home_work_outlined,size:64,color:Colors.white70)
    ),
  );
  if(l.images.isEmpty)return placeholder;
  return SizedBox(child: height:300,
}*/