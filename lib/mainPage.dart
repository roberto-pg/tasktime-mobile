import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task/pagesNote/listNote.dart';
import 'package:task/pagesNote/startNote.dart';
import 'package:task/pagesNote/unfinishedNote.dart';
import 'package:task/pagesUser/loginUser.dart';
import 'package:task/service/noteService.dart';
import 'models/note.dart';

final storage = new FlutterSecureStorage();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var name, userId;
  String estado;

  @override
  void initState() {
    super.initState();
    loadName();
    loadId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0F5),
      appBar: new AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF28CC9E),
      ),
      body: FutureBuilder(
          future: getNotes(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // Token inválido: Deleta o token e desliga o app
              if (snapshot.error.toString().split(" ")[5] == "[401]") {
                storage.deleteAll();
                SystemNavigator.pop();
              }
            }
            final List<Note> notes = snapshot.data;

            return (!snapshot.hasData)
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: new Container(
                        decoration: BoxDecoration(color: Color(0xFFF1F0F5)),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                child: Image.asset(
                                  'images/logo.png',
                                  fit: BoxFit.fill,
                                  width: 200.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text('Olá $name',
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(fontSize: 20.0),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text('O que você quer fazer agora?',
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(fontSize: 20.0),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Iniciar uma nova tarefa:',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: IconButton(
                                        iconSize: 44,
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterNote()));
                                        },
                                        icon: Icon(Icons.playlist_add,
                                            color: Color(0xFFF44336))),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Finalizar uma tarefa:',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: IconButton(
                                        iconSize: 35,
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UnfinishedPage(false)));
                                        },
                                        icon: Icon(Icons.build,
                                            color: Color(0xFFF44336))),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                            ),
                            _listTodos(notes),
                            new SizedBox(
                              height: 10.0,
                            ),
                            new SizedBox(
                              height: 10.0,
                            ),
                          ],
                        )),
                  );
          }),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check),
              title: Text('Fechadas'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              title: Text('Abertas'),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListPage(true)));
                break;
              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListPage(false)));
                break;
              case 3:
                storage.deleteAll();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                break;
              case 4:
                exit(0);
                break;
              default:
            }
          }),
    );
  }

  _listTodos(notes) {
    return Container(
      height: 150,
      child: RefreshIndicator(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (notes[index].finished.toString() == "false") {
              estado = "Aberto";
            } else {
              estado = "Finalizado";
            }

            DateTime start = DateTime.parse(notes[index].startedAt);
            final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
            String formatedTime =
                dateFormat.format(DateTime.parse(start.toString()));

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      notes[index].initialImage,
                      alignment: Alignment.topLeft,
                      fit: BoxFit.cover,
                      height: 80.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        formatedTime,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                    ),
                    Text(
                      estado,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: notes.length,
        ),
        onRefresh: _getData,
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {
      getNotes(userId);
    });
  }

  Future loadName() async {
    name = await storage.read(key: 'nameUser');
    setState(() {
      this.name = name;
    });
  }

  Future loadId() async {
    var userId = await storage.read(key: 'idUser');
    setState(() {
      this.userId = userId;
    });
  }
}
