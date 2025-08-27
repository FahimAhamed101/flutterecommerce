import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom FAB Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Custom FAB Location Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Floating Action Button Position:'),
            Text(
              'Center Docked',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage('assets/banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '20% off on your\nfirst purchase',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.deepPurple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Home Icon
            IconButton(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            // Profile Icon
            IconButton(
              icon: Icon(
                _selectedIndex == 1 ? Icons.person : Icons.person_outline,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            // This empty container is needed to balance the space
            // since the FAB will be in the center
            const SizedBox(width: 48),
            // Favorites Icon
            IconButton(
              icon: Icon(
                _selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            // Settings Icon
            IconButton(
              icon: Icon(
                _selectedIndex == 3 ? Icons.settings : Icons.settings_outlined,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
