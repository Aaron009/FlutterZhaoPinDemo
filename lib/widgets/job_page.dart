import 'package:flutter/material.dart';
import 'package:flutter_boss/common/utils/http_util.dart';
import 'package:flutter_boss/model/job.dart';
import 'package:flutter_boss/widgets/job/job_item.dart';
import 'package:dio/dio.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with AutomaticKeepAliveClientMixin {
  Future<List<Job>> _fetchJobList() async {
    List<Job> jobList = List<Job>();
//    Response<Map<String, dynamic>> response =
//        await HttpUtil().get('/jobs/list/1');
//    if (response.statusCode == 200) {
//      Map<String, dynamic> result = response.data;
//      for (dynamic data in result['data']['jobs']) {
//        for (var i = 0; i <= 10; i++) {
////          print("_JobPageState "+ data);
//          Job jobData = Job.fromJson(data);
//          jobList.add(jobData);
//        }
//      }
//    }

    for (var i = 0; i <= 10; i++) {
      Job jobData = Job(
          id: "5dc38bf27e75d1067415ad2e",
          title: "Android",
          salary: "14-28K·16薪",
          company: "腾讯",
          info: "上海 徐汇区 漕河泾",
          category: "互联网",
          head: "https://img2.bosszhipin.com/boss/avatar/avatar_8.png",
          publish: "沈先生");
      jobList.add(jobData);
    }
    return jobList;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: new Text(
          '职 位',
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: new Center(
        child: FutureBuilder(
          future: _fetchJobList(),
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return _createListView(context, snapshot);
            }
          },
        ),
      ),
    );
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Job> jobList = snapshot.data;
    return ListView.builder(
      key: new PageStorageKey('job-list'),
      itemCount: jobList.length,
      itemBuilder: (BuildContext context, int index) {
        return new JobItem(onPressed: () {}, job: jobList[index]);
      },
    );
  }
}
