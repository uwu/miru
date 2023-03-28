import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:miru/anime_card.dart';

import 'package:miru/api.dart' as api;

const animesToShow = 5;

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
                title: item["title"],
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
