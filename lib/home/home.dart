import 'package:flutter/material.dart';
import 'package:test_manabie/home/home_bloc.dart';
import 'package:test_manabie/main.dart';
import 'package:test_manabie/model/Item.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manabie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<HomeBloc>(
        bloc: HomeBloc(),
        child: MyHomePage(title: 'Manabie'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeBloc _bloc;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<HomeBloc>(context);

    Widget listWidget = StreamBuilder<List<Item>>(
        stream: _bloc.listDataStream,
        initialData: List(),
        builder: (context, snapshot) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var data = snapshot.data[index];
                return AspectRatio(
                  aspectRatio: 0.6,
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    color: data.color,
                    key: Key(data.id.toString()),
                    child: InkWell(
                      onTap: () => _bloc.selectItem(index, data),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment(0.0, 0.0),
                        child: Text(
                          data.counter.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
    Widget itemDetailWidget = StreamBuilder<Item>(
        stream: _bloc.itemSelectedStream,
        initialData: null,
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return Container();
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 1, child: Container(),),
                Expanded(flex: 3, child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Card(
                    color: data.color,
                    child: InkWell(
                      onTap: () => _bloc.incrementCounter(),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment(0.0, 0.0),
                        child: Text(
                          data.counter.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 32.0),
                        ),
                      ),
                    ),
                  ),
                ),),
                Expanded(flex: 1,child: Container())
              ],
            );
          }
        });

    return Scaffold(
      appBar: AppBar(title: Text("Manabie"),),
      body: StreamBuilder<int>(
        stream: _bloc.stateStream,
        initialData: STATE_INIT,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case STATE_LOADING:
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            case STATE_SUCCESS:
              {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: listWidget,
                    ),
                    Divider(),
                    Expanded(
                      flex: 3,
                      child: itemDetailWidget,
                    )
                  ],
                );
              }
            default:
              {
                return Container();
              }
          }
        },
      ),
    );
  }
}
