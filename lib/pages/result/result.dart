import 'package:election_exit_poll_07610401/models/result.dart';
import 'package:election_exit_poll_07610401/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<List<Result>> _resultlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  _loadResult();
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/vote_hand.png',
                          width: 100,
                        ),
                      ),
                      Text(
                        'EXIT POLL',
                        style: GoogleFonts.righteous(
                            fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    'RESULT',
                    style: GoogleFonts.righteous(
                        fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
              Container(
                child: FutureBuilder<List<Result>>(
                  future: _resultlist,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      var resultlist = snapshot.data;
                      return SizedBox(
                        height: 350,
                        child: ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: resultlist!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var result = resultlist[index];
                            return Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: const EdgeInsets.all(8.0),
                              elevation: 0.0,
                              color: Colors.white70,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.green,
                                    child: Center(
                                      child: Text(
                                        '${result.number}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${result.title}${result.fullName}'),
                                          Text(
                                              '${result.score}',style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Result>> _loadResult() async {
    List list = await Api().fetch('exit_poll/result');
    var result = list.map((item) => Result.fromJson(item)).toList();
    return result;
  }
  @override
  initState() {
    super.initState();
    _resultlist = _loadResult();
  }
}
