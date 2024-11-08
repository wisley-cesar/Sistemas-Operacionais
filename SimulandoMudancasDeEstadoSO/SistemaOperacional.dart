import 'dart:io';

import 'processo.dart';

class SistemaOperacional {
  List<Processo> processos;
  int quantum = 1000;
  final String nomeArquivo = "log_processos.txt";
  final int CICLOS_POR_SEGUNDO = 1000;
  int tempoTotalSimulacao = 0;

  SistemaOperacional(this.processos) {
    // Limpa o arquivo de log no início
    File(nomeArquivo).writeAsStringSync('');
  }

  void registrarNoArquivo(String mensagem) {
    File(nomeArquivo).writeAsStringSync(mensagem + '\n', mode: FileMode.append);
  }

  String tempoEmSegundos() {
    double tempoSegundos = tempoTotalSimulacao / CICLOS_POR_SEGUNDO;
    return tempoSegundos.toStringAsFixed(2); 
  }

  void executarProcessos() {
  bool processosEmExecucao = true;

  while (processosEmExecucao) {
    processosEmExecucao = false;

    for (var processo in processos) {
      if (processo.tp < processo.tempoTotal) {
        processosEmExecucao = true;
        processo.estado = "EXECUTANDO";

        for (int ciclo = 0; ciclo < quantum; ciclo++) {
          processo.executarCiclo();
          tempoTotalSimulacao += 1;

          if (processo.verificaES()) {
            processo.estado = "BLOQUEADO";
            processo.nes += 1;
            String mensagem = "Tempo: ${tempoEmSegundos()}s | PID ${processo.pid}: EXECUTANDO >>> BLOQUEADO";
            print(mensagem);
            registrarNoArquivo(mensagem);
            registrarNoArquivo(processo.toString());
            break;
          }

          if (processo.tp >= processo.tempoTotal) {
            processo.estado = "FINALIZADO";
            String mensagem = "Tempo: ${tempoEmSegundos()}s | PID ${processo.pid} FINALIZADO";
            print(mensagem);
            registrarNoArquivo(mensagem);
            registrarNoArquivo(processo.toString());
            break;
          }
        }

        if (processo.estado == "EXECUTANDO") {
          processo.estado = "PRONTO";
          processo.nCpu += 1;
          String mensagem = "Tempo: ${tempoEmSegundos()}s | PID ${processo.pid}: EXECUTANDO >>> PRONTO";
          print(mensagem);
          registrarNoArquivo(mensagem);
          registrarNoArquivo(processo.toString());
        }

        if (processo.estado == "BLOQUEADO" && processo.verificaSaidaBloqueado()) {
          processo.estado = "PRONTO";
          String mensagem = "Tempo: ${tempoEmSegundos()}s | PID ${processo.pid}: BLOQUEADO >>> PRONTO";
          print(mensagem);
          registrarNoArquivo(mensagem);
          registrarNoArquivo(processo.toString());
        }
      }
    }
  }
}

}
