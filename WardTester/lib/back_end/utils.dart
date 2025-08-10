import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:trying/back_end/question.dart';
import 'dart:convert';
import 'parsers/math_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'Test.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var MC = 0;
var FR = 1;
var RFR = 2;
var questionType = ["MC", "FR", "RFR"];

Future<LinkedHashMap<String, dynamic>> readFile(String question_file) async {
  final String response = await rootBundle.loadString(question_file);
  return json.decode(response);
}

Question getNextQuestion(var data, int cur) {
  var currentQuestion = data.keys.elementAt(cur);
  var id = data[currentQuestion]["questionID"];
  var type = data[currentQuestion]["QuestionType"];
  var topic = data[currentQuestion]["QuestionTopic"];
  var question = data[currentQuestion]["Question"];
  var imagePath = "";
  if (data[currentQuestion]["ImagePath"] != null) {
    imagePath = data[currentQuestion]["ImagePath"];
  }

  if (type == MC) {
    // MC Question
    var answer = data[currentQuestion]["Answer"];
    var choices = data[currentQuestion]["Choices"];

    print("MC Answer: $answer");
    return new MCQuestion(
        id, type, topic, question, choices, answer, imagePath);
  } else if (type == FR) {
    // FR Question
    var answers = data[currentQuestion]["Answers"];

    print("FR Answer: $answers");
    return new FRQuestion(id, type, topic, question, answers, imagePath);
  } else {
    // Random Free Response Question
    var variables = data[currentQuestion]["Variables"];
    var equations = data[currentQuestion]["Equations"];
    var answerEquation = data[currentQuestion]["Answers"][0];

    RFRQuestion ques = new RFRQuestion(id, type, topic, question, variables,
        equations, answerEquation, imagePath);
    print("FRQ Answer: ${ques.getAnswerString()}");

    return ques;
  }
}

void submitPressed(bool isCorrect) {
  if (isCorrect) {
    resultDisplay = "This is correct!";
    questionOrder.removeFirst();
    currentTest.incrementAttempt();
  } else {
    resultDisplay = "The correct answer is: ${currentQ.getAnswerString()}";
    questionOrder.add(questionOrder.first);
    questionOrder.removeFirst();
    currentTest.incrementAttempt();
  }
  submitButtonText = "Next";
  hasSubmitted = !hasSubmitted;
}

Future startTest(String course, String unit) async {
  String currentTestName = "${course}:${unit}";

  /// Use the string to see if the test exists in the progress list
  /// If it does not exist make a new test.
  Test findTest(String name) =>
      testProgressList.firstWhere((test) => (test.getName() == name),
          orElse: () => Test.nullOne());
  currentTest = findTest(currentTestName);

  // New test started
  if (currentTest.getName() == "null") {
    String filePath = "$appDocPath${testDirectory}/${course}/${unit}.txt";
    var questionFile = File(filePath);
    String questionString = await questionFile.readAsString();
    test_file = jsonDecode(questionString);

    // Write test file to progress folder create new test progress
    writeProgressTestFile(course, unit);
    newTestProgress(unit);
  }
  // Resume test in progress (pull saved file in case new file is updated and different)
  else {
    String progressFilePath = "$appDocPath/Progress/${course}/${unit}.txt";
    var questionFile = File(progressFilePath);
    String questionString = await questionFile.readAsString();
    test_file = jsonDecode(questionString);

    questionOrder = currentTest.getQuestionOrder();
  }

  // set the first question
  currentQ = getNextQuestion(test_file, questionOrder.first);
  //add the deivice directories for image , if null no need to add
  if (currentQ.getImagePath() != "") {
    currentQ.setImagePath('$appDocPath/Image/' + currentQ.getImagePath());
  }
}

void newTestProgress(String unit) {
  //create a random question order based on the number of question in the test
  questionOrder = new Queue();

  //total number of question
  questionNum = test_file.keys.length;
  print("Num Questions: " + questionNum.toString());

  var list = new List<dynamic>.generate(questionNum, (i) => i);
  list = shuffle(list);
  for (int i = 0; i < questionNum; i++) {
    questionOrder.add(list.elementAt(i));
  }

  //create a new Test Object
  String currentTestName;
  if (unit != '') {
    currentTestName = "${currentCourse}:${unit}";
  } else {
    currentTestName = currentTest.getName();
  }
  DateTime now = DateTime.now();
  currentTest =
      new Test(currentTestName, questionOrder, now, now, questionNum, 0);

  //update progress
  saveProgress(currentTest, testProgressList);
}

