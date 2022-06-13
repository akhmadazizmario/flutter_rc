import 'package:flutter/material.dart';
import 'package:rocket_chicken/bloc/login_bloc.dart';
import 'package:rocket_chicken/helpers/user_info.dart';
import 'package:rocket_chicken/ui/produk_page.dart';
import 'package:rocket_chicken/ui/registrasi_page.dart';
import 'package:rocket_chicken/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/3.jfif'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: (value) {
        //validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );

    final password = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          LoginBloc.login(
                  email: _emailTextboxController.text,
                  password: _passwordTextboxController.text)
              .then((value) async {
            await UserInfo().setToken(value.token.toString());
            await UserInfo().setUserID(int.parse(value.code.toString()));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProdukPage()));
          }, onError: (error) {
            print(error);
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => const WarningDialog(
                      description: "Login gagal, silahkan coba lagi",
                    ));
          });
          setState(() {
            _isLoading = false;
          });
        },
        padding: EdgeInsets.all(12),
        color: Color.fromARGB(255, 207, 15, 9),
        child: Text('Masuk', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Daftar Akun?',
        style: TextStyle(color: Color.fromARGB(134, 15, 4, 213)),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()));
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
