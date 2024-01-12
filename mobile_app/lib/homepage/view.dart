import 'package:atles/common/widgets/android_bottom_nav.dart';
import 'package:atles/common/widgets/exit_app.dart';
import 'package:atles/homepage/index.dart';
import 'package:atles/homepage/tab_widgets/tickets_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tab_widgets/stream_view.dart';

class Homepage extends GetView<HomepageController> {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShouldExit(
      child: AndroidBottomNav(
        child: Scaffold(
          bottomNavigationBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: TabBar(
                labelStyle: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                ),
                controller: controller.state.tabController,
                labelColor: const Color(0xff13a866),
                indicatorColor: const Color(0xff13a866),
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Theme.of(context).hintColor,
                splashBorderRadius: BorderRadius.all(Radius.circular(10),),
                indicatorPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                tabs: const [
                  SizedBox(
                    height: 40,
                    child: Tab(
                      text: 'Videos',
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(
                      text: 'Violators',
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(
                      text: 'Tickets',
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: controller.state.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Videos(),
              Violators(),
              Tickets(),
            ],
          ),
        ),
      ),
    );
  }
}
