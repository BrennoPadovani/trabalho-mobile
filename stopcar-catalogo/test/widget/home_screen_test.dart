import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stopcar/models/atendimento.dart';
import 'package:stopcar/screens/home_screen.dart';
import 'package:stopcar/state/atendimento_repository.dart';

void main() {
  Widget buildApp(AtendimentoRepository repo) {
    return ChangeNotifierProvider.value(
      value: repo,
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('mostra estado vazio quando nao ha atendimentos', (tester) async {
    final repo = AtendimentoRepository();
    await tester.pumpWidget(buildApp(repo));

    expect(find.text('Nenhum atendimento cadastrado'), findsOneWidget);
  });

  testWidgets('mostra o atendimento na lista apos ser adicionado', (tester) async {
    final repo = AtendimentoRepository();
    await tester.pumpWidget(buildApp(repo));

    repo.adicionar(
      cliente: 'Maria Souza',
      veiculo: 'Fiat Argo',
      placa: 'ABC1D23',
      tipoServico: TipoServico.lavagemCompleta,
      valor: 45,
      data: DateTime(2026, 9, 20),
      status: StatusAtendimento.pendente,
    );
    await tester.pump();

    expect(find.text('Nenhum atendimento cadastrado'), findsNothing);
    expect(find.text('Maria Souza'), findsOneWidget);
    expect(find.text('Lavagem completa'), findsOneWidget);
  });
}
