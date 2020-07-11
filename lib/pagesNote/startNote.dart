import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/mainPage.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'package:task/service/noteService.dart';
import 'package:http_parser/http_parser.dart';

final storage = new FlutterSecureStorage();

class RegisterNote extends StatefulWidget {
  @override
  _RegisterNoteState createState() => _RegisterNoteState();
}

class _RegisterNoteState extends State<RegisterNote> {
  final _key = GlobalKey<FormState>();
  bool _validate = false;
  String initialDescription, aviso;
  DateTime inicioNote = DateTime.now();
  File imageFile;
  var conectado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0F5),
      appBar: new AppBar(
          title: Text(
            'Iniciar Tarefa',
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF28CC9E),
          iconTheme: new IconThemeData(color: Colors.white)),
      body: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Form(
          key: _key,
          autovalidate: _validate,
          child: SingleChildScrollView(child: _formUI()),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              title: Text('Start'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              title: Text('Logout'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.power_settings_new),
              title: Text('Fechar'),
            )
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.pop(context);
                break;
              case 2:
                storage.deleteAll();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                break;
              case 3:
                exit(0);
                break;
              default:
            }
          }),
    );
  }

  Widget _formUI() {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _mostrarEscolhaDialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Card(
              color: Colors.white,
              child: Container(
                decoration: new BoxDecoration(),
                width: 250.0,
                height: 190.0,
                child: imageFile == null
                    ? new Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Icon(Icons.camera_alt,
                              size: 100.0, color: Color(0xFF20A37F)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            'Toque para adicionar imagem',
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            )),
                          ),
                        )
                      ])
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Image.file(imageFile, fit: BoxFit.contain),
                      ),
              ),
            ),
          ),
        ),
        //),
        Container(
          width: 300.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70.0, bottom: 20.0),
                child: new TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: new InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Descrição do serviço',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor, digite a Descrição Inicial';
                    }
                    return null;
                  },
                  onSaved: (String val) {
                    initialDescription = val;
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _verificarConexao();
                        if (conectado == "false") {
                          _avisoErroConexao();
                        }
                        if (conectado == "true") {
                          _sendForm();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, right: 10.0, bottom: 30.0),
                        child: new Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: new BoxDecoration(
                                color: Color(0xFF20A37F),
                                borderRadius: new BorderRadius.circular(4.0)),
                            child: new Text("Enviar",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 30.0),
                        child: new Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: new BoxDecoration(
                                color: Color(0xFF20A37F),
                                borderRadius: new BorderRadius.circular(4.0)),
                            child: new Text("Cancelar",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _sendForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();

      if (imageFile == null) {
        _avisoErroImagem();
      } else {
        try {
          String filename = imageFile.path;

          FormData formData = new FormData.fromMap({
            "initialDescription": initialDescription,
            "initialImage": await MultipartFile.fromFile(imageFile.path,
                filename: filename, contentType: MediaType('image', 'png')),
            // "initialImage": new UploadFileInfo(imageFile, fileName),
            "startedAt": inicioNote
          });
          await addNote(formData);

          var envio = await storage.read(key: 'erroRegisterNote');
          if (envio == "Sem erro note") {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
            _avisoSucessoValidacao();
          } else if (envio == "Erro envio") {
            _avisoErroApi();
          }
        } catch (e) {
          Navigator.pop(context);
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Erro de validação"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text("$e")],
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
    }
  }

  _avisoErroImagem() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Falha na operação"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Selecione uma imagem para enviar")],
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
            title: Text("Tudo certo!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Envio efetuado com sucesso!")],
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

  _avisoErroConexao() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Falha no envio!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Verifique sua conexão!")],
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

  _avisoErroApi() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Falha no envio!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("Conexão com API recusada.")],
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

  _verificarConexao() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile)) {
      conectado = "false";
    } else {
      conectado = "true";
    }
    return conectado;
  }

  Future<void> _mostrarEscolhaDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Adicionar imagem:"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                    color: Color(0xFF18D191),
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
                                child: new Text("Camera",
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white))),
                            onTap: () {
                              _openCamera();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                    color: Color(0xFF18D191),
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
                                child: new Text("Galeria",
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white))),
                            onTap: () {
                              _openGallery();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _openGallery() async {
    final imagePicker = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: null,
        maxHeight: null,
        imageQuality: 10);
    setState(() {
      imageFile = File(imagePicker.path);
    });
    Navigator.pop(context);
  }

  _openCamera() async {
    final imagePicker = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: null,
        maxHeight: null,
        imageQuality: 10);
    setState(() {
      imageFile = File(imagePicker.path);
    });
    Navigator.pop(context);
  }
}
