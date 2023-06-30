import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_test_flutter_1/UI/navigation.dart';

class MainView extends StatefulWidget {
  const MainView(this.content, {super.key});

  final Widget content;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("La app de las relaciones!"),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(RouteNames.welcomePage);
            },
            icon: Icon(Icons.home),
          )
        ],
      ),
      body: widget.content,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentNavBarIndex,
          onTap: (value) {
            switch (value) {
              case 0:
                context.goNamed(RouteNames.peoplePage);
              case 1:
                context.goNamed(RouteNames.formPage);
              default:
            }
            setState(() {
              _currentNavBarIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Explorar personas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Mi perfil',
            ),
          ]),
    );
  }
}
