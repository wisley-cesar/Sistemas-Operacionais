import 'processo.dart';

void main() {
  List<Processo> processos = [
    Processo(0, 10000),
    Processo(1, 5000),
    Processo(2, 7000),
    Processo(3, 3000),
    Processo(4, 3000),
    Processo(5, 8000),
    Processo(6, 2000),
    Processo(7, 5000),
    Processo(8, 4000),
    Processo(9, 10000),
  ];

  SistemaOperacional so = SistemaOperacional(processos);
  so.executarProcessos();
}