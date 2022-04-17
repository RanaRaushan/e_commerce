import 'package:flutter/material.dart';

class MyPollsWidget extends StatefulWidget {
  static const routeName = '/myPolls';

  const MyPollsWidget({Key? key}) : super(key: key);

  @override
  _MyPollsWidgetState createState() => _MyPollsWidgetState();
}

class _MyPollsWidgetState extends State<MyPollsWidget> with TickerProviderStateMixin{

  List<String> pollChoice = [
    "Between 9:00 AM to 11:00 AM",
    "Between 12:00 AM to 01:00 PM",
    "After 11:00 AM",
    "Before 3:00 PM",
  ];

  List<double> optionsValue = [
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  List<double> divValue = [
    0.0,
    0.0,
    0.0,
    0.0,
  ];



  textField (String labelText, int choice)=> InkWell(
    onTap: (){
      setState(() {
        optionsValue[choice] += 1.0;
        var sum = optionsValue[0]+optionsValue[1]+optionsValue[2]+optionsValue[3];
        divValue[0] = sum == 0 ? 0 : (1 / sum) * optionsValue[0];
        divValue[1] = sum == 0 ? 0 : (1 / sum) * optionsValue[1];
        divValue[2] = sum == 0 ? 0 : (1 / sum) * optionsValue[2];
        divValue[3] = sum == 0 ? 0 : (1 / sum) * optionsValue[3];
        debugPrint("divValue0= $divValue[0]");
      });
    },
    child:TextField(
    enabled: false,
    controller: TextEditingController(text: labelText),
    textAlign: TextAlign.center,
    decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.blue),hoverColor: Colors.yellow,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            borderSide: BorderSide(color: Colors.blue)
        )
    ),
  ));

  _progressBar(double value, int index){
    _stack () {
      return Stack(alignment: AlignmentDirectional.center,
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(value: value,
                  backgroundColor: Colors.grey,minHeight: 35)),
          Positioned(child: Text(pollChoice[index]),left: 30,),
          Text("${(divValue[index]*100).round()}%")
        ],
      );
    }
    return _stack();
  }

  _buildPoll() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("What should be the timing for tomorrow's class?",
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox( height: 12,),
        Container(
            margin: const EdgeInsets.fromLTRB(3, 3, 10, 3),
            width: double.infinity,
            child: ListView.builder(shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, index) {
                return Padding(child: textField(pollChoice[index], index), padding: const EdgeInsets.all(8.0),);
              },
            )
        ),
        const SizedBox( height: 25,),
        const Text("Poll Result",
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox( height: 12,),
        Container(
            margin: const EdgeInsets.fromLTRB(3, 3, 10, 3),
            width: double.infinity,
            child: ListView.builder(shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, index) {
                return _progressBar(divValue[index], index);
              },
            )
        ),
      ]
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Poll"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // _inBuildPoll(),
            Expanded(child:_buildPoll())
          ],
        ),
      ),
    );
  }
}