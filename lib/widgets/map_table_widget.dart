import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapTableWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const MapTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: data.entries.map((entry) {
        return TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: entry.value.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Copied "${entry.value.toString()}"')),
                      );
                    },
                    child: Text(entry.value.toString())),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
