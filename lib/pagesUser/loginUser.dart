import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task/models/user.dart';
import 'package:task/pagesUser/forgotPasswordUser.dart';
import 'package:task/pagesUser/registerUser.dart';
import '../mainPage.dart';
import 'package:google_fonts/google_fonts.dart';

final storage = new FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  bool _validate = false;
  String email, password, aviso;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFFF1F0F5),
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFF1F0F5)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Form(
          key: _key,
          autovalidate: _validate,
          child: SingleChildScrollView(child: _formUI()),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit.fill,
            width: 200.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: Text(
              'Controle as etapas' +
                  '\n' 'e a duração de' +
                  '\n' 'suas tarefas',
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(fontSize: 32.0),
                fontWeight: FontWeight.w500,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5.0),
          child: Text(
            'Gerencie facilmente a execução' + '\n' 'de suas atividades',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 70.0, right: 60.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite o Email';
              }
              return null;
            },
            onSaved: (String val) {
              email = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 60.0),
          child: new TextFormField(
            obscureText: true,
            decoration: new InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite a Senha';
              }
              return null;
            },
            onSaved: (String val) {
              password = val;
            },
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 5.0, top: 15.0),
                child: GestureDetector(
                  onTap: () {
                    _sendForm();
                  },
                  child: new Container(
                      alignment: Alignment.center,
                      height: 55.0,
                      decoration: new BoxDecoration(
                          color: Color(0xFF20A37F),
                          borderRadius: new BorderRadius.circular(4.0)),
                      child: new Text("Login",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white))),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 20.0),
              child: Container(
                alignment: Alignment.center,
                height: 60.0,
                child: InkWell(
                  child: new Text("Esqueceu a Senha?",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFFF44336),
                        fontStyle: FontStyle.italic,
                      ))),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPage()));
                  },
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 65.0),
              child: InkWell(
                child: new Text(
                  "Criar Uma Nova Conta",
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700)),
                ),
                onTap: () {
                  storage.deleteAll();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  _sendForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();

      Map<String, dynamic> params = Map<String, dynamic>();
      params["email"] = email;
      params["password"] = password;

      await getAuthentication(params);

      var token = await storage.read(key: 'jwt');

      if (token != null) {
        saveData();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        _key.currentState?.reset();
      } else {
        _avisoErroLogin();
      }
    }
  }

  Future saveData() async {
    await storage.write(key: 'nameKey', value: 'true');
  }

  _avisoErroLogin() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro de validação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Os dados informados estão incorretos")
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Fechar'),
                onPressed: () async {
                  Navigator.pop(context); //Quit Dialog
                },
              ),
            ],
          );
        });
  }
}
