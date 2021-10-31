import 'package:election_exit_poll_07610401/models/api_result.dart';
import 'package:election_exit_poll_07610401/models/candidate.dart';
import 'package:election_exit_poll_07610401/pages/result/result.dart';
import 'package:election_exit_poll_07610401/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Candidate>> _candidatelist;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _loadCandidate();
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
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'เลือกตั้ง อบต.',
                      style:
                          GoogleFonts.prompt(fontSize: 26, color: Colors.white),
                    ),
                  ),
                  Text(
                    'รายชื่อผู้สมัครรับเลือกตั้ง\nนายกองค์การบริหารส่วนตำบลเขาพระ\nอำเภอเมืองนครนายก จังหวัดนครนายก',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    child: FutureBuilder<List<Candidate>>(
                      future: _candidatelist,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          var candidateList = snapshot.data;
                          return SizedBox(
                            height: 350,
                            child: ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              itemCount: candidateList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var candidate = candidateList[index];
                                return Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin: const EdgeInsets.all(8.0),
                                  elevation: 0.0,
                                  color: Colors.white70,
                                  child: InkWell(
                                    onTap: () {
                                      _vote(candidate.number);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.green,
                                          child: Center(
                                            child: Text(
                                              '${candidate.number}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              '${candidate.title}${candidate.fullName}'),
                                        ),
                                      ],
                                    ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                  child: Text(
                    'ดูผล',
                    style: GoogleFonts.prompt(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Candidate>> _loadCandidate() async {
    List list = await Api().fetch('exit_poll');
    var candidatelist = list.map((item) => Candidate.fromJson(item)).toList();
    return candidatelist;
  }

  Future<dynamic> _vote(int n) async {
    var list = await Api().submit('exit_poll', {'candidateNumber': n}) as List;

    _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ${list}');
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.prompt(fontSize: 30, color: Colors.black),
          ),
          content: Text(
            msg,
            style: GoogleFonts.prompt(),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  initState() {
    super.initState();
    _candidatelist = _loadCandidate();
  }
}
