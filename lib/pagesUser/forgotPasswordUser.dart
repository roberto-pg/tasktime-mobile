import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/models/user.dart';
import 'package:task/pagesUser/resetPasswordUser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _key = GlobalKey<FormState>();
  bool _validate = false;
  String email, password, aviso;
  var nameKey;
  var status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(
            "Esqueci minha senha",
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
        //Para adicionar a cor do App Web:
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
          padding: const EdgeInsets.only(left: 25.0, top: 50.0),
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit.fill,
            width: 200.0,
          ),
          // child: new LogoImage(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 160.0),
          child: Text(
            "Informe o email usado no login:",
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
          padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 60.0),
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
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 140.0, top: 20.0, bottom: 20.0),
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
                        // style: new TextStyle(
                        //     fontSize: 20.0, color: Colors.white)
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
      params["email"] = email;

      await getTokenPassword(params);
      var erroEmail = await storage.read(key: 'erroUser');

      if (erroEmail == "User not found") {
        _avisoErroValidacao();
      }
      if (erroEmail == "Sem erro") {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ResetPasswordPage()));
        _key.currentState?.reset();
        _avisoCodigoPassword();
      }
    }
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

  _avisoCodigoPassword() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Redefinição de senha"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      "Para redefinir a senha copie o código enviado para seu email")
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Fechar'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
