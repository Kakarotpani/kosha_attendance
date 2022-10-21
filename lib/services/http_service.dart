import 'dart:convert';
import 'package:http/http.dart';
import 'package:kosha_attendance/models/user_model.dart';

class HttpServices{
  Future<List<UserModel>> getUsers() async {
    List<UserModel> userList;
    const getApi = 'https://reqres.in/api/users?page=1';
    final Response response = await get(Uri.parse(getApi));
    if(response.statusCode == 200){
      dynamic body = jsonDecode(response.body);
      userList = body["data"].map<UserModel>((json) => UserModel.fromJson(json)).toList();
      return userList;
    }
    else{
      throw Exception('Failed to get data');
    }
  }
}