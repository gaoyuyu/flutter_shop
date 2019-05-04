import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget  {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  String homePageContent = "正在获取数据";

  @override
  void initState() {
    getHomePageContent().then((val) {
      setState(() {
        homePageContent = val.toString();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("百姓生活+"),
        ),
        body: FutureBuilder(
            future: getHomePageContent(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                List<Map> swiper = (data["data"]["slides"] as List).cast();
                List<Map> navigator = (data["data"]["category"] as List).cast();
                String adPicture =
                    data["data"]["advertesPicture"]["PICTURE_ADDRESS"];
                String leaderImage =
                    data['data']['shopInfo']['leaderImage']; //店长图片
                String leaderPhone =
                    data['data']['shopInfo']['leaderPhone']; //店长电话

                List<Map> recommendList =
                    (data["data"]["recommend"] as List).cast();

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SwiperDiy(swiperDataList: swiper),
                      TopNavigator(navigatorList: navigator),
                      AdBanner(adPicture: adPicture),
                      LeaderPhone(
                          leaderImage: leaderImage, leaderPhone: leaderPhone),
                      Recommend(
                        recommendList: recommendList,
                      )
                    ],
                  ),
                );
              } else {
                return Center(child: Text("加载中"));
              }
            }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({this.swiperDataList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//网格导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Image.network(item["image"], width: ScreenUtil().setWidth(95)),
          Text(item["mallCategoryName"])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, 11);
    }

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告区域
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({this.adPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话
class LeaderPhone extends StatelessWidget {
  //店长图片
  final String leaderImage;

  //店长电话
  final String leaderPhone;

  LeaderPhone({this.leaderImage, this.leaderPhone});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = "tel:" + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Url不能进行访问，异常";
    }
  }
}

//推荐区域
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({this.recommendList});

  //标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Text(
        "商品推荐",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独区域
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]["image"]),
            Text("￥${recommendList[index]["mallPrice"]}"),
            Text(
              "￥${recommendList[index]["price"]}",
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}
