
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