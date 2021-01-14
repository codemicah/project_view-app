import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_view/controllers/item.controller.dart';
import 'package:project_view/models/current_project.dart';
import 'package:project_view/models/project.dart';
import 'package:project_view/ui/progress_indicator.dart';
import 'package:project_view/ui/colors.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final projectBox = Hive.box<ProjectModel>("project");

  final currentProjectBox = Hive.box<CurrentProject>("current_project");

  CurrentProject _defaultProject = CurrentProject(
    id: 0,
    owner: -1,
    name: "Project",
    code: 0000
  );

  final dropDownText = ValueNotifier<String>("Project");

  void updateCurrentProject(CurrentProject project) async {
    progressIndicator.Loading(text: "Please wait", context: context);

    currentProjectModel.addProject(project);

    await item.getItems(currentProjectBox.get(0).code);

    Navigator.pop(context);
  }

  final _containerKey = GlobalKey();

  // Project currentProject;
  @override
  void initState() {
    // update current project on signin
    projectBox.keys.length > 0 &&
    currentProjectBox.get(0) == null?
    currentProjectBox.put(0, CurrentProject(
      id: projectBox.get(0).id,
      name: projectBox.get(0).name,
      owner: projectBox.get(0).owner,
      code: projectBox.get(0).code
    )) : null;
    dropDownText.value = currentProjectBox.get(0, defaultValue: _defaultProject).name;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      key: _containerKey,
      decoration: BoxDecoration(
          color: primaryColor
      ),
      child: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.account_circle, color: plainWhite),
                    onPressed: () => Navigator.pushNamed(context, "/profile"),
                    padding: EdgeInsets.zero,
                  )
                ],
              ),
              ValueListenableBuilder(
                valueListenable: dropDownText,
                builder: (_, value, __) => DropdownButtonHideUnderline(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 8, 0),
                      child: DropdownButton<ProjectModel>(
                        isDense: true,
                        iconSize: 35,
                        isExpanded: true,
                        elevation: 0,
                        style: TextStyle().copyWith(
                            color: plainWhite,
                            fontSize: 18,
                            fontFamily: "SFProText"),
                        dropdownColor: primaryColor,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        hint: Align(
                          child: Text(dropDownText.value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          alignment: Alignment.centerLeft,
                        ),
                        onChanged: (ProjectModel project) {
                            dropDownText.value = project.name;
                            updateCurrentProject(CurrentProject(
                                id: project.id,
                                code: project.code,
                                owner: project.owner,
                                name: project.name));
                        },
                        items: projectBox.values.toList()
                            .map((project) => DropdownMenuItem(
                                  value: project,
                                  child: ListTile(
                                      title: Text(
                                        "${project.name} (${project.code})",
                                        style: TextStyle().copyWith(
                                            color: plainWhite, fontSize: 20.0),
                                      ),
                                      trailing: PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: plainWhite,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            enabled: currentProjectBox.get(0).code == project.code ? false : true,
                                              child: FlatButton.icon(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: red,
                                                  ),
                                                  label: Text("Delete project"),
                                                  onPressed: currentProjectBox.get(0).code != project.code ? () async {
                                                    projectBox.deleteAt(projectBox.values.toList().indexOf(project));
                                                    Navigator.pop(context);
                                                  } :
                                                      null
                                                  )),
                                          PopupMenuItem(
                                              child: FlatButton.icon(
                                                  icon: Icon(
                                                    Icons.content_copy,
                                                    color: secondaryColor,
                                                  ),
                                                  label: Text("Copy code"),
                                                  onPressed: () {}))
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
