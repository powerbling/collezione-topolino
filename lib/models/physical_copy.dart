enum PhysicalCopyCondition {
  brandNew,
  perfect,
  good,
  notGood,
  bad,
}

String conditionString(PhysicalCopyCondition condition) {
  const stringMap = {
    PhysicalCopyCondition.brandNew: "Nuovo",
    PhysicalCopyCondition.perfect: "Perfetto",
    PhysicalCopyCondition.good: "Buono",
    PhysicalCopyCondition.notGood: "Non buono",
    PhysicalCopyCondition.bad: "Rovinato",
  };

  return stringMap[condition]!;
}

class PhysicalCopy {
  final int? id;
  final int number;
  final String reprint;
  final PhysicalCopyCondition condition;
  final DateTime dateAdded;

  PhysicalCopy({
    this.id,
    required this.number,
    reprint,
    required this.condition,
    required this.dateAdded,
  }) : reprint = reprint ?? "A";

  // From map constructor
  factory PhysicalCopy.fromMap(Map<String, dynamic> map) => PhysicalCopy(
        id: map['id'],
        number: map['number'],
        reprint: map['reprint'],
        // Parse condition saved as int
        condition: PhysicalCopyCondition.values
            .firstWhere((e) => e.index == map['condition']),
        // Saved as milliseconds for serializability
        dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded']),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'reprint': reprint,
      // Use the index (PhysicalCopyCondition enum is not serializable)
      'condition': condition.index,
      // As milliseconds (easier serialization)
      'dateAdded': dateAdded.millisecondsSinceEpoch,
    };
  }
}
