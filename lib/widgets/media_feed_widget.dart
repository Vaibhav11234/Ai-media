import 'package:ai_media_feed/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/media_item_model.dart';
import '../../controllers/dashboard_controller.dart';

class MediaFeedWidget extends StatelessWidget {
  final String type;
  final List<MediaItem> feedList;
  final DashboardController controller;

  const MediaFeedWidget({
    super.key,
    required this.type,
    required this.feedList,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$type Feed",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => controller.toggleSort(feedList),
                    icon: const Icon(Icons.sort, size: 18,color: Colors.white,),
                    label: Text(
                      controller.sortByName.value
                          ? "Sort by Caption"
                          : "Sort by Date",
                      style: const TextStyle(fontSize: 13,color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: feedList.length,
                  itemBuilder: (context, index) {
                    final item = feedList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: item.url.endsWith(".mp4") // detect if it's a video
      ? VideoPlayerWidget(videoUrl: item.url,)
      : CachedNetworkImage(
          imageUrl: item.url,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 180,
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 180,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.broken_image,
              size: 60,
              color: Colors.grey,
            ),
          ),
        ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.caption,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Uploaded on: ${item.uploadDate.toString().split(' ')[0]}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              "AI Sentiment: ${item.aiGeneratedSentiment.isEmpty ? 'Not analyzed' : item.aiGeneratedSentiment}",
                              style: TextStyle(
                                fontSize: 12,
                                color: item.aiGeneratedSentiment.isEmpty
                                    ? Colors.grey
                                    : Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: controller.isAnalyzing.value
                                    ? null
                                    : () async {
                                        await controller
                                            .analyzeSentiment(item);
                                        Get.snackbar(
                                          "AI Sentiment",
                                          item.aiGeneratedSentiment.isEmpty
                                              ? "Failed to analyze"
                                              : item.aiGeneratedSentiment,
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              Colors.deepPurple.shade400,
                                          colorText: Colors.white,
                                        );
                                      },
                                icon: const Icon(Icons.analytics_outlined,
                                    size: 16,color: Colors.white,),
                                label: const Text(
                                  "Analyze",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
