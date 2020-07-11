import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task/models/note.dart';
import 'package:task/pagesNote/initialImage.dart';
import 'package:task/pagesNote/listNote.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'package:task/service/noteService.dart';
import 'package:task/pagesNote/finalImage.dart';

final storage = new FlutterSecureStorage();

class DetailNote extends StatefulWidget {
  final String selectedId;
  DetailNote(this.selectedId) : super();

  @override
  _DetailNoteState createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  var name;

  @override
  void initState() {
    super.initState();
    loadName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0F5),
      appBar: new AppBar(
          title: Text(
            'Detalhe da Tarefa',
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF28CC9E),
          iconTheme: new IconThemeData(color: Colors.white)),
      body: FutureBuilder(
          future: getNoteID(widget.selectedId),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError) print(snapshot.error);

            Note notes = snapshot.data;

            var selectedId = widget.selectedId;

            if (notes.finished == true) {
              DateTime inicio = DateTime.parse(notes.startedAt);
              DateTime fim = DateTime.parse(notes.stopedAt);
              var tempo = timeAgo(fim, inicio);

              DateTime start = DateTime.parse(notes.startedAt);
              DateTime stop = DateTime.parse(notes.stopedAt);
              final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
              String formatedStart =
                  dateFormat.format(DateTime.parse(start.toString()));
              String formatedStop =
                  dateFormat.format(DateTime.parse(stop.toString()));

              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Container(
                      width: 280,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Técnico:',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, left: 15.0),
                                  child: Text(
                                    name,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Início:',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, left: 31.0),
                                  child: Text(
                                    formatedStart,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Final:',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 35.0),
                                  child: Text(
                                    formatedStop,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Duração:',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 11.0),
                                  child: Text(
                                    tempo,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, bottom: 5.0),
                              child: Text(
                                'Avaliação inicial:',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                                                child: Text(
                                  notes.initialDescription,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic)),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, bottom: 5.0),
                              child: Text(
                                'Serviço executado:',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                                                child: Text(
                                  notes.finalDescription,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic)),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, bottom: 5.0),
                              child: Text(
                                'Imagem inicial',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InitialImage(selectedId)));
                                    },
                                    child: Image.network(
                                      notes.initialImage,
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      height: 180.0,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white, border: Border.all())),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, bottom: 5.0),
                              child: Text(
                                'Imagem final',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FinalImage(selectedId)));
                                    },
                                    child: Image.network(
                                      notes.finalImage,
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      height: 180.0,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white, border: Border.all())),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Toque para excluir a tarefa:',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFFF44336),
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600))),
                                  GestureDetector(
                                    onTap: () async {
                                      //print(notes.initialImage.split("/")[4]);
                                      //print(notes.finalImage.split("/")[4]);
                                      Map<String, dynamic> params =
                                          Map<String, dynamic>();
                                      params["initial"] =
                                          notes.initialImage.split("/")[4];
                                      params['final'] =
                                          notes.finalImage.split("/")[4];
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirmação"),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                        "Deseja excluir este registro ?")
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('Sim'),
                                                  onPressed: () async {
                                                    await deleteNote(
                                                        params, selectedId);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ListPage(
                                                                        true)));
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('Não'),
                                                  onPressed: () async {
                                                    Navigator.pop(
                                                        context); //Quit to previous screen
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: IconButton(
                                        iconSize: 30,
                                        alignment: Alignment.center,
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: null),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              );
            } else {
              return AlertDialog(
                title: Text("Não disponível!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Este registro não está finalizado.")
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Fechar'),
                    onPressed: () {
                      Navigator.pop(context); //Quit Dialog
                    },
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text('Tarefas'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              title: Text('Back'),
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

  String timeAgo(DateTime fim, inicio) {
    Duration diff = fim.difference(inicio);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "ano" : "anos"}";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "mês" : "meses"}";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "semana" : "semanas"}";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "dia" : "dias"}";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hora" : "horas"}";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minuto" : "minutos"}";
    return "Segundos";
  }

  Future loadName() async {
    name = await storage.read(key: 'nameUser');
    setState(() {
      this.name = name;
    });
  }
}
