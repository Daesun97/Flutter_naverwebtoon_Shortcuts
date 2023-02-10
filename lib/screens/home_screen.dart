import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:naver_webtoon/models/webtoon_model.dart';
import 'package:naver_webtoon/services/api_service.dart';
import 'package:naver_webtoon/widget/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.yellow.shade400,
        title: const Text(
          '오늘의 웹툰',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      // FutureBuilder 미래의 값(Future)을 받고 그 값을 알아서 기달려 주고(await)그 값이 있는지 없는지를 알 수 있음
      body: FutureBuilder(
        future: webtoons,
        builder: (context, future) {
          if (future.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: makeList(context, future))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ScrollConfiguration makeList(
      BuildContext context, AsyncSnapshot<List<WebtoonModel>> future) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: future.data!.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //itemBuilder: 페이지에 일정양의 데이터만 로딩함
        itemBuilder: (context, index) {
          // print(index);
          var webtoon = future.data![index];
          return Webtoon(
            id: webtoon.id,
            thumb: webtoon.thumb,
            title: webtoon.title,
          );
        },
        //separatorBuilder: 아이템 사이를 별려줌
        separatorBuilder: (context, index) => const SizedBox(
          width: 40,
        ),
      ),
    );
  }
}
