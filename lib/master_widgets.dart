
import 'package:flutter/material.dart';
import 'package:project_planner/main.dart';
import 'new_project.dart';

Widget bottomNav(BuildContext context) => Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              size: 45,
              color: Colors.teal,
            ),
            tooltip: 'Home',
            onPressed: (){
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => (MyApp())));
            },
          ),
          SizedBox(width: 3),
          IconButton(
            icon: Icon(Icons.add_circle, size: 45,color: Colors.teal,),
            tooltip: 'New Project',
            onPressed: (){
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => (NewProject())));
            },
          ),
          SizedBox(width: 3),
          IconButton(
            icon: Icon(Icons.verified_user, size: 45,color: Colors.teal,),
            tooltip: 'New Project',
          ),
          SizedBox(width: 3),
          IconButton(
            icon: Icon(Icons.notifications_paused, size: 45,color: Colors.teal,),
            tooltip: 'New Project',
          ),
          SizedBox(width: 3),
          IconButton(
            icon: Icon(Icons.refresh, size: 45,color: Colors.teal,),
            tooltip: 'New Project',
          ),
          SizedBox(width: 3),
        ],
      ),
    ));


