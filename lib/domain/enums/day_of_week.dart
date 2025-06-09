enum DayOfWeek implements Comparable<DayOfWeek> {
  monday(shortName: 'Mo', fullName: 'Monday', order: 0),
  tuesday(shortName: 'Tu', fullName: 'Tuesday', order: 1),
  wednesday(shortName: 'We', fullName: 'Wednesday', order: 2),
  thursday(shortName: 'Th', fullName: 'Thursday', order: 3),
  friday(shortName: 'Fr', fullName: 'Friday', order: 4),
  saturday(shortName: 'Sa', fullName: 'Saturday', order: 5),
  sunday(shortName: 'Su', fullName: 'Sunday', order: 6);

  const DayOfWeek({
    required this.shortName,
    required this.fullName,
    required this.order,
  });

  final String shortName;
  final String fullName;
  final int order;

  @override
  int compareTo(DayOfWeek other) => order - other.order;
}
