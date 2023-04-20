import "package:flutter/material.dart";

class Grid extends StatelessWidget {
  const Grid({super.key, required this.children, this.rowSize = 2});
  final List<Widget> children;
  final int rowSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _createRows(),
    );
  }

  List<Widget> _createRows() {
    List<Widget> rows = [];
    List<Widget> row = [];
    for (final child in children) {
      row.add(child);
      if (row.length == rowSize) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row,
        ));
        row = [];
      }
    }
    if (row.isNotEmpty) {
      rows.add(
        Row(
          children: row,
        ),
      );
    }
    return rows;
  }
}
