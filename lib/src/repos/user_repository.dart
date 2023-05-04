import 'dart:convert';

import '../core/http_client.dart';
import '../shared/models/models.dart';

class UserRepository {
  UserRepository._();
  static final UserRepository _instance = UserRepository._();
  factory UserRepository() {
    return _instance;
  }

  Future<List<User>> loadUsers() async {
    final response = await httpClient.get(Uri.http('users'));

    if (response.statusCode < 400) {
      String data = response.body;
      final parsed = jsonDecode(data).cast<Map<String, dynamic>>();
      final List<User> items = parsed.map<User>((json) => User.fromJson(json)).toList();
      return items;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> loadUser(String itemId) async {
    final response = await httpClient.get(Uri.http('users', '/$itemId'));

    if (response.statusCode < 400) {
      String data = response.body;
      final User item = User.fromJson(jsonDecode(data));
      return item;
    } else {
      throw Exception('Failed to load user');
    }
  }
}