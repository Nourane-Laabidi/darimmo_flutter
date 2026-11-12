import '../../core/api_client.dart';
import '../../models/listing.dart';

class PropertyService{
  Future<List<Listing>>fetchAll({
    String?transactionType,
    String? type,
    String? city,
  })async{
    final res=await ApiClient.instance.dio.get(
      '/properties',
      queryParameters:{
        if(transactionType != null)'transactionType':transactionType,
        if(type!=null)'type':type,
        if(city!=null && city.isNotEmpty)'city':city,
      },
    );
    final list=(res.data['data']['properties']as List? ??[]);
    return list
    .map((e)=>Listing.fromJson(e as Map<String,dynamic>)).toList();
  }
  Future<Listing>fetchOne(String id)async{
    final res=await ApiClient.instance.dio.get('/properties/$id');
    final data=res.data['data'];
    final json=(data is Map && data['property'] != null)?data['property']:data;
    return Listing.fromJson(json as Map<String,dynamic>);
  }
}