import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/utils/firestore_ref.dart';
import '../controller.dart';

class Tickets extends GetView<HomepageController> {
  const Tickets({super.key});

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
              child: Text(
                'Tickets',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
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
      body: StreamBuilder(
        stream: historyRF.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xff13a866),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('There is an error'));
          } else if (snapshot.data!.docs.isEmpty) {
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
                      'There are no tickets here yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 15,
              );
            },
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              final urls = documentSnapshot['image_url'];
              return FutureBuilder(
                  future: controller.loadImageLocally(urls),
                  builder: (context, snapshot) {
                    final thumbnail = snapshot.data;
                    return Container(
                      height: 100,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1, 0),
                            color: const Color(0xff13a866),
                          ),
                          BoxShadow(
                            offset: Offset(-1, 0),
                            color: const Color(0xff13a866),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: thumbnail != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(thumbnail),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Name: ',
                                    style: GoogleFonts.raleway(
                                      color: Theme.of(context).hintColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${documentSnapshot['name'].toString().capitalize}',
                                        style: GoogleFonts.raleway(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Email: ',
                                    style: GoogleFonts.raleway(
                                      color: Theme.of(context).hintColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${documentSnapshot['email'].toString().capitalizeFirst}',
                                        style: GoogleFonts.raleway(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Plate number: ',
                                    style: GoogleFonts.raleway(
                                      color: Theme.of(context).hintColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${documentSnapshot['plate_number'].toString().toUpperCase()}',
                                        style: GoogleFonts.raleway(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${controller.parseDateFromFolderName(documentSnapshot['date'])} at ${controller.parseVideoName(documentSnapshot['time'])}',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
