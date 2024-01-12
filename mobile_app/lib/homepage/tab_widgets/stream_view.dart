import 'dart:convert';
import 'package:atles/homepage/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/firestore_ref.dart';
import '../../video_player/portrait_mode.dart';
import 'package:cool_alert/cool_alert.dart';

class Videos extends GetView<HomepageController> {
  const Videos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Obx(
                () => Text(
                  controller.state.appBarTitle.value,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: ()  {},
                icon: Icon(
                  Icons.search,
                  size: 27,
                ),
              ),
            IconButton(
              onPressed: ()  {},
              icon: Icon(
                Icons.sort_rounded,
                size: 30,
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.info,
                      animType: CoolAlertAnimType.slideInUp,
                      title: 'Are you sure?',
                      text: 'You will no longer have access to unsaved data when you logout.',
                      onConfirmBtnTap: () async {
                        await controller.signOut();
                      },

                      confirmBtnText: 'Logout',
                      cancelBtnText: 'Cancel',
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                      confirmBtnColor: const Color(0xff13a866),
                      backgroundColor: Theme.of(context).canvasColor,
                    );
                  },
                  icon: Icon(
                    Icons.logout_sharp,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: controller.fetchInitialSelectedDocData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xff13a866),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('There is an error'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.opacity_outlined,
                      size: 100,
                      color: Theme.of(context).hintColor,
                    ),
                    Text(
                      'There are no videos here yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List initialVideoUrl = snapshot.data!;
            controller.state.selectedIndex.value = 0;
            controller.state.subDocumentUrl.assignAll(initialVideoUrl);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: videoRF.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).dialogBackgroundColor
                            ,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Loading..',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 15,
                          bottom: 15,
                        ),
                        separatorBuilder: (context, index){
                          return SizedBox(
                            height: 15,
                          );
                        },
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
                                final urls = documentSnapshot['downloadUrl'];
                                final names = documentSnapshot['name'];
                                controller.state.documentId.value =
                                    documentSnapshot.id;
                                controller.state.appBarTitle.value =
                                    controller.parseDateFromFolderName(
                                        documentSnapshot.id);
                                controller.loadVideosForDocument(urls, names);
                                controller.state.selectedIndex.value = index;
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        index == controller.state.selectedIndex.value
                                            ? BoxShadow(
                                          offset: Offset(2, 2),
                                          color: const Color(0xff13a866),
                                        )
                                        : BoxShadow(
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          controller.parseDateFromFolderName(
                                              documentSnapshot.id),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).hintColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              color: Color(0xffffbd3a),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                              '${documentSnapshot['name'].length}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: Column(
                        children: [
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              key: ValueKey<int>(
                                  controller.state.subDocumentUrl.length),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  mainAxisSpacing: 15.0,
                                  crossAxisSpacing: 15.0,
                                ),
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  right: 10,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    controller.state.subDocumentUrl.length,
                                itemBuilder: (context, index) {
                                  final urls =
                                      controller.state.subDocumentUrl[index];
                                  final names =
                                      controller.state.subDocumentName[index];
                                  return FutureBuilder(
                                      future:
                                          controller.loadThumbnailLocally(urls),
                                      builder: (context, snapshot) {
                                        final thumbnail = snapshot.data;
                                        return GridTile(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                () => LocalVideoPlayer(
                                                  controller
                                                      .parseVideoName(names),
                                                  urls,
                                                  controller
                                                      .parseDateFromFolderName(
                                                          controller
                                                              .state
                                                              .documentId
                                                              .value),
                                                ),
                                                transition:
                                                    Transition.downToUp,
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 150,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  child: thumbnail != null
                                                      ? ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    child: Image.memory(
                                                      base64Decode(thumbnail),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                      : Center(
                                                          child: Text(
                                                            controller
                                                                .parseVideoName(
                                                                    names),
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Theme.of(context)
                                                                      .hintColor,
                                                              fontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius.circular(10),
                                                          bottomRight: Radius.circular(10),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: Offset(0, 1),
                                                            color: Color(0xffffbd3a),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          controller.parseVideoName(names),
                                                          style: TextStyle(
                                                            color: Theme.of(context).hintColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            );
          }
        },
      ),
    );
  }
}
