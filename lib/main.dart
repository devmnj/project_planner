import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:project_planner/new_project.dart';
import 'package:project_planner/project.dart';
import 'package:project_planner/settings.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as _MongoDB;
import 'package:cool_alert/cool_alert.dart';

final boxName = 'Projects';
final mdbName = 'projectDb';
final sboxName = 'settings';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Project>(boxName);
  await Hive.openBox<Project>('backup');
  await Hive.openBox<Settings>(sboxName);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Project Planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum ProjectFilter { Finished, Pending, Undergoing, All, None }

class _MyHomePageState extends State<MyHomePage> {
  var colStyle1 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  var rowStyle1 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow);
  ProjectFilter filter = ProjectFilter.All;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _bottomNavigationKey = GlobalKey();
  int _page = 0;

  // ignore: non_constant_identifier_names
  bool enable_Web = false;

  @override
  void dispose() {
    //   Hive.box<Project>(boxName).close();
    Hive.box<Project>(boxName).compact();
    super.dispose();
  }

  Box<Project> projectBox;
  Box<Settings> settingsBox;

  @override
  void initState() {
    try {
      super.initState();
      projectBox = Hive.box(boxName);
      settingsBox = Hive.box<Settings>(sboxName);
      if (settingsBox.keys.toList().length > 0)
        enable_Web = settingsBox.getAt(0).webEnabled;
    } on Exception catch (e) {
      // TODO
    }
  }

  Widget _buildFrontWidget(var box, int key) {
    if (box.monId == null) {
      isCloud = false;
    } else {
      isCloud = true;
    }

    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
            onTap: () {
              final foldingCellState =
                  context.findAncestorStateOfType<SimpleFoldingCellState>();
              foldingCellState?.toggleFold();
            },
            child: Container(
              color: Color(0xffc1e0f4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.rate_review,
                        size: 30,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        box.projectName,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      (isCloud
                          ? Icon(Icons.cloud_circle)
                          : Icon(Icons.cloud_off)),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          try {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => (UpdateProject(
                                          project: box,
                                          boxkey: key,
                                        ))));
                          } on Exception catch (e) {
                            // TODO
                          }
                        },
                        child: Icon(
                          Icons.mode_edit,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  bool isCloud = true;

  Widget _buildInnerWidget(var box) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            final foldingCellState =
                context.findAncestorStateOfType<SimpleFoldingCellState>();
            foldingCellState?.toggleFold();
          },
          child: Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                ColoredBox(
                  color: Colors.redAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tooltip(
                          message: 'Project Name and Description',
                          child: Icon(Icons.layers)),
                      Text(
                        box.projectName,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    box.projectDesc,
                    style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                  ),
                ),
                Container(
                  color: Colors.lightGreen,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Tooltip(
                          message: 'Assigned Person',
                          child: Icon(
                            Icons.people_outline,
                            size: 25,
                          )),
                      Tooltip(
                          message: 'Commence Date',
                          child: Icon(Icons.date_range, size: 25)),
                      Tooltip(
                          message: 'Completion Date(Expected)',
                          child: Icon(Icons.system_update, size: 25)),
                      Tooltip(
                          message: 'Project Modules',
                          child: Icon(Icons.layers, size: 25)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      box.projectAsTo,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      formatDate(box.projectAsDate, [dd, '/', mm, '/', yy]),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      formatDate(box.projectECDate, [dd, '/', mm, '/', yy]),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      box.projectModule,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  color: Colors.black87,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        box.projectStatus,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  var bb = Hive.box<Project>('backup');

  cloudBackup() async {
    try {
      if (settingsBox.getAt(0).webEnabled == true) {
        //

        var db = await _MongoDB.Db.create(
            "mongodb+srv://admin:text123@cluster0.cqnll.mongodb.net/projectdata?retryWrites=true&w=majority");
        //   mongodb+fsrv://test:<password>@cluster0.fcxa1.mongodb.net/<dbname>?retryWrites=true&w=majority
        if (await db.isConnected == false) await db.open();

        if (await db.isConnected == true) {
          var coll = db.collection('projectdocs');

          await Hive.box<Project>('backup').compact();

          await bb.deleteAll(bb.keys);
          await bb.compact();

// need to check for old entry
          // remove and update the old entry
          var rs = await coll.find();
          await rs.forEach((element) {
            var objid = element['_id'].toString();
            var id = objid.substring(10, objid.length - 2);

            Project _project = new Project(
                element['projectName'],
                element['projectDesc'],
                element['projectModule'],
                element['projectAsTo'],
                DateTime.parse(element['projectAsDate']),
                DateTime.parse(element['projectECD']),
                element['projectStatus'],
                element['projectRemark'],
                monId: id);

            bb.add(_project);
          });
          await db.close();
          return bb;
        }
      }
    } on Exception catch (e) {
      print(e);
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: Text('Connection problem')));
    }
  }

  syncToCloud() async {
    try {
      if (settingsBox.getAt(0).webEnabled == true) {
        //
        var db = await _MongoDB.Db.create(
            "mongodb+srv://admin:text123@cluster0.cqnll.mongodb.net/projectdata?retryWrites=true&w=majority");
        //   mongodb+srv://test:<password>@cluster0.fcxa1.mongodb.net/<dbname>?retryWrites=true&w=majority
        await db.open();
        if (await db.isConnected == true) {
          var coll = db.collection('projectdocs');

          List<Map<String, String>> _map;
          var map = projectBox.toMap();
          await map.forEach((key, value) {
            if (value.monId == null) {
              coll.insert({
                'projectName': value.projectName,
                'projectDesc': value.projectDesc,
                'projectAsTo': value.projectAsTo,
                'projectModule': value.projectModule,
                'projectAsDate': value.projectAsDate.toIso8601String(),
                'projectECD': value.projectECDate.toIso8601String(),
                'projectStatus': value.projectStatus,
                'projectRemark': value.projectRemarks,
                'monId': value.monId,
              });
            } else {
              _MongoDB.ObjectId objId = (_MongoDB.ObjectId.parse(value.monId));

              coll.findAndModify(query: {
                '_id': objId
              }, update: {
                'projectName': value.projectName,
                'projectDesc': value.projectDesc,
                'projectAsTo': value.projectAsTo,
                'projectModule': value.projectModule,
                'projectAsDate': value.projectAsDate.toIso8601String(),
                'projectECD': value.projectECDate.toIso8601String(),
                'projectStatus': value.projectStatus,
                'projectRemark': value.projectRemarks,
                'monId': value.monId,
              });

              // coll.update(
              //     _MongoDB.where.eq('id', value.monId),
              //     _MongoDB.modify.set('projectStatus',
              //         value.projectStatus));
            }
          });

          cloudBackup().whenComplete(() {
            var f = projectBox.keys.toList().length;
            projectBox.deleteAll(projectBox.keys);
            importFromBackup();
            if (projectBox.keys.toList().length > 0) {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.info,
                title: 'Cloud Sync',
                text: 'Cloud Sync Completed [ ' +
                    projectBox.keys.toList().length.toString() +
                    ']',
              );
            }
          });
        }
      }
    } on Exception catch (e) {
      print(e);
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: Text('Connection problems')));
    }
  }

  var backup = Hive.box<Project>('backup');

  importFromBackup() {
    try {
      if (settingsBox.getAt(0).webEnabled == true) {
        //
        int counter = 0;

        if (backup.keys.toList().length > 0) {
          //projectBox = backup;
          List<int> ke;
          var x = projectBox
              .toMap()
              .entries
              .toList()
              .where((element) => element.value.monId != null);
          backup.toMap().forEach((key, value) {
            if (value.monId.length > 4) {
              if (x.length > 0)
                x.forEach((element) {
                  if (element.value.monId == value.monId) {
                    var el = element;
                    projectBox.put(element.key, value);
                    counter++;
                  }
                });
              else {
                projectBox.add(value);
                counter++;
              }
            } else {
              projectBox.add(value);
              counter++;
            }
          });

          // projectBox.compact();
        }

        return backup;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  loadingAlert(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
    );
  }

  showAlert(BuildContext context, title, content, Function confirm,
      {CoolAlertType aType = CoolAlertType.warning}) {
    CoolAlert.show(
        onConfirmBtnTap: confirm,
        context: context,
        type: CoolAlertType.warning,
        title: title,
        text: content,
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        showCancelBtn: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable Web feature for multi user experience',
                    style: TextStyle(fontSize: 19),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Switch(
                    value: enable_Web,
                    focusColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    onChanged: (bool value) {
                      try {
                        setState(() {
                          enable_Web = false;
                          if (value == true) enable_Web = true;
                        });
                        if (settingsBox.keys.toList().length > 0)
                          settingsBox.clear();
                        settingsBox.add(new Settings(enable_Web));
                        _scaffoldKey.currentState.showSnackBar(
                            new SnackBar(content: Text('Settings Saved')));
                      } on Exception catch (e) {
                        // TODO
                      }
                    },
                  ),
                  Text(
                    'Sync changes to the Server',
                    style: TextStyle(fontSize: 19),
                  ),
                  RaisedButton(
                    child: Text('Sync to Cloud',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    color: Colors.blueAccent,
                    onPressed: () {
                      syncToCloud();
                    },
                  ),
                  RaisedButton(
                    child: Text('Backup from Cloud',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    color: Colors.green,
                    onPressed: () {
                      try {
                        cloudBackup().whenComplete(() {
                          // print('Action completed' + bb.length.toString());
                          if (bb.keys.toList().length > 0) {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: 'Cloud Backup',
                                text: 'Cloud Backup completed [ ' +
                                    bb.keys.toList().length.toString() +
                                    ' ]');
                          } else {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: 'Cloud Backup',
                              text: 'Nothing left on Cloud ',
                            );
                          }
                        });
                      } on Exception catch (e) {
                        // TODO
                      }
                      // if( box.asStream().length !=0){
                      //   //
                    },
                  ),
                  RaisedButton(
                    child: Text('Clear the Cloud',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    color: Colors.deepOrange,
                    onPressed: () {
                      dBload() async {
                        try {
                          if (settingsBox.getAt(0).webEnabled == true) {
                            //

                            var db = await _MongoDB.Db.create(
                                "mongodb+srv://admin:text123@cluster0.cqnll.mongodb.net/projectdata?retryWrites=true&w=majority");
                            //   mongodb+srv://test:<password>@cluster0.fcxa1.mongodb.net/<dbname>?retryWrites=true&w=majority
                            await db.open();
                            if (await db.isConnected == true) {
                              var coll = db.collection('projectdocs');

                              showAlert(context, 'Delete',
                                  'It will erase all data, do you want continue ?',
                                  () {
                                Navigator.pop(context);
                                db.removeFromCollection('projectdocs');
                              });

                              //  await db.close();

                            }
                          }
                        } on Exception catch (e) {
                          print(e);
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: Text('Connection problem')));
                        }
                      }

                      dBload();
                    },
                  ),
                  RaisedButton(
                      child: Text('Import from Backup',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      color: Colors.blue,
                      onPressed: () {
                        var c = importFromBackup();

                        if (c.keys.toList().length > 0) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.info,
                            title: 'Import',
                            text: 'Importing Backup completed ',
                          );
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.info,
                            title: 'Import',
                            text: 'Backup Not found, try Sync/Cloud Backup',
                          );
                        }
                      }),
                  RaisedButton(
                      child: Text('Clear all Data',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      color: Colors.yellow,
                      onPressed: () {
                        showAlert(context, 'Clear all Data',
                            'It will erase all data, do you want continue ?',
                            () {
                          projectBox.deleteAll(projectBox.keys);
                          Navigator.pop(context);
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                try {
                  if (value.compareTo("All") == 0) {
                    setState(() {
                      filter = ProjectFilter.All;
                    });
                  } else if (value.compareTo("Finished") == 0) {
                    setState(() {
                      filter = ProjectFilter.Finished;
                    });
                  } else if (value.compareTo("Undergoing") == 0) {
                    setState(() {
                      filter = ProjectFilter.Undergoing;
                    });
                  } else if (value.compareTo("Pending") == 0) {
                    setState(() {
                      filter = ProjectFilter.Pending;
                    });
                  }
                } on Exception catch (e) {
                  // TODO
                }
              },
              itemBuilder: (context) {
                return ["All", "Finished", "Undergoing", "Pending"]
                    .map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   'Projects Home Page',
              // ),

              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: projectBox.listenable(),
                      builder: (context, Box<Project> box, _) {
                        List<int> keys;
                        keys = projectBox.keys.cast<int>().toList();
                        if (filter == ProjectFilter.Finished) {
                          keys = projectBox.keys
                              .cast<int>()
                              .where((element) =>
                                  projectBox.get(element).projectStatus ==
                                  "Finished")
                              .toList();
                        } else if (filter == ProjectFilter.Pending) {
                          keys = projectBox.keys
                              .cast<int>()
                              .where((element) =>
                                  projectBox.get(element).projectStatus ==
                                  "Pending")
                              .toList();
                        } else if (filter == ProjectFilter.Undergoing) {
                          keys = projectBox.keys
                              .cast<int>()
                              .where((element) =>
                                  projectBox.get(element).projectStatus ==
                                  "Undergoing")
                              .toList();
                        }

                        return Container(
                          child: ListView.builder(
                            itemCount: keys.length,
                            itemBuilder: (_, index) {
                              final int key = keys[index];
                              final Project project = projectBox.get(key);
                              //  print('Id='+projectBox.get(key).monId);

                              return Dismissible(
                                onDismissed: (direction) {
                                  try {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      projectBox.delete(key);
                                    } else if (direction ==
                                        DismissDirection.startToEnd) {
                                      project.projectStatus = "Finished";
                                      box.put(key, project);

                                      // box1.Save();
                                    }
                                  } on Exception catch (e) {
                                    // TODO
                                    print(e);
                                  }
                                },
                                key: UniqueKey(),
                                secondaryBackground: Container(
                                  color: Colors.redAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.delete,
                                          size: 60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                background: Container(
                                    color: Colors.blue,
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            Icons.archive,
                                            size: 60,
                                          ),
                                        ),
                                        Text(
                                          'Finish',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        )
                                      ],
                                    )),
                                child: SimpleFoldingCell.create(
                                  frontWidget: _buildFrontWidget(project, key),
                                  innerWidget: _buildInnerWidget(project),
                                  cellSize: Size(
                                      MediaQuery.of(context).size.width, 60),
                                  // padding: EdgeInsets.all(15),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  borderRadius: 5,

                                  onOpen: () => print('$index cell opened'),
                                  onClose: () => print('$index cell closed'),
                                ),
                              );
                            },
                          ),
                        );
                      }))
            ],
          ),
        ),

        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          backgroundColor: Colors.blue,
          color: Colors.white70,
          buttonBackgroundColor: Colors.deepOrange,
          height: 50.0,
          onTap: (index) {
            //index=_Page;
            switch (index) {
              case 0:
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => (NewProject())));
                break;
              case 1:
                //Sync
                showAlert(context, 'Sync', 'Wanna sync to the Cloud ?', () {
                  Navigator.pop(context);
                  syncToCloud();
                });
                //syncToCloud();
                break;
              case 2:
                showAlert(context, 'Backup', 'wanna download from Cloud ?', () {
                  Navigator.pop(context);
                  cloudBackup().whenComplete(() {
                    if (bb.keys.toList().length > 0) {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          title: 'Cloud Backup',
                          text: 'Cloud Backup completed [ ' +
                              bb.keys.toList().length.toString() +
                              ' ]');
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: 'Cloud Backup',
                        text: 'Nothing left on Cloud ',
                      );
                    }
                  });
                });
                //Backup from Cloud
                break;

              case 3:
                //About
                showAboutDialog(
                    context: context,
                    applicationName: "Project Planner MongoDB Cloud app",
                    applicationVersion: "1.0.0",
                    children: [
                      Text('Developer: Manoj A.P'),
                      Text('can be reached @ manojap@outlook.com'),
                      Text('Web:' + 'http://manojap.github.io')
                    ],
                    applicationIcon: Icon(Icons.games));

                break;
            }
          },
          items: [
            GestureDetector(
              onTap: () {
                //New Project
                // Navigator.push(context,
                //     new MaterialPageRoute(builder: (context) => (NewProject())));
                setState(() {
                  _page = 0;
                });
              },
              child: Icon(
                Icons.add_box,
                size: 30,
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    //cloud Sync
                    _page = 1;
                  });
                },
                child: Icon(Icons.cloud_upload, size: 30)),
            GestureDetector(
                onTap: () {
                  //Back up to Cloud
                  setState(() {
                    _page = 2;
                  });
                },
                child: GestureDetector(
                    onTap: () {
                      //Import from the old backup
                      setState(() {
                        _page = 3;
                      });
                    },
                    child: Icon(Icons.cloud_download, size: 30))),
            GestureDetector(
              onTap: () {
                //About
                setState(() {
                  _page = 4;
                });
              },
              child: Icon(
                Icons.info,
                size: 30,
              ),
            ),
          ],
          // child: bottomNav(context),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
