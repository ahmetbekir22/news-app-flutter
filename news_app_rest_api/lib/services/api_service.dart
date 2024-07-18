import 'package:dio/dio.dart';

import '../constants/const.dart';
import '../models/news_model.dart';

class ApiService {
  static Future<Dio> dioAuth() async {
    BaseOptions options = BaseOptions(
      baseUrl: Const.baseUrl,
    );

    return Dio(options);
  }

  static Future<List<Articles>> getNews({
    String country = "us",
    String category = "sports",
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final now = DateTime.now();
      final from = fromDate ?? now;
      final to = toDate ?? now;

      final dio = await dioAuth();
      Response response = await dio.get(
        "/top-headlines",
        queryParameters: {
          "country": country,
          "category": category,
          "from": from.toIso8601String(),
          "to": to.toIso8601String(),
          "sortBy": "popularity",
          "apiKey": Const.apiKey,
        },
      );

      if (response.statusCode == 200) {
        final articles = (response.data["articles"] as List)
            .map((articleJson) => Articles.fromJson(articleJson))
            .toList();
        return articles;
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch news');
    }
  }
}
