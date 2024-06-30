import 'package:calender_app/data_source/event_data_source.dart';
import 'package:calender_app/event_viewing_page.dart';
import 'package:calender_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvent = provider.eventOfSelectedDate;
    if(selectedEvent.isEmpty){
      return const Center(
        child: Text('No event found',style: TextStyle(color: Colors.black,fontSize: 24),),
      );
    }
    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      headerHeight: 0,
      todayHighlightColor: Colors.deepPurple,
      onTap: (details){
        if(details.appointments == null) return;
        final events = details.appointments!.first;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EventViewPage(event: events,)));
      },
    );
  }

  Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails details){
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(event.title,maxLines: 2,overflow: TextOverflow.ellipsis,style:const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}
