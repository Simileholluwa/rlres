import 'package:atles/common/widgets/android_bottom_nav.dart';
import 'package:atles/video_player/landscape_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final String title;
  final String url;
  final String date;
  const LocalVideoPlayer(
    this.title,
    this.url,
    this.date, {
    super.key,
  });

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then(
        (value) => _controller.play(),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AndroidBottomNav(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: true,
              toolbarHeight: 70,
              title: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  '${widget.date} at ${widget.title}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).hintColor,),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      size: 27,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                height: 300,
                child: _controller.value.isInitialized
                    ? Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xff13a866),
                        ),
                      ),
              ),
              _controller.value.isInitialized
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _controller,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  return Text(
                                    _videoDuration(value.position),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: VideoProgressIndicator(
                                      _controller,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 10,
                                      ),
                                      allowScrubbing: true,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _videoDuration(_controller.value.duration),
                              ),
                            ],
                          ),
                        ),
                        _controller.value.isInitialized
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.camera_enhance),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.share),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                        });
                                      },
                                      icon: _controller.value.isPlaying
                                          ? Icon(
                                              Icons.pause,
                                            )
                                          : Icon(
                                              Icons.play_arrow,
                                              size: 30,
                                            ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.to(() => LandscapeVideo(
                                              controller: _controller,
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.screen_rotation_rounded,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
