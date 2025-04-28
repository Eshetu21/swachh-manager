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
  final Function(String, SortOption?, DateTimeRange?) onFilterApplied;
  final VoidCallback onFiltersChanged;

  const RequestFilter({
    super.key,
    required this.currentStatus,
    required this.onFilterApplied,
    required this.onFiltersChanged,
  });

  @override
  State<RequestFilter> createState() => _RequestFilterState();
}

class _RequestFilterState extends State<RequestFilter> {
  SortOption? _selectedSort;
  DateTime? _selectedDate;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _applyFilters() {
    DateTimeRange? range = _selectedDate != null
        ? DateTimeRange(start: _selectedDate!, end: _selectedDate!)
        : null;
    widget.onFilterApplied(widget.currentStatus, _selectedSort, range);
    widget.onFiltersChanged();
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _selectedSort = null;
      _selectedDate = null;
      _quantityController.clear();
    });
    widget.onFilterApplied(widget.currentStatus, null, null);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Requests'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<SortOption>(
              value: _selectedSort,
              decoration: const InputDecoration(
                labelText: 'Sort By',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: SortOption.newestFirst,
                  child: Text('Newest First'),
                ),
                DropdownMenuItem(
                  value: SortOption.oldestFirst,
                  child: Text('Oldest First'),
                ),
                DropdownMenuItem(
                  value: SortOption.highestQuantity,
                  child: Text('Highest Quantity'),
                ),
                DropdownMenuItem(
                  value: SortOption.lowestQuantity,
                  child: Text('Lowest Quantity'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSort = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : DateFormat('MMM d, y').format(_selectedDate!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity Range (e.g., 10-20)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearFilters,
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: _applyFilters,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

