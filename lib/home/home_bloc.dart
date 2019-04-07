import 'package:test_manabie/main.dart';
import 'package:async/async.dart';
import 'package:test_manabie/model/Item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeBloc extends BlocBase {
  List<Item> _listData = List();
  Item _itemSelected;
  int _indexSelected = -1;
  BehaviorSubject<int> _stateBehavior = BehaviorSubject();
  BehaviorSubject<List<Item>> _listDataBehavior = BehaviorSubject();
  BehaviorSubject<Item> _itemSelectedBehavior = BehaviorSubject();

  Stream<int> get stateStream => _stateBehavior.stream;

  Sink<int> get _stateIn => _stateBehavior.sink;

  //
  Stream<List<Item>> get listDataStream => _listDataBehavior.stream;

  Sink<List<Item>> get _listDataIn => _listDataBehavior.sink;

  //
  Stream<Item> get itemSelectedStream => _itemSelectedBehavior.stream;

  Sink<Item> get _itemSelectedIn => _itemSelectedBehavior.sink;

  HomeBloc() {
    _generateDataList();
  }

  void selectItem(int index, Item data) {
    _itemSelected = data;
    _indexSelected = index;
    _itemSelectedIn.add(_itemSelected);
  }

  void incrementCounter() {
    if (_itemSelected != null && _indexSelected != -1) {
      _itemSelected.counter++;
      _listData[_indexSelected] = _itemSelected;
      //
      _itemSelectedIn.add(_itemSelected);
      _listDataIn.add(_listData);
    }
  }

  Future<void> _generateDataList() async {
    _stateIn.add(STATE_LOADING);
    //wait here 3s
    await Future.delayed(Duration(seconds: 2));
    //
    _listData = List.generate(10, makeItem);
    _listDataIn.add(_listData);
    //
    _stateIn.add(STATE_SUCCESS);
  }

  Item makeItem(int index) {
    var random = Random.secure();
    random.nextInt(255);
    return Item(index, 0,
        Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255)));
  }

  @override
  void dispose() {
    _stateBehavior.close();
    _listDataBehavior.close();
    _itemSelectedBehavior.close();
  }
}
