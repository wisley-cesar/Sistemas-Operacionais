import 'dart:math';
import 'package:algoritimos_gerenciamneto/algoritimos_gerenciamneto.dart';

void main() {
  AlgoritimosGerenciamento gerenciamento = AlgoritimosGerenciamento();
  String separador = '-' * 50;

  List<int> tamanhosProcessos = [5, 4, 2, 5, 8, 3, 5, 8, 2, 6];
  Map<int, int> processosAlocados = {};

  void executarAlgoritmo(String algoritmo) {
    print('\n$separador');
    print('Iniciando o teste para o algoritmo $algoritmo');
    gerenciamento.memoria = List.filled(32, 0); // Zera a memória.

    Random random = Random();

    for (int i = 0; i < 30; i++) {
      // Sorteia um processo e decide entre alocar ou desalocar.
      int tamanhoProcesso =
          tamanhosProcessos[random.nextInt(tamanhosProcessos.length)];
      bool alocar = random.nextBool();

      if (alocar) {
        int indice;
        if (algoritmo == 'First Fit') {
          indice = gerenciamento.algoritmoFirstFit(tamanhoProcesso);
        } else if (algoritmo == 'Next Fit') {
          indice = gerenciamento.algoritmoNextFit(tamanhoProcesso);
        } else if (algoritmo == 'Best Fit') {
          indice = gerenciamento.algoritmoBestFit(tamanhoProcesso);
        } else if (algoritmo == 'Quick Fit') {
          indice = gerenciamento.algoritmoQuickFit(tamanhoProcesso);
        } else if (algoritmo == 'Worst Fit') {
          indice = gerenciamento.algoritmoWorstFit(tamanhoProcesso);
        } else {
          throw Exception('Algoritmo desconhecido: $algoritmo');
        }

        if (indice != -1) {
          processosAlocados[tamanhoProcesso] = indice;
          print(
              'Processo de $tamanhoProcesso blocos alocado no índice $indice.');
        } else {
          print(
              'Erro: Não foi possível alocar o processo de $tamanhoProcesso blocos.');
        }
      } else {
        if (processosAlocados.isNotEmpty) {
          int processoParaDesalocar = processosAlocados.keys.first;
          int indiceInicio = processosAlocados.remove(processoParaDesalocar)!;
          gerenciamento.desalocarProcesso(indiceInicio, processoParaDesalocar);
        } else {
          print('Nenhum processo disponível para desalocar.');
        }
      }

      print('Estado da memória: ${gerenciamento.memoria}');
    }

    int fragmentacao = calcularFragmentacaoExterna(
        gerenciamento.memoria, tamanhosProcessos.reduce(min));
    print('Fragmentação externa ao final do teste: $fragmentacao blocos.');
    print('$separador\n');
  }

  executarAlgoritmo('First Fit');
  executarAlgoritmo('Next Fit');
  executarAlgoritmo('Best Fit');
  executarAlgoritmo('Quick Fit');
  executarAlgoritmo('Worst Fit');
}

int calcularFragmentacaoExterna(List<int> memoria, int tamanhoMinimo) {
  int fragmentacao = 0;
  int espacoLivre = 0;

  for (int bloco in memoria) {
    if (bloco == 0) {
      espacoLivre++;
    } else {
      if (espacoLivre > 0 && espacoLivre < tamanhoMinimo) {
        fragmentacao += espacoLivre;
      }
      espacoLivre = 0;
    }
  }

  // Verifica o último bloco livre.
  if (espacoLivre > 0 && espacoLivre < tamanhoMinimo) {
    fragmentacao += espacoLivre;
  }

  return fragmentacao;
}
