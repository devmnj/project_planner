import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:project_planner/main.dart';
import 'package:project_planner/project.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:hive/hive.dart';

dateFormater(String stringDate) {
  try {
    var sp = stringDate.split('/');
    var date = DateTime(int.parse(sp[2]), int.parse(sp[1]), int.parse(sp[0]));
    return date;
  } on Exception catch (e) {
    return DateTime.parse(stringDate);
  }
}

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() {
    return new _NewProjectState();
  }
}

class _NewProjectState extends State<NewProject> {
  String status="Pending"  ;

  final projectName = TextEditingController();
  final projectDesc = TextEditingController();
  final projectAsDate = TextEditingController();
  final projectAsTo = TextEditingController();
  final projectModule = TextEditingController();
  final projectECD = TextEditingController();
  final projectRemarks = TextEditingController();

  final _globalKey = GlobalKey<ScaffoldState>();

  //Error checking

  bool nameError = false;
  bool asDateError = false;
  bool asExDateError = false;
  bool asToError = false;

  clearBoxes() {
    projectName.clear();
    projectDesc.clear();
    projectAsDate.clear();
    projectAsTo.clear();
    projectModule.clear();
    projectECD.clear();
    projectRemarks.clear();

    status="Pending";
    setState(() {

      nameError = false;
      asDateError = false;
      asExDateError = false;
      asToError = false;
    });
  }

  //Styles
  final inStyle = TextStyle(fontSize: 18, color: Colors.green);
  Box<Project> projectBox;

  @override
  void initState() {
    super.initState();
    projectBox = Hive.box(boxName);
  }

