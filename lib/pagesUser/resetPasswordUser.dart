import 'package:flutter/material.dart';
import 'package:task/models/user.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

final storage = new FlutterSecureStorage();

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _key = GlobalKey<FormState>();
  bool _validate = false;
  String email, token, password, aviso;
  var nameKey;
  var status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          "Escolha uma nova senha",
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
            fontSize: 20.0,
            color: Color(0xFF20A37F),
            fontWeight: FontWeight.w500,
          )),
        ),
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
          padding: const EdgeInsets.only(left: 25.0, top: 40.0),
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit.fill,
            width: 200.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 80.0, right: 50.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, insira o Email';
              }
              return null;
            },
            onSaved: (String val) {
              email = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 50.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Código recebido',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, insira o Código';
              }
              return null;
            },
            onSaved: (String val) {
              token = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 50.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Nova senha',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Insira uma nova senha para sua conta';
              }
              return null;
            },
            onSaved: (String val) {
              password = val;
            },
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 15.0, top: 20.0, bottom: 30.0),
              child: GestureDetector(
                onTap: () {
                  _sendForm();
                },
                child: new Container(
                    alignment: Alignment.center,
                    width: 125.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        color: Color(0xFF20A37F),
                        borderRadius: new BorderRadius.circular(4.0)),
                    child: new Text(
                      "Enviar",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 25.0, top: 20.0, bottom: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: new Container(
                    alignment: Alignment.center,
                    width: 125.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        color: Color(0xFF20A37F),
                        borderRadius: new BorderRadius.circular(4.0)),
                    child: new Text(
                      "Cancelar",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                    )),
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
      params["token"] = token;
      params["password"] = password;

      await getResetPassword(params);
      var reset = await storage.read(key: 'erroReset');

      if (reset == "User not found") {
        _avisoUserNotFound();
      }
      if (reset == "Token invalid") {
        _avisoTokenInvalido();
      }
      if (reset == "Sem erro") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        _key.currentState?.reset();
      }
    }
  }

  _avisoUserNotFound() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro de validação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Usuário não cadastrado")],
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

  _avisoTokenInvalido() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro de validação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Token inválido")],
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
