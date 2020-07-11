import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task/models/note.dart';
import 'package:task/pagesNote/stopNote.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'package:task/service/noteService.dart';

final storage = new FlutterSecureStorage();

class UnfinishedPage extends StatefulWidget {
  final bool finished;
  UnfinishedPage(this.finished) : super();
  @override
  _FinishedPageState createState() => _FinishedPageState();
}

class _FinishedPageState extends State<UnfinishedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0F5),
      appBar: new AppBar(
          title: Text(
            'Tarefas Abertas',
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
            return snapshot.hasData
                ? MainContent(notes: snapshot.data)
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
}

class MainContent extends StatelessWidget {
  final List<Note> notes;
  MainContent({Key key, this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _listCategoria();
  }

  _listCategoria() {
    String formatedStart;
    final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(color: Color(0xFFF1F0F5)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DateTime start = DateTime.parse(notes[index].startedAt);
            formatedStart = dateFormat.format(DateTime.parse(start.toString()));

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: GestureDetector(
                onTap: () {
                  String selectedId = notes[index].id;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StopNote(selectedId)));
                },
                child: Container(
                  height: 100.0,
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          notes[index].initialImage,
                          fit: BoxFit.fill,
                          height: 65.0,
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30.0, left: 70.0),
                              child: Row(
                                children: <Widget>[
                                  Text('Finalizar a tarefa',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFF44336),
                                        fontStyle: FontStyle.italic,
                                      ))),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: notes.length,
        ),
      ),
    );
  }
}
