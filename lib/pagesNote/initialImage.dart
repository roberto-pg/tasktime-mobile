import 'package:flutter/material.dart';
import 'package:task/models/note.dart';
import 'package:task/service/noteService.dart';
import 'package:photo_view/photo_view.dart';

class InitialImage extends StatelessWidget {
  final String selectedId;
  InitialImage(this.selectedId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(
            "Imagem Inicial",
            style: TextStyle(
                color: Color(0xFF18D191), fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Color(0xFF18D191))),
      body: Container(
          child: FutureBuilder(
              future: getNoteID(selectedId),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) print(snapshot.error);

                Note notes = snapshot.data;

                return Container(
                    child: PhotoView(
                  imageProvider: NetworkImage(notes.initialImage),
                  backgroundDecoration:
                      BoxDecoration(color: Colors.transparent),
                ));
              })),
    );
  }
}
