import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kosha_attendance/models/attendance_model.dart';
import 'package:kosha_attendance/models/boxes.dart';
import 'package:kosha_attendance/views/home_view.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {

  void deleteAttendance(Attendance attendance){
    attendance.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading : IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeView(title: "Kosha Attendance"))
            ),
          icon: const Icon(Icons.chevron_left_rounded)
        ),
        title : const Text('Attendance'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Attendance>> (
        valueListenable: Boxes.getAttendance().listenable(),
        builder: (context, box, _) {
          final attendances = box.values.toList().cast<Attendance>();
          return ListView.builder(
            itemCount: attendances.length,
            itemBuilder: ((context, index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 16, 2),
                height: MediaQuery.of(context).size.height/5,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(102, 207, 202, 202),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.all(10),
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),
                          child: Text(attendances[index].id.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const Spacer(),
                        (attendances[index].isPresent!)
                        ? const Text("Present",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.green
                            ),
                          )
                        : const Text("On Leave",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.red
                            ),
                          )
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(attendances[index].reason.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Created at : ${attendances[index].createdAt}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),  
                              )
                            )
                          ),
                          onPressed: () => deleteAttendance(attendances[index]),
                          child: const Text("Remove")),
                      ],
                    )
                  ],
                )
              );
            }),
          );
        }
      )
    );
  }
}