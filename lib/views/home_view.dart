import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kosha_attendance/models/attendance_model.dart';
import 'package:kosha_attendance/models/boxes.dart';
import 'package:kosha_attendance/models/user_model.dart';
import 'package:kosha_attendance/services/http_service.dart';
import 'package:kosha_attendance/views/attendance_view.dart';

class HomeView extends StatefulWidget {
  final String title;
  const HomeView({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeView> createState() => _HomePageState();
}

class _HomePageState extends State<HomeView> {
  List<UserModel> userList = [];
  List<Attendance> attendanceList = [];
  String? selectedTime;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    getUserList();
    super.initState();
  }

  void getUserList() async {
    userList = await HttpServices().getUsers();
    setState((){});
  }

  Future present(int id, String reason, String createdAt, bool isPresent) async {
    final attendance = Attendance()
      ..id = id
      ..reason = reason
      .. createdAt = createdAt.toString()
      ..isPresent = isPresent;

    final box = Boxes.getAttendance();
    box.add(attendance);
  }

  Future<void> show(context, int? id, bool isPresent) async {
    TimeOfDay? result = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
    );
    if(result == null){
      deactivate();
    }
    else if (result.hour > 9) {
      setState(() {
        result = result;
      });
      TextEditingController reasonController = TextEditingController();
      showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext cxt) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0)
            )
          ),
          elevation: 2.0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason'
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),  
                  )
                )
              ),
              onPressed: isPresent
              ? (){
                  present(id!, reasonController.value.text.toString(), result!.format(context).toString(), true);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AttendanceView()));
                }
              : (){
                  present(id!, reasonController.value.text.toString(), result!.format(context).toString(), false);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AttendanceView()));
                },              
              child: const Text('save reason',
              )
            ),
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AttendanceView())
            );
          },
          icon: const Icon(Icons.chevron_left_outlined)),
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: userList.isEmpty 
      ? const Center(
          child: CircularProgressIndicator()
        )
      : ListView.builder(
        itemCount: userList.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            height: size.height/5,
            decoration: const BoxDecoration(
              color: Color.fromARGB(102, 207, 202, 202),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children : [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.network(userList[index].avatar.toString())
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("ID :  ", 
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(5))
                                            ),
                                            child: Text(userList[index].id.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text("${userList[index].firstName} ${userList[index].lastName}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              const Text("Email : ", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(userList[index].email.toString())
                            ],
                          )
                        )
                      ]
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 21, 190, 24)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )
                          )
                        ),
                        onPressed: () => show(context, userList[index].id, true), 
                        child: const Text(' Present ',
                        )
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 220, 32, 32)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),  
                            )
                          )
                        ),
                        onPressed: () => show(context, userList[index].id, false), 
                        child: const Text('On Leave',
                        )
                      ),
                    ],
                  ),
                ),
              ],
            )
          );
        })
      ),
    );
  }
}




