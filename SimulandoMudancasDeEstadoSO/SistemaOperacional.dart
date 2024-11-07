import 'dart:io';
import 'processo.dart';

class SistemaOperacional {
  List<Processo> processos;
  int quantum = 1000;
  final String nomeArquivo = "log_processos.txt";

  SistemaOperacional(this.processos) {
    // Limpa o arquivo de log no início
    File(nomeArquivo).writeAsStringSync('');
  }

  // Método para registrar as informações no arquivo
  void registrarNoArquivo(String mensagem) {
    File(nomeArquivo).writeAsStringSync(mensagem + '\n', mode: FileMode.append);
  }

  void executarProcessos() {
    for (var processo in processos) {
      while (processo.tp < processo.tempoTotal) {
        processo.estado = "EXECUTANDO";
        
        for (int ciclo = 0; ciclo < quantum; ciclo++) {
          processo.executarCiclo();

          if (processo.verificaES()) {
            processo.estado = "BLOQUEADO";
            processo.nes += 1;
            String mensagem = "PID ${processo.pid}: EXECUTANDO >>> BLOQUEADO";
            print(mensagem);
            registrarNoArquivo(mensagem);
            registrarNoArquivo(processo.toString());
            break;
          }

          if (processo.tp >= processo.tempoTotal) {
            processo.estado = "FINALIZADO";
            String mensagem = "PID ${processo.pid} FINALIZADO";
            print(mensagem);
            registrarNoArquivo(mensagem);
            registrarNoArquivo(processo.toString());
            return;
          }
        }

        if (processo.estado == "EXECUTANDO") {
          processo.estado = "PRONTO";
          processo.nCpu += 1;
          String mensagem = "PID ${processo.pid}: EXECUTANDO >>> PRONTO";
          print(mensagem);
          registrarNoArquivo(mensagem);
          registrarNoArquivo(processo.toString());
        }

        if (processo.estado == "BLOQUEADO" && processo.verificaSaidaBloqueado()) {
          processo.estado = "PRONTO";
          String mensagem = "PID ${processo.pid}: BLOQUEADO >>> PRONTO";
          print(mensagem);
          registrarNoArquivo(mensagem);
          registrarNoArquivo(processo.toString());
        }
      }
    }
  }
}
