import 'package:calender_app/data_source/event_data_source.dart';
import 'package:calender_app/provider/event_provider.dart';
import 'package:calender_app/task.dart';
import 'package:calender_app/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('AppBar'),
      ),
      body: CalenderWidget(),
      floatingActionButton: FloatingActionButton(
        child:const  Icon(Icons.add),
        onPressed: (){
           Get.to(()=> EventEditingPage());
        },
      ),
    );
  }
}


class CalenderWidget extends StatelessWidget {

  const CalenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      allowedViews: const[
        CalendarView.month,
        CalendarView.schedule,
        CalendarView.day,
        CalendarView.week,
      ],
      dataSource: EventDataSource(events),
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      onLongPress: (details){
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(context: context, builder: (context)=>TaskWidget());
      },
    );
  }
}


