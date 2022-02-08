class SubscriptionStatusDto {
  final bool isSubscribed;

  SubscriptionStatusDto({
    required this.isSubscribed,
  });

  SubscriptionStatusDto.fromJson(Map<String, dynamic> json)
      : isSubscribed = json['isSubscribed'];

  Map<String, dynamic> toJson() {
    return {'isSubscribed': isSubscribed};
  }
}
