import 'dart:convert';

import '../core/http_client.dart';
import '../shared/models/models.dart';

class TopicRepository {
  TopicRepository._();
  static final TopicRepository _instance = TopicRepository._();
  factory TopicRepository() {
    return _instance;
  }

  Future<List<Topic>> loadTopics() async {
    final response = await httpClient.get(Uri.http('topics'));

    if (response.statusCode < 400) {
      String data = response.body;
      final parsed = jsonDecode(data).cast<Map<String, dynamic>>();
      final List<Topic> items = parsed.map<Topic>((json) => Topic.fromJson(json)).toList();
      return items;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Topic> loadTopic(String itemId) async {
    final response = await httpClient.get(Uri.parse('topics/$itemId'));

    if (response.statusCode < 400) {
      String data = response.body;
      final Topic item = Topic.fromJson(jsonDecode(data));
      return item;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}