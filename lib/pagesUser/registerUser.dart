import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/models/user.dart';

final storage = new FlutterSecureStorage();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  bool _validate = false;
  String name, email, password, aviso;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(
            "Crie sua conta",
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              fontSize: 20.0,
              color: Color(0xFF20A37F),
              fontWeight: FontWeight.w500,
            )),
          ),
          backgroundColor: Color(0xFFF1F0F5),
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Color(0xFF20A37F))),
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
          padding: const EdgeInsets.only(left: 30.0, top: 90.0, right: 50.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Nome',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite o Nome';
              }
              return null;
            },
            onSaved: (String val) {
              name = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 50.0),
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
          padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 50.0),
          child: new TextFormField(
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
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 140.0, top: 20.0, bottom: 20.0),
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
      params["name"] = name;
      params["email"] = email;
      params["password"] = password;

      await getRegistration(params);
      var erroEmailRegistro = await storage.read(key: 'erroRegister');

      if (erroEmailRegistro == "Email already exists") {
        _avisoEmailExiste();
      }

      if (erroEmailRegistro == "Registration failed") {
        _avisoErroValidacao();
      }
      if (erroEmailRegistro == "Sem erro") {
        Navigator.pop(context);
        _key.currentState?.reset();
        _avisoSucessoValidacao();
      }
    }
  }

  _avisoEmailExiste() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro de validação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("O email informado já está cadastrado.")
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

  _avisoErroValidacao() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro de validação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Forneça um email válido.")],
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

  _avisoSucessoValidacao() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Cadastro concluído"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Usuário cadastrado com sucesso!\nEfetue o login.")
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
