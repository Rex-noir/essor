enum TargetOperator implements Comparable<TargetOperator> {
  greaterThanOrEqual(symbol: '>='),
  lessThanOrEqual(symbol: '<='),
  equalTo(symbol: '=');

  final String symbol;

  const TargetOperator({required this.symbol});

  static TargetOperator? fromSymbol(String value) {
    for (final op in TargetOperator.values) {
      if (op.symbol == value) {
        return op;
      }
    }
    return null;
  }

  @override
  int compareTo(TargetOperator other) => index.compareTo(other.index);

  @override
  String toString() => symbol;
}
