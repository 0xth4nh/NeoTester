// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'back_end/utils.dart';
import 'back_end/Test.dart';
import 'dart:collection';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'screens/helper_screens/DirectionPage.dart';
import 'theme/app_theme.dart';

//flutter run --no-sound-null-safety
// variables
const double pi = 3.1415926535897932;
const double e = 2.718281828459045;

String result = ""; // True or False with Real Answer
String eval = ""; // result of
var curTestJSON; //storing the current question file under the JASON format
int cur = 0; // current question ID
var q;
var choice; // array of multiple choices value for question Type 0

var a = 0;
//variables
const String question_file = 'assets/test.json'; //data file

/// stores course list for SelectCoursePage (format form )
var courseList;

/// stores unit list for SelectUnitPage
var unitList;

/// current question test file
var test_file;

/// a Question object that stores the current question of the test
var currentQ;

/// Give feedback about answer after submitting
var resultDisplay = " ";

///button submit or next
var submitButtonText = "Submit";

///false: submit (choosing an answer for a question)
///true: next (already submit, waiting for the next question)
var hasSubmitted = false;

/// A map saving all the variable and its corresponding value
var varSave = new Map();

///Number of questions for the current test
var questionNum;

/// A list that keeps track of progress of all tests
var testProgressList;

/// a list that keeps track of progress of all comm=pleted test
var completeTestList;

/// A Test object that keeps track of progress of the current test
var currentTest;

/// current chosen course after SelectCoursePage
var currentCourse;

/// current unit list according to the curren chosen course (currentCourse)
var currentUnitList;

/// A queue that stores the remaining question index that is left in the current test
Queue<int> questionOrder = new Queue<int>(); //current question order

/// variable to determine if online or not
var isOnline;

/// variable to determine if it is first time or not
var isFirstTime;

///
var initialPage;

/// Test DIrectory
var testDirectory = '/Tests';

/// student name;
var studentName = "";

/// Document directory
var appDocPath;

Random random = new Random();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //checking devices is phone or tablets, so that we can block the rotation later
  if (getDeviceType() == "phone") {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  //internet check
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isOnline = true;
    }
  } on SocketException catch (_) {
    isOnline = false;
  }

  //first time check
  checkFirstTime().then((bool result) {
    isFirstTime = result;
    // directing page
    if (isFirstTime == true) {
      if (isOnline == false) {
        initialPage = "ReconnectPage";
      } else {
        initialPage = "UpdatePage";
      }
    } else {
      if (isOnline == true) {
        initialPage = "UpdatePage";
      } else {
        initialPage = "HomePage";
      }
    }

    print(isFirstTime);
    print(isOnline);

    print(initialPage);
  });

  //setting up application directory
  Directory appDocDir = await getApplicationDocumentsDirectory();
  appDocPath = appDocDir.path;

  //Read in the progress file
  final progressFile = File('$appDocPath/progress.txt');

  // update progress file (no need for first time)
  if (progressFile.existsSync()) {
    //read the progress file + change from Future<Test<List>> to Test<List>
    readProgress().then((List<Test> value) {
      testProgressList = value;
    });
  } else {
    progressFile.create();
    testProgressList = List<Test>.empty(growable: true);
  }

  // update completed test file (no need for first time)
  final completeRecordFile = File('$appDocPath/complete.txt');
  if (completeRecordFile.existsSync()) {
    loadCompleteTest().then((List<Test> value) {
      completeTestList = value;
    });
  } else {
    completeRecordFile.create();
    completeTestList = <Test>[];
  }

  importMathParser();

  // run App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'WardTester',
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => DirectionPage(),
      },
    );
  }
}
