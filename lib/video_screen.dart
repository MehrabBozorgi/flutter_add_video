import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  var _value;
  var _fileName;
  var _fileSize;
  Uint8List? bytes;

  VideoPlayerController? _videoPlayerController;
  File? _video;

  final picker = ImagePicker();

  _pickFile() async {
    final video = await picker.pickVideo(source: ImageSource.gallery);

    _video = File(video!.path);
    bytes = _video!.readAsBytesSync();
    final mb = bytes!.lengthInBytes / 1024 / 1024;
    setState(() {
      _value = _video;
      _fileName = video.name.replaceAll('image_picker-', '');
      _fileSize = mb.toString().substring(0, 4);
    });
    _videoPlayerController = VideoPlayerController.file(
      _video!,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize();
    print('========================');
    print('${_value}');
    print('${_fileName}');
    print('${_fileSize}');
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 220,
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _video == null || _value == '0'
                    ? InkWell(
                        splashColor: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          _pickFile();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(
                              Icons.video_call_rounded,
                              size: 150,
                            ),
                            Text(
                              'انتخاب',

                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          InkWell(
                            splashColor: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              _pickFile();
                            },
                            child: Container(
                              height: 170,
                              width: 220,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  if (_video != null)
                                    _videoPlayerController!
                                            .value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio:
                                                _videoPlayerController!
                                                    .value.aspectRatio,
                                            child: VideoPlayer(
                                                _videoPlayerController!),
                                          )
                                        : Container(),
                                ],
                              ),
                            ),
                          ),
                          _video != null || _video != '0'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: FloatingActionButton(
                                    elevation: 10,
                                    mini: true,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    onPressed: () {
                                      setState(() {
                                        if (_videoPlayerController!
                                            .value.isPlaying) {
                                          _videoPlayerController!.pause();
                                        } else {
                                          _videoPlayerController!.play();
                                        }
                                      });
                                    },
                                    child: Icon(
                                      _videoPlayerController!
                                              .value.isPlaying
                                          ? (Icons.pause)
                                          : Icons.play_arrow,

                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
              ),

              _fileName != null
                  ? _fileName != '0'
                      ? _value != '0'
                          ? Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    _fileName
                                        .toString()
                                        .replaceAll('[', '')
                                        .replaceAll(']', ''),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Text(
                                  '${_fileSize}MB',
                                  style:
                                      Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            )
                          : Container()
                      : Container()
                  : Container(),
              //
            ],
          ),
        ),
      ),
    );
  }
}
// InkWell(
//                                 borderRadius: BorderRadius.circular(25),
//                                 onTap: () {
//                                   setState(() {
//                                     // _video = '0';
//                                     _fileName = '0';
//                                     _fileSize = '0';
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8),
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 8),
//                                   height: 75,
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.delete_forever,
//                                         color: Colors.red,
//                                       ),
//                                       SizedBox(height: 5),
//                                       Text(
//                                         'حذف',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyText1,
//                                       ),
//                                       FloatingActionButton(
//                                         elevation: 10,
//                                         mini: true,
//                                         backgroundColor: Theme.of(context).primaryColor,
//                                         onPressed: () {
//                                           setState(() {
//                                             if (_videoPlayerController!
//                                                 .value.isPlaying) {
//                                               _videoPlayerController!.pause();
//                                             } else {
//                                               _videoPlayerController!.play();
//                                             }
//                                           });
//                                         },
//                                         child: Icon(
//                                           _videoPlayerController!.value.isPlaying
//                                               ? (Icons.pause)
//                                               : Icons.play_arrow,
//                                           color:Theme.of(context).accentColor,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
