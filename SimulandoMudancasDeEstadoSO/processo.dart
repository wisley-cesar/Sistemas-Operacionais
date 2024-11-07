import 'dart:io';
import 'dart:math';

class Processo {
  int pid;
  int tempoTotal;
  int tp = 0;
  int cp = 1;
  String estado = "PRONTO";
  int nes = 0;
  int nCpu = 0;

  Processo(this.pid, this.tempoTotal);

  void executarCiclo() {
    tp += 1;
    cp = tp + 1;
  }

  bool verificaES() {
    return Random().nextInt(100) < 1;
  }

  bool verificaSaidaBloqueado() {
    return Random().nextInt(100) < 30;
  }

  @override
  String toString() {
    return "PID: $pid | TP (Tempo de Processamento): $tp | CP: $cp | Estado: $estado | NES (E/S): $nes | N_CPU (Uso da CPU): $nCpu";
  }
}

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
    return tempoSegundos.toStringAsFixed(2);  // Formata com duas casas decimais
  }

  void executarProcessos() {
    for (var processo in processos) {
      while (processo.tp < processo.tempoTotal) {
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
            return;
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