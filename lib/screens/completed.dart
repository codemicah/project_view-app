import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/models/completed.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_view/controllers/item.controller.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/controllers/item.controller.dart';
import 'package:project_view/ui/constants.dart';

final completedItemBox = Hive.box<CompletedItem>("completed");
final currentProjectBox = Hive.box<CurrentProject>("current_project");

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height - appBarHeight - bottomNavHeight,
      child: RefreshIndicator(
        displacement: 0,
        onRefresh: () {
          Future<void> refresh() async {
            await item.getItems(currentProjectBox.get(0).code, context);
          }

          return refresh();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ValueListenableBuilder(
              valueListenable: completedItemBox.listenable(),
              builder: (context, _, __) => DataTable(
                  headingTextStyle: TextStyle().copyWith(
                      fontWeight: FontWeight.w600, color: Colors.grey[800]),
                  dividerThickness: 3,
                  showBottomBorder: true,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Item",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.3,
                      ),
                    ),
                    DataColumn(
                        label: Text("Price",
                            textAlign: TextAlign.center, textScaleFactor: 1.3),
                        numeric: true),
                    DataColumn(
                        label: Text(
                          "Quantity",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.3,
                        ),
                        numeric: true),
                  ],
                  rows: completedItemBox.values
                      .map((e) => DataRow(cells: [
                            DataCell(Text("${e.item}")),
                            DataCell(Text("${e.price}")),
                            DataCell(Text("${e.quantity}"))
                          ]))
                      .toList()
                  // List<DataRow>.generate(
                  //     completedItemBox.keys.toList().length, (index) {
                  //   print(index);
                  //   return DataRow(cells: [
                  //     DataCell(Text("${completedItemBox.get(index).item}")),
                  //     DataCell(Text("${completedItemBox.get(index).price}")),
                  //     DataCell(Text("${completedItemBox.get(index).quantity}"))
                  //   ]);
                  // })
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// class Completed extends StatefulWidget {
//   @override
//   _CompletedState createState() => _CompletedState();
// }

// //MediaQuery.of(context).size.height - topBarHeight - bottomNavHeight - MediaQuery.of(context).padding.top,
// class _CompletedState extends State<Completed> {
//   @override
//   Widget build(BuildContext context) {

//   }
// }
