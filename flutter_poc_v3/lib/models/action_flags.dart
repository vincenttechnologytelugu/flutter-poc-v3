class ActionFlags {
  final bool? remove;
  final bool? markAsSold;
  final bool? markAsInactive;
  final bool? publish;
  final bool? edit;
  final bool? featured;

  ActionFlags({
    this.remove,
    this.markAsSold,
    this.markAsInactive,
    this.publish,
    this.edit,
    this.featured,
  });

  factory ActionFlags.fromJson(Map<String, dynamic> map) {
    return ActionFlags(
      remove: map['remove'],
      markAsSold: map['mark_as_sold'],
      markAsInactive: map['mark_as_inactive'],
      publish: map['publish'],
      edit: map['edit'],
      featured: map['featured'],
    );
  }
}
