import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';

import '../../../models/song.dart';

part 'widgets/_trending_songs_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppText.headlineSmall('Good evening!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TrendingSongsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
