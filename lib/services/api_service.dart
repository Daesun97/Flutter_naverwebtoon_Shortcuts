import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:naver_webtoon/models/webtoon_detail_model.dart';
import 'package:naver_webtoon/models/webtoon_episode_model.dart';
import 'package:naver_webtoon/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';
// 오늘의 웹툰 들고오기
//async 비동기 함수 await를 위해 필요함
  static Future<List<WebtoonModel>> getTodaysToon() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //json을 List(dynamic으로 이루어진)로 변환
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    //200이 아니면 에러
    throw Error();
  }

  //오늘의 웹툰의 에피소드를 들고오기 위해 ID로 들어가기
  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

// 오늘의 웹툰의 에피소드를 들고옴
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      //가져오는 값이 리스트이기 때문에 위에서 리스트를 만들어 놓음
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
