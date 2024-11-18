import 'package:flutter/material.dart';
import 'package:pupil/Widgets/Alerts/LogoutConfirmationDialog.dart';
import 'package:pupil/Widgets/sidebar.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 1;
  int _counter = 0;
  Timer? _timer;
  late StreamController<int> _events;
  bool disableButtonAndField = true;

  @override
  initState() {
    super.initState();
    _events = new StreamController.broadcast();
    _events.add(10);
  }


  void _startTimer() {
    _counter = 10;
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : setState(() {
        _timer?.cancel();
        disableButtonAndField = false;
      });
      //});
      print(_counter);
      _events.add(_counter);
    });
  }

  void alertD(BuildContext ctx) {
    var alert = AlertDialog(
      // title: Center(child:Text('Enter Code')),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        content: StreamBuilder<int>(
            stream: _events.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              print(snapshot.data.toString());
              return PopScope(
                canPop: false,
                child: SizedBox(
                  height: 215,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 15),
                          child: Text(
                            'Tell me about yourself ?',
                            style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                      SizedBox(
                        height: 70,
                        width: 180,
                        child: TextFormField(
                          enabled: disableButtonAndField,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.green, width: 0.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('00:${snapshot.data.toString()}'),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: SizedBox(
                              height: 50,
                              width: 336,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigoAccent,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.indigoAccent, width: 2),
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                  onPressed: disableButtonAndField? null :
                                      (){
                                        Navigator.of(context).pop();
                                      },
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.5 // Set the text color
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ), //new column child
                    ],
                  ),
                ),
              );
            }));
    showDialog(
        context: ctx,
        builder: (BuildContext c) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text(
                "Quiz App",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutConfirmationDialog();
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              )
            ]),
        drawer: const AppDrawer(),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.book_rounded),
              label: 'Certificate',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            NavigationDestination(
              icon:Icon(Icons.messenger),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.format_list_numbered),
              label: 'Score',
            ),
          ],
        ),
        body: <Widget>[
          const Card(
            shadowColor: Colors.transparent,
            margin: EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Certificate Tab',
                ),
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.purpleAccent,
                automaticallyImplyLeading: false,
                title: const Text(
                  "Profile Tab",
                  style: TextStyle(color: Colors.white),
                ),
            ),

            body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _startTimer();
                    alertD(context);
                    disableButtonAndField = true;
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Win Certificate',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
          const Card(
            shadowColor: Colors.transparent,
            margin: EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Chat Tab',
                ),
              ),
            ),
          ),
          const Card(
            shadowColor: Colors.transparent,
            margin: EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Score Tab',
                ),
              ),
            ),
          ),
        ][currentPageIndex],
      ),
    );
  }
}
