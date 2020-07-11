import 'dart:io';
import 'package:dio/dio.dart';
import 'package:task/models/note.dart';
import '../global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

Future<Map> addNote(formData) async {
  Dio dio = Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  try {
    await dio.post('$URL_ADD_NOTES', data: formData);
    storage.write(key: 'erroRegisterNote', value: "Sem erro note");
  } on DioError catch (e) {
    if (e.response != null) {
      await storage.write(key: 'erroRegisterNote', value: "Erro envio");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      await storage.write(key: 'erroRegisterNote', value: "Erro envio");
      print(e.request);
      print(e.message);
    }
  }
  return null;
}

Future<Map> updateNote(noteId, formData) async {
  Dio dio = Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  try {
    await dio.put('$URL_UPDATE_NOTES$noteId', data: formData);
    storage.write(key: 'erroUpdateNote', value: "Sem erro note");
  } on DioError catch (e) {
    if (e.response != null) {
      await storage.write(key: 'erroUpdateNote', value: "Erro envio");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      await storage.write(key: 'erroUpdateNote', value: "Erro envio");
      print(e.request);
      print(e.message);
    }
  }
  return null;
}

Future<List<Note>> getNotes(userId) async {
  Response response;
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  response = await dio.get('$URL_GET_NOTES$userId');
  if (response.statusCode == 200) {
    final listaNotes = response.data["notes"];
    //.cast<Map<String, dynamic>>();
    List<Note> notes =
        (listaNotes as List).map((item) => Note.fromJson(item)).toList();
    return notes;
  } else {
    throw Exception('Falha para carregar a lista de livros do webservice.');
  }
}

Future<List<Note>> getNotesFinished(bool finished) async {
  Response response;
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  var user = await storage.read(key: 'idUser');
  var queryParameters = {
    'finished': finished,
    'user': user,
  };
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  response = await dio.get('$URL_GET_NOTES_FINISHED',
      queryParameters: queryParameters);
  if (response.statusCode == 200) {
    final listaNotes = response.data["notes"];
    //.cast<Map<String, dynamic>>();
    List<Note> notes =
        (listaNotes as List).map((item) => Note.fromJson(item)).toList();
    return notes;
  } else {
    throw Exception('Falha para carregar a lista de livros do webservice.');
  }
}

Future<Note> getNoteID(String noteId) async {
  Response response;
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  response = await dio.get('$URL_GET_NOTE_ID$noteId');
  if (response.statusCode == 200) {
    final idNote = response.data["note"];
    return Note.fromJson(idNote);
  } else {
    throw Exception('Falha para carregar a lista de livros do webservice.');
  }
}

Future<Note> deleteNote(params, noteId) async {
  Dio dio = new Dio();
  var token = await storage.read(key: 'jwt');
  dio.options.headers[HttpHeaders.authorizationHeader] = ('Bearer ' + token);
  try {
    await dio.delete('$URL_DELETE_NOTE_ID$noteId', data: params);
  } on DioError catch (e) {
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      print(e.request);
      print(e.message);
    }
  }
  return null;
}
