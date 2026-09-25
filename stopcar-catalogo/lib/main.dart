import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'state/atendimento_repository.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const StopCarApp());
}

class StopCarApp extends StatelessWidget {
  const StopCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AtendimentoRepository(),
      child: MaterialApp(
        title: 'StopCar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const HomeScreen(),
      ),
    );
  }
}
