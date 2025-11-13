class MediaItem {
  final String caption;
  final DateTime uploadDate;
  final String url;
  String aiGeneratedSentiment;

  MediaItem({
    required this.caption,
    required this.uploadDate,
    required this.url,
    this.aiGeneratedSentiment = "",
  });
}
