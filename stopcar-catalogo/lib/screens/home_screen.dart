import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/atendimento_repository.dart';
import '../widgets/atendimento_card.dart';
import '../widgets/empty_state.dart';
import 'detalhe_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AtendimentoRepository>();
    final atendimentos = repo.atendimentos;

    return Scaffold(
      appBar: AppBar(title: const Text('StopCar')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo atendimento',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: atendimentos.isEmpty
          ? const EmptyState()
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;

                Widget construirCard(int index) {
                  final atendimento = atendimentos[index];
                  return AtendimentoCard(
                    atendimento: atendimento,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetalheScreen(atendimentoId: atendimento.id),
                      ),
                    ),
                  );
                }

                if (!isWide) {
                  return ListView.builder(
                    itemCount: atendimentos.length,
                    itemBuilder: (context, index) => construirCard(index),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 420,
                    mainAxisExtent: 148,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: atendimentos.length,
                  itemBuilder: (context, index) => construirCard(index),
                );
              },
            ),
    );
  }
}
