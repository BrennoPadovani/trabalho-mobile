import 'package:flutter_test/flutter_test.dart';
import 'package:stopcar/models/atendimento.dart';

void main() {
  Atendimento criar({String? observacoes}) {
    return Atendimento(
      id: 'A1',
      cliente: 'Maria Souza',
      veiculo: 'Fiat Argo',
      placa: 'ABC1D23',
      tipoServico: TipoServico.lavagemSimples,
      valor: 45,
      data: DateTime(2026, 9, 20),
      status: StatusAtendimento.pendente,
      observacoes: observacoes,
    );
  }

  test('copyWith permite limpar observacoes explicitamente com null', () {
    final original = criar(observacoes: 'Cliente pediu cera extra');
    final atualizado = original.copyWith(observacoes: null);
    expect(atualizado.observacoes, isNull);
  });

  test('copyWith sem informar observacoes mantem o valor atual', () {
    final original = criar(observacoes: 'Cliente pediu cera extra');
    final atualizado = original.copyWith(status: StatusAtendimento.concluido);
    expect(atualizado.observacoes, 'Cliente pediu cera extra');
    expect(atualizado.status, StatusAtendimento.concluido);
  });
}
