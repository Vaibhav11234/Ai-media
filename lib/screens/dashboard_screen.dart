import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/media_feed_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        // ✅ Removed AppBar completely
        body: Column(
          children: [
            // ✅ TabBar moved here at top inside body
            Container(
              padding: EdgeInsets.only(top: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF6A1B9A),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(12),
                //   bottomRight: Radius.circular(12),
                // ),
              ),
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Image Feed", icon: Icon(Icons.image_outlined)),
                  Tab(text: "Video Feed", icon: Icon(Icons.video_library_outlined)),
                ],
              ),
            ),
            // ✅ Expanded TabBarView to fill rest of the screen
            Expanded(
              child: TabBarView(
                children: [
                  MediaFeedWidget(
                    type: "Image",
                    feedList: controller.imageFeed,
                    controller: controller,
                  ),
                  MediaFeedWidget(
                    type: "Video",
                    feedList: controller.videoFeed,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
