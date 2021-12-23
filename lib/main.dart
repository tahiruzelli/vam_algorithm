import 'package:flutter/material.dart';

Map findBiggestNum(List list, bool isX) {
  Map tmp = {
    'point': 0,
    'x': 0,
    'y': 0,
    'isX': isX,
  };
  for (int i = 0; i < list.length; i++) {
    if (list[i] > tmp['point']) {
      tmp['point'] = list[i];
      if (isX) {
        tmp['y'] = i;
      } else {
        tmp['x'] = i;
      }
    }
  }
  return tmp;
}

int findSmallestNum(List list) {
  int tmp = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i] < tmp) {
      tmp = list[i];
    }
  }
  return tmp;
}

int findSecondSmallestNum(List list) {
  List tmpList = list;
  tmpList.sort();
  return tmpList[1];
}

List<int> matrisSatiriDoldur(int a, int b, int c, int d) {
  List<int> tmp = [];
  tmp.add(a);
  tmp.add(b);
  tmp.add(c);
  tmp.add(d);
  return tmp;
}

void tumMatrisiDoldur(List matrix) {
  matrix.add(matrisSatiriDoldur(45, 17, 21, 30));
  matrix.add(matrisSatiriDoldur(14, 18, 19, 31));
  matrix.add(matrisSatiriDoldur(0, 0, 0, 0));
}

void matrisiYenile(List matrix) {
  matrix[0][0] = 45;
  matrix[0][1] = 17;
  matrix[0][2] = 21;
  matrix[0][3] = 30;

  matrix[1][0] = 14;
  matrix[1][1] = 18;
  matrix[1][2] = 19;
  matrix[1][3] = 31;

  matrix[2][0] = 0;
  matrix[2][2] = 0;
  matrix[2][1] = 0;
  matrix[2][3] = 0;
}

void sutunCezalariHesapla(List matrix, List penaltyY) {
  for (int i = 0; i < matrix.length; i++) {
    int penalty;
    penalty = findSecondSmallestNum(matrix[i]) - findSmallestNum(matrix[i]);
    matrisiYenile(matrix);
    penaltyY.add(penalty);
  }
}

void satirCezalariHesapla(List matrix, List penaltyX) {
  List tmpList = [];
  int penalty;
  for (int j = 0; j < matrix[0].length; j++) {
    for (int i = 0; i < matrix.length; i++) {
      tmpList.add(matrix[i][j]);
    }
    penalty = findSecondSmallestNum(tmpList) - findSmallestNum(tmpList);
    penaltyX.add(penalty);
    tmpList.clear();
  }
}

Map findBiggestPenalty(List penaltyX, List penaltyY) {
  Map xSum;
  Map ySum;
  xSum = findBiggestNum(penaltyX, true);
  ySum = findBiggestNum(penaltyY, false);

  if (xSum['point'] > ySum['point']) {
    return xSum;
  } else if (ySum['point'] > xSum['point']) {
    return ySum;
  } else {
    return ySum;
  }
}

bool arzTalepKontrolu(List supply, List demand) {
  int supplySum = 0;
  int demandSum = 0;
  for (int i = 0; i < supply.length; i++) {
    supplySum += supply[i];
  }
  for (int i = 0; i < demand.length; i++) {
    demandSum += demand[i];
  }
  if (supplySum == demandSum) {
    return true;
  } else {
    return false;
  }
}

Map findSmallestCell(Map penalty, List matrix) {
  List<Map> tmpList = [];
  if (penalty['isX']) {
    for (int i = 0; i < matrix.length; i++) {
      tmpList.add({
        'point': matrix[i][penalty['y']],
        'x': penalty['y'],
        'y': i,
      });
    }
  } else {
    for (int i = 0; i < matrix[penalty['x']].length; i++) {
      tmpList.add({
        'point': matrix[penalty['x'][i]],
        'x': i,
        'y': penalty['x'],
      });
    }
  }
  tmpList.sort((a, b) => a['point'].compareTo(b['point']));
  return tmpList.first;
}

void main() {
  List<List<int>> matrix = new List<List<int>>();
  List penaltyX = [];
  List penaltyY = [];
  List supply = [15, 13, 3];
  List demand = [9, 6, 7, 9];
  Map biggestPenalty;
  Map smallestCell;
  if (arzTalepKontrolu(supply, demand)) {
    tumMatrisiDoldur(matrix);
    //matris.length x
    // matris.first.lenhth y

    sutunCezalariHesapla(matrix, penaltyY);
    satirCezalariHesapla(matrix, penaltyX);

    biggestPenalty = findBiggestPenalty(penaltyX, penaltyY);
    smallestCell = findSmallestCell(biggestPenalty, matrix);
  } else {
    print('Arz Talep birbirini tutmuyor');
  }

  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
