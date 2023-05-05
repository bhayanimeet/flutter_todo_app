import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controllers/google_ads_controller.dart';
import '../../controllers/local_notification_controller.dart';
import '../../controllers/sqlite_db_controller.dart';
import '../../models/sqlite_db_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pd;
import 'package:printing/printing.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> insertKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String? task;
  int num = 0;

  String? time;
  String? myTime;
  String showTime =
      "${DateTime.now().toString().split(':')[0]}:${DateTime.now().toString().split(':')[1]}";

  DateTime picker = DateTime.now();
  int hour = DateTime.now().hour;
  int minute = DateTime.now().minute;

  late Future<List<Task>> allTask;
  List<Task>? data;
  final pdf = pd.Document();

  makePdf() {
    pdf.addPage(
      pd.Page(
        build: (pd.Context conText) => pd.ListView.builder(
          itemCount: data!.length,
          itemBuilder: (conText,i){
            return pd.Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              margin: const pd.EdgeInsets.only(left: 8, right: 8, top: 8),
              child: pd.Row(
                children: [
                  pd.Expanded(
                    flex: 2,
                    child: pd.Padding(
                      padding: const pd.EdgeInsets.only(left: 5, top: 5),
                      child: pd.Align(
                        alignment: pd.Alignment.topLeft,
                        child: pd.Text(
                          "${data![i].time}\n ${(hour <= 12) ? "AM" : 'PM'}",
                          textAlign: pd.TextAlign.center,
                          style: const pd.TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  pd.Expanded(
                    flex: 8,
                    child: pd.Padding(
                      padding: const pd.EdgeInsets.only(top: 5),
                      child: pd.Align(
                        alignment: pd.Alignment.topLeft,
                        child: pd.Text(
                          data![i].task,
                          style: const pd.TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    allTask = DBHelper.dbHelper.selectData();
    makePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do App",
          style: GoogleFonts.arya(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              Uint8List data = await pdf.save();
              await Printing.layoutPdf(onLayout: (format) => data);
              setState(() {});
            },
            child: const Icon(Icons.picture_as_pdf),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Get.changeThemeMode(
                (Get.isDarkMode == true) ? ThemeMode.light : ThemeMode.dark,
              );
            },
            child: const Icon(Icons.light_mode_outlined),
          ),
          const SizedBox(width: 10),
        ],
        centerTitle: true,
        elevation: 10,
      ),
      body: FutureBuilder(
        future: allTask,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Data not found...."),
            );
          } else if (snapshot.hasData) {
            data = snapshot.data;
            return (data != null)
                ? ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, i) => Card(
                      elevation: 3,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "${data![i].time}\n ${(hour <= 12) ? "AM" : 'PM'}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.arya(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5,left: 15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    data![i].task,
                                    style: GoogleFonts.arya(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  int res = await DBHelper.dbHelper
                                      .deleteData(index: data![i].id!);

                                  if (res == 1) {
                                    setState(() {
                                      allTask = DBHelper.dbHelper.selectData();
                                    });
                                  }
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      "Data not found...",
                    ),
                  );
          }
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: Colors.indigo, size: 30),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState((){
            num++;
          });
          if(num%3==0){
            if (AdHelper.adHelper.interstitialAd != null) {
              AdHelper.adHelper.interstitialAd!.show();
              AdHelper.adHelper.loadInterstitialAd();
            }
            insertData(context);
          }
          else{
            insertData(context);
          }

        },
        elevation: 5,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
  insertData(context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "Insert Task",
            style: GoogleFonts.play(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Form(
          key: insertKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: taskController,
                style: GoogleFonts.play(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                enableSuggestions: true,
                textInputAction: TextInputAction.next,
                onSaved: (val) {
                  setState(() {
                    task = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your task...";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: (Get.isDarkMode == true)
                              ? Colors.white
                              : Colors.black,
                          width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: (Get.isDarkMode == true)
                              ? Colors.white
                              : Colors.black,
                          width: 1)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: (Get.isDarkMode == true)
                              ? Colors.white
                              : Colors.black,
                          width: 1)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: (Get.isDarkMode == true)
                              ? Colors.white
                              : Colors.black,
                          width: 1)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: (Get.isDarkMode == true)
                              ? Colors.white
                              : Colors.black,
                          width: 1)),
                  hintText: "Enter your task",
                  hintStyle: GoogleFonts.play(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  labelText: "Task",
                  labelStyle: GoogleFonts.arya(
                      fontSize: 25, fontWeight: FontWeight.w500),
                  errorStyle: GoogleFonts.play(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 280,
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (DateTime dateTime) {
                            setState(() {
                              picker = dateTime;
                              hour = picker.hour;
                              minute = picker.minute;
                              myTime = "$hour:$minute";
                              if (showTime ==
                                  "${DateTime.now().toString().split(':')[0]}:${DateTime.now().toString().split(':')[1]}") {
                                showTime =
                                    "${DateTime.now().toString().split(':')[0]}:${DateTime.now().toString().split(':')[1]}";
                              } else {
                                setState(() {
                                  showTime = "$myTime";
                                });
                              }
                            });
                          },
                          use24hFormat: true,
                        ),
                      ),
                    );
                  });
                },
                child: Container(
                  height: 70,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: (Get.isDarkMode == true)
                            ? Colors.white
                            : Colors.black,
                        width: 1),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Text(
                        (myTime != null)
                            ? showTime
                            : "${DateTime.now().toString().split(':')[0]}:${DateTime.now().toString().split(':')[1]}",
                        style: GoogleFonts.play(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (insertKey.currentState!.validate()) {
                insertKey.currentState!.save();
                Task s1 = Task(time: showTime, task: task!);

                int res = await DBHelper.dbHelper.insertData(data: s1);

                if (res > 0) {
                  setState(() {
                    allTask = DBHelper.dbHelper.selectData();
                  });
                }

                Navigator.pop(context);

                Get.showSnackbar(
                  GetSnackBar(
                    title: 'Task',
                    backgroundColor: Colors.indigo.shade300,
                    snackPosition: SnackPosition.BOTTOM,
                    borderRadius: 20,
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(15),
                    message: 'Your added in list...',
                    snackStyle: SnackStyle.FLOATING,
                  ),
                );

                await LocalPushNotificationHelper.localPushNotificationHelper
                    .showSimpleNotification();
              }

              setState(() {
                myTime = null;
                taskController.clear();
                task = null;
              });
            },
            child: const Text("Insert"),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                myTime = null;
                taskController.clear();
                task = null;
              });
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
