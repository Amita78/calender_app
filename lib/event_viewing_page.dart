import 'package:calender_app/model/event.dart';
import 'package:calender_app/provider/event_provider.dart';
import 'package:calender_app/task.dart';
import 'package:calender_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewPage extends StatelessWidget {
  final Event event;
  const EventViewPage({Key? key,required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:const CloseButton(),
        actions: [
           IconButton(onPressed: (){
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>EventEditingPage(event: event,)));
           }, icon:const Icon(Icons.edit)),
          IconButton(onPressed: (){
            final provider = Provider.of<EventProvider>(context,listen: false);
            provider.deleteEvent(event);
            Navigator.pop(context);
          }, icon:const Icon(Icons.delete))
        ],
      ),
      body: ListView(
        padding:const EdgeInsets.all(32),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('From',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              Text(Utils.toDate(event.from),style:const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('To',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              Text(Utils.toDate(event.to),style:const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Text(event.title,style:const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),),
          const SizedBox(
            height: 24,
          ),
          Text(event.description,style:const TextStyle(
            color: Colors.white,fontSize: 18
          ),)
        ],
      ),
    );
  }


}
