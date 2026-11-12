import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/widgets/listing_card.dart';
import '../../models/listing.dart';
import 'property_service.dart';
import '../../core/api_client.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PropertyService();
  final _search = TextEditingController();
  String _mode = 'sale';
  late Future<List<Listing>> _future;
  @override
  void initState(){
    super.initState();
    _load();
  }
  void _load(){
    _future=_service.fetchAll(transactionType:_mode);
  }
  @override
  void dispose(){
    _search.dispose();
    super.dispose();
  }
  Widget _chip(String label,String value){
    final selected=_mode==value;
    return GestureDetector(
      onTap:()=>setState((){
        _mode=value;
        _load();
      }),
      child:Container(
        padding:const EdgeInsets.symmetric(horizontal:20,vertical:10),
        margin:const EdgeInsets.only(right:8),
        decoration:BoxDecoration(
          color:selected?AppColors.primary:Colors.white,
          borderRadius:BorderRadius.circular(30),
          border:Border.all(
            color:selected? AppColors.primary:AppColors.border
          ),
          ),
          child: Text(
            label, 
            style:TextStyle(
              fontWeight:FontWeight.w600,
              color:selected? Colors.white:AppColors.text
            ),
        ),
      ),
    );
  }
Widget _title(String t)=>Padding(
  padding:const EdgeInsets.fromLTRB(20,24,20,12),

  child:Text(t,
    style:GoogleFonts.poppins(
      fontSize:20,fontWeight:FontWeight.w600
    )  
  ),
);
@override
Widget build (BuildContext context){
  return Scaffold(
    backgroundColor:AppColors.bg,
    floatingActionButton:FloatingActionButton(
      backgroundColor:AppColors.primary,
      foregroundColor:Colors.white,
      onPressed:(){},
      child:const Icon(Icons.add),
    ),
    bottomNavigationBar:NavigationBar(
      selectedIndex:0,
      onDestinationSelected:(_){},
      destinations:const[
        NavigationDestination(icon:Icon(Icons.home_outlined),label:'Accueil'),
        NavigationDestination(icon:Icon(Icons.map_outlined),label:'Carte'),
        NavigationDestination(icon:Icon(Icons.chat_bubble_outlined),label:'Message'),
        NavigationDestination(icon:Icon(Icons.person_outline),label:'Profil'),
      ],
    ),
    body:SafeArea(
      child:RefreshIndicator(
        onRefresh:()async{
          setState(_load);
          await _future;
        },
        child:ListView(
          children:[
            Padding(
              padding:const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      const Text('Tunis,Tunisie',
                      style:TextStyle(color:AppColors.muted)
                      ),
                      const SizedBox(height:4),
                      Text('Trouvez votre\nchez-vous',
                      style:GoogleFonts.poppins(
                        fontSize:28,
                        fontWeight:FontWeight.w700,
                        height:1.15
                      )
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor:Colors.white,
                    child:const Icon(Icons.notifications_none,
                    color:AppColors.text),
                  ),
                ],
              ),
            ),
            Padding(
              padding:const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:TextField(
                controller:_search,
                decoration:const InputDecoration(
                  hintText:'Ville,quartier,adresse',
                  prefixIcon:Icon(Icons.search),
                ),
                onSubmitted: (_) => context.push(
    '/results?mode=$_mode&q=${Uri.encodeComponent(_search.text.trim())}'),
              ),
            ),
            Padding(
              padding:const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child:Row(
                children: [
                  _chip('Acheter','sale'),
                  _chip('Louer','rent'),
                ]
                ),
            ),
            FutureBuilder<List<Listing>>(
              future:_future,
              builder:(context,snap){
                if(snap.connectionState!=ConnectionState.done){
                  return const Padding(
                    padding:EdgeInsets.all(60),
                    child:Center(child:CircularProgressIndicator()),
                  );
                }
                if(snap.hasError){
                  return Padding(
                    padding:const EdgeInsets.all(40),
                    child:Column(
                      children:[
                        Text(apiError(snap.error!),
                        textAlign:TextAlign.center
                        ),
                        const SizedBox(height:12),
                        OutlinedButton(
                          onPressed:()=>setState(_load),
                          child:const Text('Réessayer'),
                        ),
                      ]
                    ),
                  );
                }
                final items=snap.data??[];
                if (items.isEmpty){
                  return const Padding(
                    padding:EdgeInsets.all(60),
                    child:Center(child:Text('Aucune annonce pour le moment')),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    _title('Près de vous'),
                    SizedBox(
                      height:280,
                      child:ListView.separated(
                        scrollDirection:Axis.horizontal,
                        padding:const EdgeInsets.symmetric(horizontal:20),
                        itemCount:items.length,
                        separatorBuilder:(_,__)=>const SizedBox(width:12),
                        itemBuilder:(_,i)=>ListingCard(
                          listing:items[i],
                          onTap:(){},
                        ),
                      ),
                    ),
                    _title('Récemment ajoutés'),
                    Padding(
                      padding:const EdgeInsets.symmetric(horizontal:20),
                      child:Column(
                        children:[
                          for(final l in items)...[
                            ListingRow(listing:l,onTap:(){}),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height:80),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}