Future restartUnit() async {
  removeProgress(currentTest, testProgressList).then((List<Test> value) {
    testProgressList = value;
  });
  newTestProgress('');
  // set the first question
  currentQ = getNextQuestion(test_file, questionOrder.first);
  //add the deivice directories for image , if null no need to add
  if (currentQ.getImagePath() != "") {
    currentQ.setImagePath('$appDocPath/Image/' + currentQ.getImagePath());
  }
}

bool nextPressedIsMoreQuestions() {
  cur = cur + 1;
  resultDisplay = "";
  submitButtonText = "Submit";
  hasSubmitted = !hasSubmitted;

  if (questionOrder.isNotEmpty) {
    currentQ = getNextQuestion(test_file, questionOrder.first);

    //add the imagepath for next question display
    if (currentQ.getImagePath() != "") {
      currentQ.setImagePath("$appDocPath/Image/" + currentQ.getImagePath());
    }

    //save the progress
    currentTest.setQuestionOrder(questionOrder);
    saveProgress(currentTest, testProgressList).then((List<Test> value) {
      testProgressList = value;
    });

    return true;
  } else {
    // set the end time for the test + save progress
    currentTest.setTimeEnd(DateTime.now());
    currentTest.setQuestionOrder(questionOrder);

    saveCompleteTest(currentTest, completeTestList).then((List<Test> value) {
      completeTestList = value;
    });

    removeProgress(currentTest, testProgressList).then((List<Test> value) {
      testProgressList = value;
    });

    //Reset the index of current quesion for the next test
    cur = 0;
    return false;
  }
}

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

Future<List> downloadTests() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  //setting up back4app ID address
  await dotenv.load(fileName: "../.env");
  final keyApplicationId = dotenv.env['KEY_APPLICATION_ID'];
  final keyClientKey = dotenv.env['KEY_CLIENT_KEY'];

  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId!, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  QueryBuilder<ParseObject> queryFile =
      QueryBuilder<ParseObject>(ParseObject('JSON'));
  final ParseResponse apiResponse = await queryFile.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

// Getting device type: return phone and tablet
String getDeviceType() {
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}

//downloadFile and store it in a correct directories using Dio
Future<File?> downloadFileImage(String url, String name) async {
  final file = File('$appDocPath/Image/$name');

  final response = await Dio().get(url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: Duration.zero,
      ));

  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();

  return file;
}

/// Save the progress to the current file
Future<List<Test>> saveProgress(var currentTest, var currentTestList) async {
  //initialize file path
  final progressFile = File('$appDocPath/progress.txt');

  //add the new test progress into the current testList
  currentTestList.add(currentTest);

  //remove the second test with the same name
  //TODO: think of a better efficient way
  var seen = Set<String>();
  List<dynamic> uniqueTest =
      currentTestList.where((test) => seen.add(test.getName())).toList();
  List<Test> list = uniqueTest.cast<Test>();

  //log down the progress file
  progressFile.writeAsStringSync(jsonEncode(uniqueTest));

  return list;
}

///This function is used when a test is completed and needed to be remove from current test.
Future<List<Test>> removeProgress(var currentTest, var currentTestList) async {
  //initialize file path
  final progressFile = File('$appDocPath/progress.txt');
  currentTestList
      .removeWhere((element) => element.getName() == currentTest.getName());
  progressFile.writeAsStringSync(jsonEncode(currentTestList));

  return currentTestList;
}

// Remove all progress
Future removeAllProgress() async {
  final progressFile = File('$appDocPath/progress.txt');
  progressFile.writeAsStringSync('');
}

Future<List<Test>> saveCompleteTest(
    var completeTest, var completeTestList) async {
  //initialize file path
  final completeFile = File('$appDocPath/complete.txt');

  //add the new test progress into the current testList
  completeTestList.add(completeTest);
  completeFile.writeAsStringSync(jsonEncode(completeTestList));

  return completeTestList;
}

Future<bool> checkFirstTime() async {
  final progressFile = File('$appDocPath/progress.txt');

  if (progressFile.existsSync()) {
    return false;
  } else {
    return true;
  }
}

