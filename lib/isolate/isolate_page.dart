import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class IsolatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IsolateController(),
      child: PageBody(),
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isoController = Provider.of<IsolateController>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                keyboardType: TextInputType.number,
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: isoController.isInProgress
                    ? null
                    : () {
                        isoController.clear();
                        isoController.calculate(500);
                      },
                child: Text('Calculate'),
              ),
            ),
            isoController.isInProgress
                ? Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  )
                : SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, top: 32.0),
              child: Text('sum: ${isoController.sum}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, top: 16.0),
              child: Text('time-consuming: ${isoController.timesConsume}s'),
            ),
          ],
        ),
      ),
    );
  }
}

class IsolateController extends ChangeNotifier {
  Isolate _isolate;
  ReceivePort _receivePort; //接收其他isolate传入的数据
  SendPort _sendPort; //向其他isolate发送数据

  int sum = 0; //
  double timesConsume = 0.0;
  bool isInProgress = false;

  IsolateController() {
    createIsolate();
    listen();
  }

  @override
  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
    _isolate = null;
    super.dispose();
  }

  void listen() {
    //receive the message from new isolate
    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is Map) {
        print('message is map: $message');
        sum = message['sum'];
        timesConsume = message['time'];
        isInProgress = false;
        notifyListeners();
      }
    });
  }

  calculate(int cycles) {
    _sendPort.send(cycles);
    isInProgress = true;
    notifyListeners();
  }

  clear() {
    sum = 0;
    timesConsume = 0;
    notifyListeners();
  }

  //create a new isolate
  Future<void> createIsolate() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_entryPoint, _receivePort.sendPort);
  }
}

//code run in the new isolate
_entryPoint(SendPort sendPort) {
  var receivePort = ReceivePort();
  //将自己的sendport发送给main isolate
  sendPort.send(receivePort.sendPort);

  //receive message from new isolate
  receivePort.listen((dynamic message) async {
    if (message is int) {
      var timer = Stopwatch();
      timer.start();
      var sum = await generateAndSum(message);
      timer.stop();
      sendPort.send({'sum': sum, 'time': timer.elapsedMilliseconds / 1000});
    }
  });
}

//Simulate Time Consuming Operation
Future<int> generateAndSum(int num) async {
  var random = Random();
  int sum = 0;
  for (var i = 0; i < num; i++) {
    for (var j = 0; j < 1000000; j++) {
      sum += random.nextInt(100);
    }
  }

  return sum;
}
