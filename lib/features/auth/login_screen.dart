import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService().login(_email.text.trim(), _password.text);
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(apiError(e))));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Header
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 72, 24, 0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.home_rounded,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 12),
                      Text('DarImmo',
                          style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      const Text(
                        'Achetez, louez et publiez vos biens immobiliers en toute simplicité.',
                        style: TextStyle(
                            color: Color(0xFFE0F2FE), fontSize: 16, height: 1.4),
                      ),
                    ],
                  ),
                ),
                // White card overlapping the header
                Padding(
                  padding:const EdgeInsets.only(top:260,left:16,right:16),
                  child:Container(
                    padding:const EdgeInsets.all(24),
                    decoration:BoxDecoration(
                      color:Colors.white,
                      borderRadius:BorderRadius.circular(24),
                      boxShadow:const[
                        BoxShadow(
                          color:Color(0x1A0F172A),
                          blurRadius:24,
                          offset:Offset(0,8)
                        ),
                      ],
                    ),
                    child:Form(
                      key:_formKey,
                      child:Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children:[
                          Text('Connexion client',
                            style:GoogleFonts.poppins(
                              fontSize:22,
                              fontWeight:FontWeight.w600
                            )),
                            const SizedBox(height:16),
                            TextFormField(
                              controller:_email,
                              keyboardType:TextInputType.emailAddress,
                              decoration:const InputDecoration(
                                labelText:'Email',
                                hintText:'nom@exemple.com'
                              ),
                              validator:(v){
                                final t=(v ?? '').trim();
                                if (!t.contains('@')|| !t.contains('.')){
                                  return 'Email invalide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height:16),
                            TextFormField(
                              controller:_password,
                              obscureText:_hide,
                              decoration:InputDecoration(
                                labelText:'Mot de passe',
                                suffixIcon:IconButton(
                                  icon:Icon
                                  (_hide ? Icons.visibility_off : Icons.visibility),
                                  onPressed:()=>
                                    setState(()=>_hide=!_hide),
                                ),
                              ),
                              validator:(v)=>(v ?? '').length<8?'8 caractères minimum':null,
                            ),
                            Align(
                              alignment:Alignment.centerRight,
                              child:TextButton(
                                onPressed:(){},// TODO :forget password
                                child:const Text('Mot de passe oublié ? '),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _loading?null:_submit,
                              child: _loading?const SizedBox(
                                height:20,
                                width:20,
                                child:CircularProgressIndicator(
                                  strokeWidth:2,color:Colors.white),
                                ):const Text ('Se connecter'),
                              ),
                              const SizedBox(height:16),
                              const Row(
                                children:[
                                  Expanded(child:Divider()),
                                  Padding(
                                    padding:EdgeInsets.symmetric(horizontal:12),
                                    child:Text('ou',
                                      style:TextStyle(color:AppColors.muted)
                                    ),
                                  ),
                                  Expanded(child: Divider()),
                                ]
                              ),
                              const SizedBox(height:16),
                              OutlinedButton(
                                style:OutlinedButton.styleFrom(
                                  minimumSize:const Size.fromHeight(52),
                                  shape:RoundedRectangleBorder(
                                    borderRadius:BorderRadius.circular(12)
                                  ),
                                side:const BorderSide(color:AppColors.border),
                                ),
                                onPressed:(){},//TODO Google login(optional)
                                child:const Text('Conntinuer avec Google'),
                              ),
                        ],
                      ),
                    ),
                  ),
    ),
    ],
        ),
    const SizedBox(height:12),
    Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children:[
        const Text('Pas encore de compte ?',
          style:TextStyle(color:AppColors.muted)
        ),
        TextButton(
          onPressed:(){},
          child:const Text('Créer un compte')
        ),
      ],
      ),
      Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children:[
          const Text('Administrateur ?',
            style:TextStyle(color:AppColors.muted)
          ),
          TextButton(
            onPressed:(){},
            child:const Text('Espace admin')
          ),
        ],
      ),
      const SizedBox (height:24),
      ],
    ),
  ),
  );
  }
  }
  