  @override
  void disppose() {
    Hive.box(boxName).compact();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        bottomNavigationBar: BottomAppBar(),
        appBar: AppBar(
          title: Text('New Project'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  style: inStyle,
                  controller: projectName,
                  decoration: InputDecoration(
                    hintText: 'eg :database Project',
                    labelText: 'Name',
                    errorText: nameError ? 'Name can\'t be empty' : null,
                    // helperText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    style: inStyle,
                    controller: projectDesc,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'eg :SQL Server project',
                      // helperText: 'Description',

                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    style: inStyle,
                    controller: projectModule,
                    decoration: InputDecoration(
                      labelText: 'Module',
                      hintText: 'eg :Schema definition',
                      // helperText: 'Name of the module , if any',
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  controller: projectAsTo,
                  decoration: InputDecoration(
                      labelText: 'Developer',
                      hintText: 'eg: John',
                      // helperText: 'Assigned Person',
                      border: OutlineInputBorder(),
                      errorText:
                          asToError ? 'Developer name can\'t be Empty' : null),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  inputFormatters: [DateInputFormatter()],
                  controller: projectAsDate,
                  decoration: InputDecoration(
                    labelText: 'Assigned Date',
                    hintText: 'eg :12/1/2020',
                    // helperText: 'Assigned date',
                    border: OutlineInputBorder(),
                    errorText: asDateError ? 'Date can\'t be empty' : null,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  controller: projectECD,
                  inputFormatters: [DateInputFormatter()],
                  decoration: InputDecoration(
                    errorText: asExDateError ? 'Date can\'t be empty' : null,
                    labelText: 'Expected Completion Date',
                    hintText: 'eg :12/12/21',
                    // helperText: 'Expected completion date',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ToggleSwitch(
                  labels: ['Pending', 'Finished', 'UnderGoing'],
                  activeBgColors: [
                    Colors.deepOrange,
                    Colors.green,
                    Colors.redAccent
                  ],
                  minWidth: 120,
                  fontSize: 18,
                  onToggle: (index) {
                    switch (index) {
                      case 0:
                        status ="Pending";
                        break;
                      case 1:
                        status = "Fnished";
                        break;
                      case 2:
                        status = "Undergoing";
                        break;
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  controller: projectRemarks,
                  decoration: InputDecoration(
                    labelText: 'Remarks/Note',
                    hintText: 'eg :Undergoing minor changes',
                    // helperText: 'Remarks , if any',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: Colors.blueAccent,
                        splashColor: Colors.deepOrange,
                        hoverColor: Colors.green,
                        focusColor: Colors.lightGreenAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        onPressed: () {
                          try {
                            setState(() {
                              projectName.text.isEmpty
                                  ? nameError = true
                                  : nameError = false;
                              projectAsTo.text.isEmpty
                                  ? asToError = true
                                  : asToError = false;
                              projectAsDate.text.isEmpty
                                  ? asDateError = true
                                  : asDateError = false;
                              projectECD.text.isEmpty
                                  ? asExDateError = true
                                  : asExDateError = false;
                                                         });

                            if (nameError == false &&
                                asDateError == false &&
                                asExDateError == false &&
                                asToError == false
                            ) {
                              var _project = new Project(
                                  projectName.text,
                                  projectDesc.text,
                                  projectModule.text,
                                  projectAsTo.text,
                                  dateFormater(projectAsDate.text),
                                  dateFormater(projectECD.text),
                                  status,
                                  projectRemarks.text);
                              projectBox.add(_project);
                              var info = SnackBar(
                                content: Text('Project Saved'),
                              );
                              _globalKey.currentState.showSnackBar(info);
                              clearBoxes();
                            } else {
                              _globalKey.currentState.showSnackBar(new SnackBar(
                                  content: Text('Please correct the errors')));
                            }
                          } catch (e) {
                            print(e);
                          }
                        }),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Colors.yellowAccent,
                      splashColor: Colors.lightGreen,
                      onPressed: () {
                        try {
                          _globalKey.currentState.showSnackBar(new SnackBar(
                              content: Text(
                            'This will clear the screen',
                            style: TextStyle(fontSize: 18),
                          )));
                          clearBoxes();
                        } catch (e) {}
                      },
                      hoverColor: Colors.green,
                      focusColor: Colors.lightGreenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Reset',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Colors.deepOrange,
                      splashColor: Colors.lightGreen,
                      onPressed: () {
                        try {
                          Navigator.pop(context);
                        } catch (e) {}
                      },
                      hoverColor: Colors.green,
                      focusColor: Colors.lightGreenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateProject extends StatefulWidget {
  final Project project;
  final int boxkey;

  const UpdateProject({Key key, this.project, this.boxkey}) : super(key: key);

  @override
  _UpdateProjectState createState() {
    try {} on Exception catch (e) {
      // TODO
    }
    return new _UpdateProjectState(project, boxkey);
  }
}

class _UpdateProjectState extends State<UpdateProject> {
  final Project currentProject;
  final int bkey;
   int initialStatinex=0;
  String status;
  final projectName = TextEditingController();
  final projectDesc = TextEditingController();
  final projectAsDate = TextEditingController();
  final projectAsTo = TextEditingController();
  final projectModule = TextEditingController();
  final projectECD = TextEditingController();
  final projectRemarks = TextEditingController();

  final _globalKey = GlobalKey<ScaffoldState>();

  //Error checking

  bool nameError = false;
  bool asDateError = false;
  bool asExDateError = false;
  bool asToError = false;

  _UpdateProjectState(this.currentProject, this.bkey);

  //Styles
  final inStyle = TextStyle(fontSize: 18, color: Colors.green);
  Box<Project> projectBox;

  @override
  void disppose() {
    Hive.box(boxName).compact();
    super.dispose();
  }

  @override
  void initState() {
    try {
      super.initState();
      projectBox = Hive.box(boxName);

      //loading project for editing
      this.projectName.text = currentProject.projectName;
      this.projectDesc.text = currentProject.projectDesc;
      this.projectModule.text = currentProject.projectModule;
      initialStatinex=0;
      status= currentProject.projectStatus;
      switch(currentProject.projectStatus){
        case "Finished":
          initialStatinex=1;

          break;
        case "Pending":
          initialStatinex=0;

          break;
        case "Undergoing":
          initialStatinex=2;

          break;
      }
      this.projectAsTo.text = currentProject.projectAsTo;
      this.projectAsDate.text =
          formatDate(currentProject.projectAsDate, [dd, '/', mm, '/', yyyy]);
      this.projectECD.text =
          formatDate(currentProject.projectECDate, [dd, '/', mm, '/', yyyy]);
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        bottomNavigationBar: BottomAppBar(),
        appBar: AppBar(
          title: Text('Update Project'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  style: inStyle,
                  controller: projectName,
                  decoration: InputDecoration(
                    hintText: 'eg :database Project',
                    labelText: 'Name',
                    errorText: nameError ? 'Name can\'t be empty' : null,
                    // helperText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    style: inStyle,
                    controller: projectDesc,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'eg :SQL Server project',
                      // helperText: 'Description',

                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    style: inStyle,
                    controller: projectModule,
                    decoration: InputDecoration(
                      labelText: 'Module',
                      hintText: 'eg :Schema definition',
                      // helperText: 'Name of the module , if any',
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  controller: projectAsTo,
                  decoration: InputDecoration(
                      labelText: 'Developer',
                      hintText: 'eg: John',
                      // helperText: 'Assigned Person',
                      border: OutlineInputBorder(),
                      errorText:
                          asToError ? 'Developer name can\'t be Empty' : null),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  inputFormatters: [DateInputFormatter()],
                  controller: projectAsDate,
                  decoration: InputDecoration(
                    labelText: 'Assigned Date',
                    hintText: 'eg :12/1/2020',
                    // helperText: 'Assigned date',
                    border: OutlineInputBorder(),
                    errorText: asDateError ? 'Date can\'t be empty' : null,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  controller: projectECD,
                  inputFormatters: [DateInputFormatter()],
                  decoration: InputDecoration(
                    errorText: asExDateError ? 'Date can\'t be empty' : null,
                    labelText: 'Expected Completion Date',
                    hintText: 'eg :12/12/21',
                    // helperText: 'Expected completion date',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 5,
                ),
                ToggleSwitch(
                  labels: ['Pending', 'Finished', 'Undergoing'],
                  initialLabelIndex: initialStatinex,
                  activeBgColors: [
                    Colors.red,
                    Colors.green,
                    Colors.cyan
                  ],
                  minWidth: 120,
                  fontSize: 18,
                  onToggle: (index) {
                    switch (index) {
                      case 0:
                        status = "Pending";
                        break;
                      case 1:
                        status = "Finished";
                        break;
                      case 2:
                        status = "Undergoing";
                        break;
                    }
                  },
                ),


                 SizedBox(
                  height: 5,
                ),
                TextField(
                  style: inStyle,
                  controller: projectRemarks,
                  decoration: InputDecoration(
                    labelText: 'Remarks/Note',
                    hintText: 'eg :Undergoing minor changes',
                    // helperText: 'Remarks , if any',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: Colors.blueAccent,
                        splashColor: Colors.deepOrange,
                        hoverColor: Colors.green,
                        focusColor: Colors.lightGreenAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        onPressed: () {
                          try {
                            setState(() {
                              projectName.text.isEmpty
                                  ? nameError = true
                                  : nameError = false;
                              projectAsTo.text.isEmpty
                                  ? asToError = true
                                  : asToError = false;
                              projectAsDate.text.isEmpty
                                  ? asDateError = true
                                  : asDateError = false;
                              projectECD.text.isEmpty
                                  ? asExDateError = true
                                  : asExDateError = false;
                                                           });

                            if (nameError == false &&
                                asDateError == false &&
                                asExDateError == false &&
                                asToError == false  ) {
                              var _project = new Project(
                                  projectName.text,
                                  projectDesc.text,
                                  projectModule.text,
                                  projectAsTo.text,
                                  dateFormater(projectAsDate.text),
                                  dateFormater(projectECD.text),
                                  status ,
                                  projectRemarks.text

                              );
                              _project.monId=projectBox.get(bkey).monId;
                              projectBox.put(bkey, _project);

                            }
                            var info = SnackBar(
                              content: Text('Project Updated'),
                            );

                            _globalKey.currentState.showSnackBar(info);
                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                          }
                        }),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Colors.yellowAccent,
                      splashColor: Colors.lightGreen,
                      onPressed: () {
                        try {
                          showAlertDialog(BuildContext context) {
                            // set up the button
                            Widget yesButton = FlatButton(
                              child: Text("Yes"),
                              onPressed: () {
                                projectBox.delete(bkey);
                                Navigator.pop(context);
                                Navigator.pop(_globalKey.currentContext);
                              },
                            );

                            Widget noButton = FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text("Delete"),
                              content:
                                  Text("Do you wanna delete the Project ?"),
                              actions: [
                                yesButton,
                                noButton,
                              ],
                            );
                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }

                          showAlertDialog(context);
                        } catch (e) {}
                      },
                      hoverColor: Colors.green,
                      focusColor: Colors.lightGreenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Colors.deepOrange,
                      splashColor: Colors.lightGreen,
                      onPressed: () {
                        try {
                          Navigator.pop(context);
                        } catch (e) {}
                      },
                      hoverColor: Colors.deepOrange,
                      focusColor: Colors.lightGreenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
