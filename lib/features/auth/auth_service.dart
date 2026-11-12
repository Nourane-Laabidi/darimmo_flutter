import '../../core/api_client.dart';

class AuthUser{
  final String id;
  final String name;
  final String email;
  final String role; // 'user 'or 'admin 'or 'agent'
  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
  factory AuthUser.fromJson(Map<String,dynamic>j)=>AuthUser(
    id:j['id'] as String,
    name:j['name'] as String,
    email:j['email'] as String,
    role:j['role'] as String,
  );
}
class AuthService{
  final _api=ApiClient.instance;
  Future<AuthUser>login(String email,String password)async{
    final res=await _api.dio.post('/auth/login',data:{'email':email,'password':password});
    final data=res.data['data'];
    await _api.saveToken(data['token'] as String);
    return AuthUser.fromJson(data['user'] as Map<String,dynamic>);
  }
  Future<AuthUser> register(
    String name,String email,String password,String phone)async{
      final res=await _api.dio.post('/auth/register',data:{
        'name':name,
        'email':email,
        'password':password,
        if(phone.isNotEmpty)'phone':phone,
      });
      final data=res.data['data'];
      await _api.saveToken(data['token'] as String);
      return AuthUser.fromJson(data['user']as Map<String,dynamic>);
    }
    Future<void>logout()=>_api.clearToken();

}
