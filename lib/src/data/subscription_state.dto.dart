class SubscriptionStateDto {
  final bool isSubscribed;

  SubscriptionStateDto({
    required this.isSubscribed,
  });

  SubscriptionStateDto.fromJson(Map<String, dynamic> json)
      : isSubscribed = json['isSubscribed'];

  Map<String, dynamic> toJson() {
    return {'isSubscribed': isSubscribed};
  }
}