//read the progress from the file and update the test
Future<List<Test>> readProgress() async {
  final progressFile = File('$appDocPath/progress.txt');

  String progressString = progressFile.readAsStringSync();

  if (progressString.isNotEmpty) {
    //turn data into a list of test (record of test progress)
    var testObjsJson = jsonDecode(progressString) as List;
    List<Test> testList =
        testObjsJson.map((testJson) => Test.fromJson(testJson)).toList();
    return testList;
  }

  return [];
}

//read the progress from the file and update the test
Future<List<Test>> loadCompleteTest() async {
  final completeRecordFile = File('$appDocPath/complete.txt');

  String completeString = completeRecordFile.readAsStringSync();

  if (completeString.isNotEmpty) {
    //turn data into a list of test (record of test progress)
    var testObjsJson = jsonDecode(completeString) as List;
    List<Test> testList =
        testObjsJson.map((testJson) => Test.fromJson(testJson)).toList();
    return testList;
  }

  return [];
}

// return course name and current list name
Future<Set<String>> updateTestFile() async {
  //setting up application directory
  final courseFile = File('$appDocPath/course.txt');
  print("Path for this device: " + appDocPath); // printing our the directory

  //setting up back4app ID address
  await dotenv.load(fileName: "../.env");
  final keyApplicationId = dotenv.env['KEY_APPLICATION_ID'];
  final keyClientKey = dotenv.env['KEY_CLIENT_KEY'];

  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId!, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  //setting up JSON File for VERSION JSON file through Back4App Connection
  QueryBuilder<ParseObject> version =
      QueryBuilder<ParseObject>(ParseObject('JSON_Version'));
  version.whereEqualTo("dataType", "jsonFile");
  final ParseResponse versionResponse = await version.query();
  List<ParseObject> versionList = versionResponse.results as List<ParseObject>;

  //setting up JSON File for question file through Back4App Connection
  QueryBuilder<ParseObject> jsonQuestionParse =
      QueryBuilder<ParseObject>(ParseObject("JSON"));
  final ParseResponse jsonResponse = await jsonQuestionParse.query();

  //check if there is an existing version file to download the questionFile or not
  final versionFile = File('$appDocPath/version.txt');

  if ((versionFile.existsSync() &&
          versionFile.readAsStringSync() !=
              versionList[versionList.length - 1]["date"]) ||
      !versionFile.existsSync()) {
    print("version is different!");
    Queue courseList1 = new Queue<String>();

    //looping over all of the items to find the names for the course and potentially units
    for (var o in jsonResponse.results as List<ParseObject>) {
      String? currentCourse = o.get<String>('Course');
      if (!courseList1.contains(currentCourse)) {
        courseList1.add(currentCourse);
      }
    }

    //courseList2 is a duplicate of courseList1, in order to loop over and adjust
    //the unit file.
    Queue courseList2 = new Queue.from(courseList1);
    courseFile.writeAsStringSync(courseList1
        .toString()
        .substring(1, courseList1.toString().indexOf('}')));

    //looping through course and add units into the corresponding directories
    while (courseList2.isNotEmpty) {
      jsonQuestionParse
        ..whereArrayContainsAll('Course', [courseList2.first])
        ..orderByAscending("Unit");
      var unitResponse = await jsonQuestionParse.query();
      Queue unitList1 = new Queue<String>();

      if (unitResponse.success && unitResponse.results != null) {
        for (var object in unitResponse.results as List<ParseObject>) {
          unitList1.add(object.get<String>("Unit"));
        }
        String unitListFile = "";
        int unitListLength = unitList1.length;

        for (int i = 0; i < unitListLength - 1; i++) {
          unitListFile = unitListFile +
              unitList1.first.substring(0, unitList1.first.indexOf('.')) +
              ",";
          unitList1.removeFirst();
        }
        unitListFile = unitListFile +
            unitList1.first.substring(0, unitList1.first.indexOf('.'));

        //String to pass in for the file is stored in unitList File
        await Directory('$appDocPath${testDirectory}/' + courseList2.first)
            .create(recursive: true);
        var unitFile = File(
            '$appDocPath${testDirectory}/' + courseList2.first + "/unit.txt");
        unitFile.writeAsStringSync(unitListFile);

        courseList2.removeFirst();
      }
    }

    //downloading file to the correct directories
    jsonQuestionParse = QueryBuilder<ParseObject>(ParseObject("JSON"));
    final fileResponse = await jsonQuestionParse.query();

    for (var parseMap in fileResponse.results as List<ParseObject>) {
      var url = Uri.parse(parseMap["QuestionFile"]["url"]);
      print(url);
      var json_response = await http.get(url);
      var data = jsonDecode(json_response.body);
      String course = parseMap.get<String>("Course")!;
      String unit;
      if (parseMap.get<String>("Unit")!.indexOf('.') != -1) {
        unit = parseMap
            .get<String>("Unit")!
            .substring(0, parseMap.get<String>("Unit")!.indexOf('.'));
      } else {
        unit = parseMap.get<String>("Unit")!;
      }
      var file = File('$appDocPath${testDirectory}/${course}/${unit}.txt');
      file.writeAsStringSync(jsonEncode(data));
    }

    //update the version in the file
    versionFile.writeAsString(versionList[versionList.length - 1]["date"]);
  }

  String courseListContent = await courseFile.readAsString();
  List<String> courseListNew = courseListContent.split(", ");
  var courseSet = courseListNew.toSet();

  loadImageFile();
  return courseSet;
}

