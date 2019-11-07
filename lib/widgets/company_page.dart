import 'package:flutter/material.dart';
import 'package:flutter_boss/common/utils/http_util.dart';
import 'package:flutter_boss/model/company.dart';
import 'package:flutter_boss/widgets/company/company_detail_page.dart';
import 'package:flutter_boss/widgets/company/company_item.dart';
import 'package:dio/dio.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with AutomaticKeepAliveClientMixin {
  Future<List<Company>> _fetchCompanyList() async {
    
    List<Company> companyList = List<Company>();
//    Response<Map<String, dynamic>> response =
//        await HttpUtil().get('/company/list/1');
//    if (response.statusCode == 200) {
//      Map<String, dynamic> result = response.data;
//      for (dynamic data in result['data']['companies']) {
//        for (var i = 0; i <= 10; i++) {
////          print("_CompanyPageState "+ data);
//          Company companyData = Company.fromJson(data);
//          companyList.add(companyData);
//        }
//      }
//    }
    for (var i = 0; i <= 10; i++) {
      Company companyData = Company(
          id: "5dc38bf17e75d1067415ad2b",
          company: "平安普惠",
          logo: "https://img.bosszhipin.com/beijin/mcs/chatphoto/20190513/52244dc8f8319a017b9c00c9011bffbb1d3c955cf1e24c19afa0e7c028fd4eda.png",
          info: "已上市",
          hot: "热招：Java 3-5");
      companyList.add(companyData);
    }
    return companyList;
    
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
          '公 司',
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: new Center(
        child: FutureBuilder(
          future: _fetchCompanyList(),
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new CircularProgressIndicator();
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
    List<Company> companyList = snapshot.data;
    return ListView.builder(
      key: new PageStorageKey('company-list'),
      itemCount: companyList.length,
      itemBuilder: (BuildContext context, int index) {
        return CompanyItem(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (context) => CompanyDetailPage(
                    company: companyList[index], heroLogo: "heroLogo${index}"),
              ),
            );
          },
          company: companyList[index],
          heroLogo: "heroLogo${index}",
        );
      },
    );
  }
}
