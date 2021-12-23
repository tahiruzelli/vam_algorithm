import 'package:flutter/material.dart';

int NRows = 4;
int NCols = 5;
int intMax = 2147483647;
int intMin = -2147483648;
List<int> supply = [50, 60, 50, 50];
List<int> demand = [30, 20, 70, 30, 60];
List costs = [
  [16, 16, 13, 22, 17],
  [14, 14, 13, 19, 15],
  [19, 19, 20, 23, 50],
  [50, 12, 50, 15, 11],
];
List<bool> rowDone = List.filled(NRows, false);
List<bool> colDone = List.filled(NCols, false);

void diff(int j, int len, bool isRow, List res) {
  int i, c, min1 = intMax, min2 = min1, minP = -1;
  for (i = 0; i < len; ++i) {
    if ((isRow) ? colDone[i] : rowDone[i]) continue;
    c = (isRow) ? costs[j][i] : costs[i][j];
    if (c < min1) {
      min2 = min1;
      min1 = c;
      minP = i;
    } else if (c < min2) {
      min2 = c;
    }
  }
  res[0] = min2 - min1;
  res[1] = min1;
  res[2] = minP;
}

void max_penalty(int len1, int len2, bool is_row, List res) {
  int i, pc = -1, pm = -1, mc = -1, md = intMin;
  List res2 = List<int>(3);

  for (i = 0; i < len1; ++i) {
    if ((is_row) ? rowDone[i] : colDone[i]) continue;
    diff(i, len2, is_row, res2);
    if (res2[0] > md) {
      md = res2[0]; /* max diff */
      pm = i; /* pos of max diff */
      mc = res2[1]; /* min cost */
      pc = res2[2]; /* pos of min cost */
    }
  }

  if (is_row) {
    res[0] = pm;
    res[1] = pc;
  } else {
    res[0] = pc;
    res[1] = pm;
  }
  res[2] = mc;
  res[3] = md;
}

void next_cell(List res) {
  int i;
  List res1 = List<int>(NRows);
  List res2 = List<int>(NRows);
  max_penalty(NRows, NCols, true, res1);
  max_penalty(NCols, NRows, false, res2);

  if (res1[3] == res2[3]) {
    if (res1[2] < res2[2]) {
      for (i = 0; i < 4; ++i) {
        res[i] = res1[i];
      }
    } else {
      for (i = 0; i < 4; ++i) {
        res[i] = res2[i];
      }
    }
    return;
  }
  if (res1[3] > res2[3]) {
    for (i = 0; i < 4; ++i) {
      res[i] = res2[i];
    }
  } else {
    for (i = 0; i < 4; ++i) {
      res[i] = res1[i];
    }
  }
}

void main() {
  int i, j, r, c, q, supply_left = 0, total_cost = 0;
  List cell = List<int>(4);
  List results = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];

  for (i = 0; i < NRows; ++i) {
    supply_left += supply[i];
  }
  while (supply_left > 0) {
    next_cell(cell);
    r = cell[0];
    c = cell[1];
    q = (demand[c] <= supply[r]) ? demand[c] : supply[r];
    demand[c] -= q;
    if (demand[c] == 0) {
      colDone[c] = true;
    }
    supply[r] -= q;
    if (supply[r] == 0) {
      rowDone[r] = true;
    }
    results[r][c] = q;
    supply_left -= q;
    total_cost += q * costs[r][c];
  }

  print("    A   B   C   D   E\n");
  for (i = 0; i < NRows; ++i) {
    print('W $i');
    for (j = 0; j < NCols; ++j) {
      print("  ${results[i][j]}");
    }
    print("\n");
  }
  print("\nTotal cost = $total_cost\n");
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
