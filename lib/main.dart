import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_9/bloc/auth_bloc.dart';
import 'package:flutter_9/bloc/auth_state.dart';
import 'package:flutter_9/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Dio dio = Dio();
  final AuthBloc authBloc = AuthBloc(repository: Repository(Dio()));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => authBloc..loadAlbums(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indexIndex = 0;
  final List<Widget> _children = [
    Column(
      children: [
        Expanded(
          child: Center(
            child: Lottie.asset('assets/assets1.json', height: 100, width: 100),
          ),
        ),
        Lottie.asset('assets/assets2.json', height: 100, width: 100),
      ],
    ),
    AlbumPage(),
    QRPage(),
    Text('Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Bar Example')),
      body: _children[_indexIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _indexIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history_outlined),
            label: 'Albums',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_blocking_outlined),
            label: 'Messages',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black,
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _indexIndex = index;
    });
  }
}

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is InitialState) {
            return Center(child: Text('Press button to load albums.'));
          } else if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadedAlbumsState) {
            return ListView.builder(
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Title: " + state.albums[index].title),
                  subtitle: Text(
                      "UserID: ${state.albums[index].userId}, ID: ${state.albums[index].id}"),
                );
              },
            );
          } else if (state is ErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Offstage();
        },
      ),
    );
  }
}

class QRPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (qrText == null || qrText == "")
                  ? Text('Отсканируйте QR-код')
                  : Text('Данные: $qrText'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
