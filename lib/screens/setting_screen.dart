import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talktranslo/screens/abouthelp_screen.dart';
import 'package:talktranslo/screens/speechsetting_screen.dart';
import '../provider/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.sunny,
              color: Color(0xFF192BC2),
            ),
            title: Text('Theme'),
            subtitle: Text('dark mode or light mode'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.mic,color: Color(0xFF192BC2),),
            title: Text('Speech setting',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.more_vert),
            onTap: (){Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SpeechSettingScreen()),
    );},
          ),
          ListTile(
            leading: Icon(Icons.question_mark,color: Color(0xFF192BC2),),
            title: Text('About and Help',style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.more_vert),
            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AbouthelpScreen()));},
          ),

        ],
      ),

    );
  }
}
