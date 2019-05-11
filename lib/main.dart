import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'provide/child_category.dart';
import 'package:provide/provide.dart';

void main() {
  var childCategory = ChildCategory();
  var providers = Providers();
  providers..provide(Provider<ChildCategory>.value(childCategory));
  return runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
