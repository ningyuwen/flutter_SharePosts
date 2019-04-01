import 'package:flutter/material.dart';
import 'package:my_mini_app/home/fragment_mine.dart';
import 'package:my_mini_app/home/home_page_fragment.dart';

//好友fragment
class FragmentFriend extends StatelessWidget {
  static FragmentFriend _instance;

  factory FragmentFriend() => _getInstance();

  static FragmentFriend get instance => _getInstance();

  FragmentFriend._internal() {
    // 初始化
//    createState();
  }

  static FragmentFriend _getInstance() {
    if (_instance == null) {
      _instance = new FragmentFriend._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentFriendAndAround();
  }
}

//附近的人fragment
class FragmentAround extends StatelessWidget {
  static FragmentAround _instance;

  factory FragmentAround() => _getInstance();

  static FragmentAround get instance => _getInstance();

  FragmentAround._internal() {
    // 初始化
//    createState();
  }

  static FragmentAround _getInstance() {
    if (_instance == null) {
      _instance = new FragmentAround._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentFriendAndAround();
  }
}

//好友fragment
class FragmentMine extends StatelessWidget {
  static FragmentMine _instance;

  factory FragmentMine() => _getInstance();

  static FragmentMine get instance => _getInstance();

  FragmentMine._internal() {
    // 初始化
//    createState();
  }

  static FragmentMine _getInstance() {
    if (_instance == null) {
      _instance = new FragmentMine._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentMineWidget();
  }
}