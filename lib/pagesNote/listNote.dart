import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task/mainPage.dart';
import 'package:task/models/note.dart';
import 'package:task/pagesNote/detailNote.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'package:task/service/noteService.dart';

final storage = new FlutterSecureStorage();

class ListPage extends StatefulWidget {
  final bool finished;
  ListPage(this.finished) : super();
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    String nomePagina;

    if (widget.finished == true) {
      nomePagina = 'Tarefas Finalizadas';
    } else {
      nomePagina = 'Tarefas Abertas';
    }

    return Scaffold(
      backgroundColor: Color(0xFFF1F0F5),
      appBar: new AppBar(
          title: Text(
            nomePagina,
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
          future: getNotesFinished(widget.finished),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            final List<Note> notes = snapshot.data;

            return snapshot.hasData
                ? _listCategoria(notes)
                : Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text('Tarefas'),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
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

  _listCategoria(notes) {
    String estado, formatedStart, formatedStop;
    DateTime inicio, fim;
    var tempo;
    final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(color: Color(0xFFF1F0F5)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            estado = notes[index].finished.toString();

            if (notes[index].finished.toString() == "true") {
              inicio = DateTime.parse(notes[index].startedAt);
              fim = DateTime.parse(notes[index].stopedAt);
              tempo = timeAgo(fim, inicio);
              DateTime stop = DateTime.parse(notes[index].stopedAt);
              formatedStop = dateFormat.format(DateTime.parse(stop.toString()));
            } else {
              tempo = "";
              formatedStop = '';
            }

            DateTime start = DateTime.parse(notes[index].startedAt);
            formatedStart = dateFormat.format(DateTime.parse(start.toString()));

            return GestureDetector(
                onLongPress: () {
                  String selectedId = notes[index].id;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailNote(selectedId)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Container(
                    height: 100.0,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.network(
                            notes[index].initialImage,
                            fit: BoxFit.contain,
                            //height: 60.0,
                            width: 100.0,
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 5.0, right: 20.0),
                                    child: Text(
                                      'Início:',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700,
                                      )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      formatedStart,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 8.0, right: 24.0),
                                    child: estado == 'true'
                                        ? Text(
                                            'Final:',
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w700,
                                            )),
                                          )
                                        : Text(''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      formatedStop,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 8.0, right: 5.0),
                                    child: estado == 'true'
                                        ? Text(
                                            'Duração:',
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w700,
                                            )),
                                          )
                                        : Text(''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      tempo,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          },
          itemCount: notes.length,
        ),
      ),
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
}

