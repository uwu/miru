import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'anime_card.dart';

import 'api.dart' as api;

import 'utils.dart';

const animesToShow = 10;

class Carousel extends StatelessWidget {
  const Carousel({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getPopular(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          // data loaded:
          final trendingTop5 = snapshot.data["results"].take(animesToShow);
          List<Widget> widgets = [];

          for (final item in trendingTop5) {
            widgets.add(
              AnimeCard(
                id: item["id"],
                title: item["title"].isEmpty
                    ? titleCase(removeDashes(item["id"]))
                    : item["title"],
                image: item["image"],
              ),
            );
          }

          return CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.5,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.25,
              scrollDirection: Axis.horizontal,
            ),
            items: widgets,
          );
        }
      },
    );
  }
}
