import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../additional.dart';
import '../base.dart';
import '../utils.dart';
import 'image/cross_network_image.dart';

/// Display a media player.
class AdaptiveMedia extends StatefulWidget with AdaptiveElementWidgetMixin {
  /// Creates an AdaptiveMedia widget.
  AdaptiveMedia({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveMediaState createState() => _AdaptiveMediaState();
}

class _AdaptiveMediaState extends State<AdaptiveMedia>
    with AdaptiveElementMixin {
  VideoPlayerController? videoPlayerController;
  ChewieController? controller;

  String? sourceUrl;
  String? posterUrl;
  String? altText;

  FadeAnimation imageFadeAnim = FadeAnimation(
    child: const Icon(Icons.play_arrow, size: 100.0),
  );

  @override
  void initState() {
    super.initState();

    posterUrl = adaptiveMap["poster"];
    sourceUrl = adaptiveMap["sources"][0]["url"];
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(sourceUrl!);

    await videoPlayerController!.initialize();

    controller = ChewieController(
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: true,
      videoPlayerController: videoPlayerController!,
    );

    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget getVideoPlayer() {
      return Chewie(
        controller: controller!,
      );
    }

    Widget getPlaceholder() {
      if (posterUrl != null) return CrossNetworkImage(url: posterUrl!);
      return Container();
    }

    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: controller == null ? getPlaceholder() : getVideoPlayer(),
        ),
      ),
    );
  }
}
