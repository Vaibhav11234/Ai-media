import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/media_item_model.dart';

class DashboardController extends GetxController {
  var sortByName = true.obs;
  var imageFeed = <MediaItem>[].obs;
  var videoFeed = <MediaItem>[].obs;
  var isAnalyzing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    imageFeed.assignAll([
      MediaItem(
        caption: "The sunset looks absolutely beautiful today!",
        uploadDate: DateTime(2024, 11, 1),
        url:
            "https://images.unsplash.com/photo-1501973801540-537f08ccae7b", // Sunset
      ),
      MediaItem(
        caption: "I miss walking on this beach — such peaceful vibes.",
        uploadDate: DateTime(2024, 10, 15),
        url:
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e", // Beach
      ),
      MediaItem(
        caption: "The mountains remind me how small my worries really are.",
        uploadDate: DateTime(2024, 11, 5),
        url:
            "https://images.unsplash.com/photo-1501785888041-af3ef285b470", // Mountains
      ),
     MediaItem(
  caption: "The vibrant city skyline looks absolutely stunning at night!",
  uploadDate: DateTime(2024, 9, 20),
  url: "https://images.pexels.com/photos/313782/pexels-photo-313782.jpeg", // Working cityscape image
),
      MediaItem(
        caption: "Walking through this forest makes me feel calm and alive.",
        uploadDate: DateTime(2024, 8, 30),
        url:
            "https://images.unsplash.com/photo-1501785888041-af3ef285b470", // Forest
      ),
    ]);

    videoFeed.assignAll([
      MediaItem(
        caption:
            "This nature vlog about bees is so relaxing and educational to watch!",
        uploadDate: DateTime(2024, 11, 2),
        url:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4", // Nature video
      ),
      MediaItem(
        caption:
            "The tech documentary 'Elephant’s Dream' shows creativity ahead of its time.",
        uploadDate: DateTime(2024, 10, 25),
        url:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", // Tech/animation
      ),
      MediaItem(
        caption:
            "The animation 'Big Buck Bunny' never fails to make me smile — pure joy!",
        uploadDate: DateTime(2024, 11, 10),
        url:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", // Fun animation
      ),
      MediaItem(
        caption:
            "Watching 'Sintel' always inspires me — such emotional storytelling!",
        uploadDate: DateTime(2024, 9, 12),
        url:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", // Travel/adventure feel
      ),
      MediaItem(
        caption:
            "The short film 'Tears of Steel' gives me goosebumps every single time!",
        uploadDate: DateTime(2024, 8, 8),
        url:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", // Sci-fi/action
      ),
    ]);
  }

  void toggleSort(List<MediaItem> list) {
    sortByName.value = !sortByName.value;
    sortList(list);
  }

  void sortList(List<MediaItem> list) {
    if (sortByName.value) {
      list.sort((a, b) => a.uploadDate.compareTo(b.uploadDate));
    } else {
      list.sort((a, b) => a.caption.compareTo(b.caption));
    }
  }

  Future<void> analyzeSentiment(MediaItem item) async {
    const apiUrl =
        'https://router.huggingface.co/hf-inference/models/distilbert/distilbert-base-uncased-finetuned-sst-2-english';
    const apiToken = 'xx your token xx';

    try {
      isAnalyzing.value = true;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'inputs': item.caption}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        item.aiGeneratedSentiment = result[0][0]["label"];
        imageFeed.refresh();
        videoFeed.refresh();
      } else {
        Get.snackbar(
          "Error",
          "API failed: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF6A1B9A),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isAnalyzing.value = false;
    }
  }
}
