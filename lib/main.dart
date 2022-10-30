import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';

import 'constans/text.dart';
import 'screens/center.dart';
import 'test/bloc/app_blocs.dart';
import 'test/bloc/app_states.dart';
import 'test/productrepo.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            backgroundColor: Colors.white,
            primarySwatch: Colors.deepOrange,
          ),
          home: RepositoryProvider(
            create: (context) => ProductRepository(),
            child: const Home(),
          ),
        ));
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    return BlocProvider(
            create: (context) => ProductBloc(
                productRepository:
                    RepositoryProvider.of<ProductRepository>(context)),
            child:
                //     BlocListener<ProductBloc, ProductState>(listener: (context, state) {
                //   if (state is ProductAdded) {
                //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //       content: Text("Product added"),
                //       duration: Duration(seconds: 2),
                //     ));
                //   }
                // },
                //  child:
                //     BlocBuilder<ProductBloc, ProductState>(
                //   builder: (context, state) {
                //     if (state is ProductAdding) {
                //       return const AlertDialog(
                //         content: SizedBox(
                //           height: 100,
                //           width: 100,
                //           child: Center(
                //             child: CircularProgressIndicator(),
                //           ),
                //         ),
                //       );
                //     } else if (state is ProductError) {
                //       return const Center(child: Text("Error"));
                //     }
                //     return const MyHomePage();
                //   },
                // )
                MyHomePage())
        // )
        ;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else if (snapshot.hasData) {
            return Centerscreen(
              uid: snapshot.data!.uid,
            );
          } else {
            return const Loginwidget();
          }
        },
      ),
    );
  }
}

class Loginwidget extends StatefulWidget {
  const Loginwidget({Key? key}) : super(key: key);

  @override
  State<Loginwidget> createState() => _LoginwidgetState();
}

class _LoginwidgetState extends State<Loginwidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 140,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/IMG_2842.JPG',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                cursorColor: Colors.red,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    label: TextBwidget(name: ' อีเมล ', size: 14)),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    label: TextBwidget(name: ' รหัสผ่าน ', size: 14)),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await signIn();
                },
                child: Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.deepOrange,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          " เข้าสู่ระบบ ",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(' ไม่มีบัญชีผู้ใช้ ? : '),
                  GestureDetector(
                    child: const TextBcolorwidget(
                        name: ' สมัครบัญชี ',
                        size: 14,
                        color: Colors.deepOrange),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const Signupwidget())));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future logout() async {
    // await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

class Signupwidget extends StatefulWidget {
  const Signupwidget({Key? key}) : super(key: key);

  @override
  State<Signupwidget> createState() => _SignupwidgetState();
}

class _SignupwidgetState extends State<Signupwidget> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure2 = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: const TextBcolorwidget(
                name: ' สร้างบัญชี ', size: 16, color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            'assets/IMG_2842.JPG',
                            height: 90,
                            width: 90,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              labelStyle:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              labelText: ' อีเมล ',
                              border: InputBorder.none,
                            ),
                            onSaved: (valueEmail) {
                              emailController.text = valueEmail.toString();
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ' กรุณากรอกอีเมล ';
                              } else if (value.isNotEmpty) {
                                if (value.contains('@') &&
                                    value.endsWith('.com')) {
                                  return null;
                                }
                                return ' อีเมลต้องมีเครื่องหมาย @ และ .com ';
                              }
                              return null;
                            }
                            //  validateEmail,
                            ),
                        const Divider(
                          height: 2,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            labelText: ' รหัสผ่าน ',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                          ),
                          onSaved: (valuePassword) {
                            passwordController.text = valuePassword.toString();
                          },
                          validator: RequiredValidator(errorText: "กรุณากรอก"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        TextFormField(
                          controller: confirmpasswordController,
                          obscureText: _isObscure2,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            labelStyle: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            labelText: ' ยืนยันรหัสผ่าน ',
                            border: InputBorder.none,
                          ),
                          onSaved: (valueconfirmPassword) {
                            confirmpasswordController.text =
                                valueconfirmPassword.toString();
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return ' กรุณากรอกยืนยันรหัสผ่าน ';
                            } else if (val.toString() ==
                                passwordController.text) {
                              return null;
                            } else {
                              return ' รหัสผ่านไม่ตรงกัน ';
                            }
                          },
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                            ),
                            const TextSwidget(
                                name:
                                    ' ฉันยอมรับเงื่อนไขและข้อตกลงเกี่ยวกับการใช้งาน ',
                                size: 12),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isChecked == true) {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                                  formKey.currentState!.reset();
                                  navigatorKey.currentState!
                                      .popUntil((route) => route.isFirst);
                                } on FirebaseAuthException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: TextBwhitewidget(
                                              name: e.message.toString(),
                                              size: 16)));
                                  // ignore: avoid_print
                                  print(e);
                                }
                              }
                            } else {}
                          },
                          child: Container(
                            width: 150,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: isChecked
                                    ? Colors.deepOrange
                                    : const Color.fromARGB(161, 168, 168, 168),
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    " ยืนยัน ",
                                    style: TextStyle(
                                      color: isChecked
                                          ? Colors.deepOrange
                                          : const Color.fromARGB(
                                              161, 168, 168, 168),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}
