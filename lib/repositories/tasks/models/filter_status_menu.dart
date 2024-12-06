import 'package:flutter/material.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

class FilterStatusMenu extends StatefulWidget {
  final Function(List<TaskStatus>) onFilterChanged;

  const FilterStatusMenu({required this.onFilterChanged, super.key});

  @override
  State<FilterStatusMenu> createState() => _FilterStatusMenuState();
}

class _FilterStatusMenuState extends State<FilterStatusMenu> {
  final List<TaskStatus> selectedStatuses = [];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'inProcess',
          child: StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                title: const Text('In Process'),
                value: selectedStatuses.contains(TaskStatus.inProcess),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedStatuses.add(TaskStatus.inProcess);
                    } else {
                      selectedStatuses.remove(TaskStatus.inProcess);
                    }
                    widget.onFilterChanged(selectedStatuses);
                  });
                },
              );
            },
          ),
        ),
        PopupMenuItem<String>(
          value: 'completed',
          child: StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                title: const Text('Completed'),
                value: selectedStatuses.contains(TaskStatus.completed),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedStatuses.add(TaskStatus.completed);
                    } else {
                      selectedStatuses.remove(TaskStatus.completed);
                    }
                    widget.onFilterChanged(selectedStatuses);
                  });
                },
              );
            },
          ),
        ),
        PopupMenuItem<String>(
          value: 'overdued',
          child: StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                title: const Text('Overdued'),
                value: selectedStatuses.contains(TaskStatus.overdued),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedStatuses.add(TaskStatus.overdued);
                    } else {
                      selectedStatuses.remove(TaskStatus.overdued);
                    }
                    widget.onFilterChanged(selectedStatuses);
                  });
                },
              );
            },
          ),
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(153, 159, 249, 1), // purp
        ),
        padding: const EdgeInsets.all(16),
        child: const Icon(
          Icons.filter_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}
