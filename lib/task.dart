
import 'package:calender_app/model/event.dart';
import 'package:calender_app/provider/event_provider.dart';
import 'package:calender_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;
  const EventEditingPage({Key? key,this.event}) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  @override
  void initState() {
   if(widget.event == null){
     fromDate = DateTime.now();
     toDate = DateTime.now().add(const Duration(hours: 2));
   }
   else{
     final event = widget.event!;
     titleController.text = event.title;
     fromDate = event.from;
     toDate = event.to;
   }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          ElevatedButton.icon(
            onPressed: (){
              saveFrom();
            },
            icon:const Icon(Icons.check),
            label:const Text('Save'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Add Title',
                ),
                validator: (value) {
                  if(value.toString().isEmpty){
                    return 'Enter title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              buildDateTimePicker(),
              const SizedBox(
                height: 10,
              ),
              toBuildDateTimePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'From',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: buildDropDownField(
                text: Utils.toDate(fromDate),
                onClicked: () =>
                    pickFromDateTime( pickedDate: true),
              ),
            ),
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.toTime(fromDate),
                onClicked: () =>
                    pickFromDateTime(pickedDate: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) {
    return ListTile(
      title: Text(text),
      trailing:const Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Widget toBuildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'To',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: buildDropDownField(
                text: Utils.toDate(toDate),
                onClicked: () =>
                    pickToDateTime(pickedDate: true),
              ),
            ),
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.toTime(toDate),
                onClicked: () =>
                    pickToDateTime(pickedDate: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future pickFromDateTime(
      { required bool pickedDate}) async {
    final date = await pickDateTime(fromDate,
        pickDate: pickedDate);
    if (date == null) return null;

    if(date.isAfter(toDate)){
       toDate = DateTime(date.year,date.month,date.day, toDate.hour,toDate.minute);
    }
    setState(() {
      toDate;
      fromDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2023,7),
          lastDate: DateTime(2101));
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future pickToDateTime({ required bool pickedDate}) async{
    final date = await pickDateTime(toDate,
      pickDate: pickedDate,
       firstDate: pickedDate ? fromDate : null,
    );
    if (date == null) return null;
    setState(() {
      toDate = date;
    });
  }

   saveFrom() {
    final isValid = formKey.currentState!.validate();
    if(isValid) {
      final event = Event(
          title: titleController.text,
          from: fromDate,
          to: toDate,
          description: 'Description',
          isAllDay: false
      );
      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);
      if(isEditing){
        provider.editEvent(event,widget.event!);
        Navigator.of(context).pop;
      }else {
        provider.addEvent(event);
      }
      Get.back();
    }
  }
}
