import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/home/mine_posts_item.dart';
import 'package:my_mini_app/provider/fragment_mine_provider.dart';

class ConsumePage extends StatelessWidget {
  final int _userId;

  ConsumePage(this._userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _FragmentMinePage(_userId),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text("消费账单"),
    );
  }
}

class _FragmentMinePage extends StatefulWidget {
  final int _userId;

  _FragmentMinePage(this._userId);

  @override
  State<StatefulWidget> createState() {
    return _MineState();
  }
}

class _MineState extends State<_FragmentMinePage>
    with AutomaticKeepAliveClientMixin {
  FragmentMineProvider _blocProvider = new FragmentMineProvider();

  @override
  void initState() {
    print("FragmentMineWidget initState()");
    _blocProvider.fetchMinePostData(widget._userId);
    super.initState();
  }

  @override
  void dispose() {
    _blocProvider.dispose();
    print("FragmentMineWidget close 了了了");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _blocProvider.streamBuilder<MinePost>(success: (MinePost data) {
      print("data data data length is: ${data.posts.length}");
      return _mineWidget(data);
    }, error: (msg) {
      return Container(
        child: Center(
          child: Text(msg),
        ),
      );
    }, empty: () {
      return Container(
        child: Center(
          child: Text("暂无数据"),
        ),
      );
    }, loading: () {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  Widget _mineWidget(MinePost data) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 0.0,
      ),
      itemCount: _setItemCount(data),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _userInfo(data);
        }
        if (data.posts.length == 0) {
          return Container(
            height: 200.0,
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                "您当前暂未发布任何点评信息，发布之后可以再来查看哦",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return MinePostItemView(
          new ObjectKey(data.posts[index - 1].id),
          data.posts[index - 1],
        );
      },
    );
  }

  Widget _userInfo(MinePost data) {
//    print("url is: ${data.headUrl}");
    return SizedBox(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                imageUrl: data.headUrl,
              ),
            ),
            Text(
              "${data.username}",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[Text("消费："), Text("¥${data.cost}")],
            ),
          ],
        ),
      ),
    );
  }

  int _setItemCount(MinePost data) {
    if (data.posts.length == 0) {
      return data.posts.length + 2;
    } else {
      return data.posts.length + 1;
    }
  }
}