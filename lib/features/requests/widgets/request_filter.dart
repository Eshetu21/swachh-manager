import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SortOption {
  newestFirst,
  oldestFirst,
  highestQuantity,
  lowestQuantity,
}

class RequestFilter extends StatefulWidget {
  final String currentStatus;
  final Function(SortOption?, DateTime?) onFilterApplied;
  final SortOption? currentSort;
  final DateTime? currentDate;

  const RequestFilter({
    super.key,
    required this.currentStatus,
    required this.onFilterApplied,
    this.currentSort,
    this.currentDate,
  });

  @override
  State<RequestFilter> createState() => _RequestFilterState();
}

class _RequestFilterState extends State<RequestFilter> {
  late SortOption? _selectedSort;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _selectedDate = widget.currentDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Options'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<SortOption>(
                isExpanded: true,
                value: _selectedSort,
                hint: const Text('Select sort option'),
                items: const [
                  DropdownMenuItem(
                    value: SortOption.newestFirst,
                    child: Text('Newest first'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.oldestFirst,
                    child: Text('Oldest first'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.highestQuantity,
                    child: Text('Highest quantity'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.lowestQuantity,
                    child: Text('Lowest quantity'),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedSort = value),
              ),
              const SizedBox(height: 16),
              const Text('Filter by date:', style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : DateFormat('MMM d, y').format(_selectedDate!),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => setState(() => _selectedDate = null),
                      ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Select'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onFilterApplied(_selectedSort, _selectedDate);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