void writeProgressTestFile(String course, String unit) async {
  await Directory('$appDocPath/Progress/${course}').create(recursive: true);
  var file = File('$appDocPath/Progress/${course}/${unit}.txt');
  file.writeAsStringSync(jsonEncode(test_file));
}

/// Function called in the main file when first start the program
/// Check if there is student name yet
Future<String> loadNameFile() async {
  final nameFile = File("$appDocPath/name.txt");
  if (nameFile.existsSync()) {
    return nameFile.readAsStringSync();
  }
  return "";
}

/// Funtion called in the main file when first start the program
/// Check for new version of Image File and and nver worked for the new wokring places
void loadImageFile() async {
  //setting up application directory
  print("Path for this device: " + appDocPath); // printing our the directory

  //setting up back4app ID address
  await dotenv.load(fileName: "../.env");
  final keyApplicationId = dotenv.env['KEY_APPLICATION_ID'];
  final keyClientKey = dotenv.env['KEY_CLIENT_KEY'];

  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId!, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  //setting up JSON File for VERSION JSON file through Back4App Connection
  QueryBuilder<ParseObject> version =
      QueryBuilder<ParseObject>(ParseObject('JSON_Version'));
  version.whereEqualTo("dataType", "jsonFile");

  version.whereEqualTo("dataType", "imageFile");
  final ParseResponse imageVersionResponse = await version.query();
  List<ParseObject> imageVersionList =
      imageVersionResponse.results as List<ParseObject>;
  final imageVersionFile = File('$appDocPath/imageVersion.txt');
  if ((imageVersionFile.existsSync() &&
          imageVersionFile.readAsStringSync() !=
              imageVersionList[imageVersionList.length - 1]["date"]) ||
      !imageVersionFile.existsSync()) {
    // add an image directory:
    await Directory('$appDocPath/Image').create(recursive: true);

    //setting up Image File for question file through Back4App Connection
    QueryBuilder<ParseObject> imageParse =
        QueryBuilder<ParseObject>(ParseObject("Images"));
    final ParseResponse imageResponse = await imageParse.query();

    for (var o in imageResponse.results as List<ParseObject>) {
      ParseFileBase? currentImageFile = o.get<ParseFileBase>('ImageFile');
      if (currentImageFile == null) continue;
      String? currentImageName = o.get<String>("FileName");
      String? imageURL = currentImageFile["url"];

      downloadFileImage(imageURL!, currentImageName!);
    }

    // update the date in image version file
    imageVersionFile
        .writeAsString(imageVersionList[imageVersionList.length - 1]["date"]);
  }
}

/// Import all Mathematics Parser by calling all of them.
void importMathParser() {
  normalCDF_parser();
  binomialCDF_parser();
  inverseNormalCDF_parser();
  permutation_parser();
  combination_parser();
  binomialPDF_parser();
  geometPDF_parser();
  geometCDF_parser();
  chiSquaredCDF_parser();
  tDistCDF_parser();
  inverseTCDF_parser();
  median_parser();
  stddev_parser();
  average_parser();
  min_parser();
  max_parser();
  //floor_parser();
  //ceil_parser();
  gcf_parser();
  lcm_parser();
  //abs_parser();
  sum_parser();
  //count_parser();
  nthroot_parser();
  pi_parser();
  //e_parser();
  power_parser();
}
