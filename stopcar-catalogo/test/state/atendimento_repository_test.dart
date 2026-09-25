import 'package:flutter_test/flutter_test.dart';
import 'package:stopcar/models/atendimento.dart';
import 'package:stopcar/state/atendimento_repository.dart';

void main() {
  test('comeca vazio e adiciona um atendimento', () {
    final repo = AtendimentoRepository();
    expect(repo.isEmpty, isTrue);

    final criado = repo.adicionar(
      cliente: 'Maria Souza',
      veiculo: 'Fiat Argo',
      placa: 'ABC1D23',
      tipoServico: TipoServico.lavagemCompleta,
      valor: 45,
      data: DateTime(2026, 9, 20),
      status: StatusAtendimento.pendente,
    );

    expect(repo.isEmpty, isFalse);
    expect(repo.atendimentos, hasLength(1));
    expect(repo.porId(criado.id)?.cliente, 'Maria Souza');
  });

  test('atualizar reflete as mudancas no atendimento existente', () {
    final repo = AtendimentoRepository();
    final criado = repo.adicionar(
      cliente: 'João Pedro',
      veiculo: 'Onix',
      placa: 'XYZ9A87',
      tipoServico: TipoServico.polimento,
      valor: 120,
      data: DateTime(2026, 9, 21),
      status: StatusAtendimento.pendente,
    );

    repo.atualizar(criado.copyWith(status: StatusAtendimento.concluido));

    expect(repo.porId(criado.id)?.status, StatusAtendimento.concluido);
  });
}
