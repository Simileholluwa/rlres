import 'dart:convert';
import 'package:atles/homepage/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/firestore_ref.dart';
import '../../image_details/photo_view.dart';

class Violators extends GetView<HomepageController> {
  const Violators({super.key});

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
                  controller.state.appBarTitle2.value,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.sort_rounded,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: controller.fetchInitialSelectedImageDocData(),
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
                      'There are no violations here yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List initialImageUrl = snapshot.data!;
            controller.state.selectedIndex2.value = 0;
            controller.state.imageUrls.assignAll(initialImageUrl);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: violatorsRF.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
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
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
                                final urls = documentSnapshot['image_url'];
                                final time = documentSnapshot['time'];
                                final plateId = documentSnapshot['plates_id'];
                                final plateNumber =
                                    documentSnapshot['plate_numbers'];
                                final dataFound =
                                    documentSnapshot['data_found'];
                                controller.state.documentId2.value =
                                    documentSnapshot.id;
                                controller.state.appBarTitle2.value =
                                    controller.parseDateFromFolderName(
                                        documentSnapshot.id);
                                controller.loadImagesForDocument(
                                    urls, time, plateId, plateNumber, dataFound);
                                controller.state.selectedIndex2.value = index;
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
                                        index == controller.state.selectedIndex2.value
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
                                          textAlign: TextAlign.right,
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
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${documentSnapshot['image_url'].length}',
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
                                  controller.state.imageUrls.length),
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
                                itemCount: controller.state.imageUrls.length,
                                itemBuilder: (context, index) {
                                  final urls =
                                      controller.state.imageUrls[index];
                                  final time = controller.state.time[index];
                                  final plateId =
                                      controller.state.platesId[index];
                                  final plateNumber = controller
                                      .state.plateNumbers[index][plateId];
                                  final dataFound = controller
                                      .state.dataFound[index][plateId];
                                  return FutureBuilder(
                                      future: controller.loadImageLocally(urls),
                                      builder: (context, snapshot) {
                                        final thumbnail = snapshot.data;
                                        return GridTile(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                () => ImageView(
                                                  plateNumbers: plateNumber,
                                                  wasFound: dataFound,
                                                  time: controller
                                                      .parseVideoName(time),
                                                  date: controller
                                                      .parseDateFromFolderName(
                                                          controller
                                                              .state
                                                              .documentId2
                                                              .value),
                                                  image: thumbnail!,
                                                ),
                                                transition: Transition.downToUp,
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: thumbnail != null
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.memory(
                                                            base64Decode(
                                                                thumbnail),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                            time,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                              fontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: Offset(0, 1),
                                                            color: Colors.red,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          controller
                                                              .parseVideoName(
                                                                  time),
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor,
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
