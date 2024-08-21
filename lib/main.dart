import 'package:flutter/material.dart';
import 'package:haenreg_mobile/pages/main-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hænreg',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
  home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:[ Color(0xFF83A8C9), Color(0xFF415363)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
         ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'HænReg',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)), 
            ),
            const SizedBox(height: 8),
            const Text(
              'Hændelsesregistrering',
              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 40),
             const Text(
              'Log ind som:',
              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                    print('Peter loggede ind');
                  },
                 child: Row(
                      children: [
                        Image.asset('assets/images/peter.png', 
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text('Peter'),
                      ],
                    ),
                ),
        
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Tilføj tilmeld logik her
                    print('Lone vil logge ind');
                  },
                  child: Row(
                      children: [
                        Image.asset('assets/images/lone.png', 
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text('Lone'),
                      ],
                    ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}




