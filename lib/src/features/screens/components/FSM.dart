// import 'package:flutter/material.dart';
// import 'package:full_screen_menu/full_screen_menu.dart';

// class FSM extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Full Screen Menu Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             FullScreenMenu.show(
//               context,
//               items: [
//                 FSMenuItem(
//                   icon: const Icon(Icons.ac_unit, color: Colors.white),
//                   text: const Text('Make colder'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.orange, Colors.red],
//                   ),
//                   onTap: () {
//                     print('Cool package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.wb_sunny, color: Colors.white),
//                   text: const Text('Make hotter'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.blue, Colors.lightBlue],
//                   ),
//                   onTap: () {
//                     print('Hot package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.ac_unit, color: Colors.white),
//                   text: const Text('Make colder'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.orange, Colors.red],
//                   ),
//                   onTap: () {
//                     print('Cool package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.wb_sunny, color: Colors.white),
//                   text: const Text('Make hotter'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.blue, Colors.lightBlue],
//                   ),
//                   onTap: () {
//                     print('Hot package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.ac_unit, color: Colors.white),
//                   text: const Text('Make colder'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.orange, Colors.red],
//                   ),
//                   onTap: () {
//                     print('Cool package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.wb_sunny, color: Colors.white),
//                   text: const Text('Make hotter'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.blue, Colors.lightBlue],
//                   ),
//                   onTap: () {
//                     print('Hot package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.ac_unit, color: Colors.white),
//                   text: const Text('Make colder'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.orange, Colors.red],
//                   ),
//                   onTap: () {
//                     print('Cool package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//                 FSMenuItem(
//                   icon: const Icon(Icons.wb_sunny, color: Colors.white),
//                   text: const Text('Make hotter'),
//                   gradient: const LinearGradient(
//                     begin: Alignment.center,
//                     end: Alignment.topCenter,
//                     colors: [Colors.blue, Colors.lightBlue],
//                   ),
//                   onTap: () {
//                     print('Hot package check');
//                     Navigator.pop(context); // Close the full screen menu
//                   },
//                 ),
//               ],
//             );
//           },
//           child: const Text('Open Full Screen Menu'),
//         ),
//       ),
//     );
//   }
// }
