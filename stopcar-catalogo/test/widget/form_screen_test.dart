import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stopcar/models/atendimento.dart';
import 'package:stopcar/screens/form_screen.dart';
import 'package:stopcar/state/atendimento_repository.dart';

void main() {
  Widget buildApp(AtendimentoRepository repo, {Atendimento? existente}) {
    return ChangeNotifierProvider.value(
      value: repo,
      child: MaterialApp(home: FormScreen(existente: existente)),
    );
  }

  testWidgets('mostra erro de validacao ao submeter com cliente vazio', (tester) async {
    final repo = AtendimentoRepository();
    await tester.pumpWidget(buildApp(repo));

    await tester.ensureVisible(find.text('Cadastrar atendimento'));
    await tester.tap(find.text('Cadastrar atendimento'));
    await tester.pump();

    expect(find.text('Informe o nome do cliente.'), findsOneWidget);
    expect(repo.atendimentos, isEmpty);
  });

  testWidgets('cadastra atendimento com valor usando virgula decimal', (tester) async {
    final repo = AtendimentoRepository();
    await tester.pumpWidget(buildApp(repo));

    await tester.enterText(find.widgetWithText(TextFormField, 'Cliente *'), 'João Pedro');
    await tester.enterText(find.widgetWithText(TextFormField, 'Veículo (modelo) *'), 'Onix');
    await tester.enterText(find.widgetWithText(TextFormField, 'Placa *'), 'ABC1D23');
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor (R\$) *'), '35,50');

    await tester.ensureVisible(find.text('Cadastrar atendimento'));
    await tester.tap(find.text('Cadastrar atendimento'));
    await tester.pumpAndSettle();

    expect(repo.atendimentos, hasLength(1));
    expect(repo.atendimentos.first.valor, 35.5);
  });

  testWidgets('pre-carrega os campos ao editar um atendimento existente', (tester) async {
    final repo = AtendimentoRepository();
    final existente = repo.adicionar(
      cliente: 'Ana Lima',
      veiculo: 'HB20',
      placa: 'DEF4G56',
      tipoServico: TipoServico.enceramento,
      valor: 80,
      data: DateTime(2026, 9, 22),
      status: StatusAtendimento.pendente,
    );

    await tester.pumpWidget(buildApp(repo, existente: existente));

    expect(find.text('Ana Lima'), findsOneWidget);
    expect(find.text('HB20'), findsOneWidget);
    expect(find.text('80.00'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Veículo (modelo) *'), 'HB20 Sense');
    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.tap(find.text('Salvar alterações'));
    await tester.pumpAndSettle();

    expect(repo.atendimentos, hasLength(1));
    expect(repo.porId(existente.id)?.cliente, 'Ana Lima');
    expect(repo.porId(existente.id)?.veiculo, 'HB20 Sense');
  });
}
