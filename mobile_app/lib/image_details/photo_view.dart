import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/widgets/android_bottom_nav.dart';

class ImageView extends StatelessWidget {
  final List plateNumbers;
  final List wasFound;
  final String date;
  final String time;
  final String image;
  const ImageView(
      {super.key,
      required this.plateNumbers,
      required this.wasFound,
      required this.date,
      required this.time,
      required this.image});

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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              automaticallyImplyLeading: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  '$date at $time',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
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
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 300,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              child: Image.memory(
                base64Decode(image),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DataTable(
              border: TableBorder.all(
                color: Theme.of(context).canvasColor,
                width: 3,
              ),
              headingRowColor: MaterialStateProperty.resolveWith(
                (states) => const Color(0xff13a866),
              ),
              headingTextStyle: GoogleFonts.raleway(
                color: Colors.white,
              ),
              columns: [
                DataColumn(
                  label: Text('Plate Numbers'),
                ),
                DataColumn(
                  label: Text('Found in database'),
                ),
                DataColumn(
                  label: Text('Cited'),
                ),
              ],
              rows: List<DataRow>.generate(
                plateNumbers.length,
                (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(plateNumbers[index],
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    DataCell(
                      Text(
                        wasFound[index],
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    DataCell(
                      wasFound[index] == 'Yes'
                          ? Icon(
                              Icons.check,
                              color: const Color(0xff13a866),
                            )
                          : Icon(Icons.cancel, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
