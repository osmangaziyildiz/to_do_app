import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/task_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          query.isEmpty ? null : query = '';
        },
        child: Container(
          padding: const EdgeInsets.only(right: 5),
          child: const Text('clear').tr(),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.amber,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask.where(
      (taskElement) {
        if (taskElement.name.toLowerCase().contains(query.toLowerCase())) {
          return true;
        }
        return false;
      },
    ).toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              var searchedTask = filteredList[index];
              return TaskItem(task: searchedTask);
            },
          )
        : Center(
            child: const Text('searc_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
