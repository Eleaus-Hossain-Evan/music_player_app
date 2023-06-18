part of '../home_screen.dart';

class _TrendingSongsSection extends StatelessWidget {
  const _TrendingSongsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final trendingSongs = Song.songs.where((song) => song.isTrending).toList();
    return AppGrid(
      title: AppText('Trending Now'),
      gridSettings: const AppGridSettings(
        crossAxisCount: 2,
        childAspectRatio: 3.55,
      ),
      gridItems: trendingSongs.map(
        (song) {
          return AppListTile(
            contentPadding: EdgeInsets.zero,
            leading: AppImage.network(
              song.imageUrl,
              height: 48,
            ),
            title: AppText.bodyMedium(
              song.title,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {
              context.read<SongRepository>().setCurrentSong(song);
              context.read<SongRepository>().play();
            },
          );
        },
      ).toList(),
    );
  }
}

// class AppGrid extends StatelessWidget {
//   const AppGrid({
//     super.key,
//     this.title,
//     this.description,
//     required this.gridItems,
//     required this.gridSettings,
//     this.height,
//     this.physics = const NeverScrollableScrollPhysics(),
//   });

//   final Widget? title;
//   final Widget? description;
//   final double? height;
//   final ScrollPhysics? physics;
//   final AppGridSettings gridSettings;
//   final List<Widget> gridItems;

//   @override
//   Widget build(BuildContext context) {
//     SliverGridDelegateWithFixedCrossAxisCount gridDelegate;

//     gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: gridSettings.crossAxisCount,
//       mainAxisSpacing: gridSettings.mainAxisSpacing,
//       crossAxisSpacing: gridSettings.crossAxisSpacing,
//       childAspectRatio: gridSettings.childAspectRatio,
//     );

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppTextBlock(title: title, subtitle: description),
//         SizedBox(
//           height: height,
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: physics,
//             padding: EdgeInsets.zero,
//             itemCount: gridItems.length,
//             gridDelegate: gridDelegate,
//             itemBuilder: (context, index) => gridItems[index],
//           ),
//         ),
//       ],
//     );
//   }
// }
