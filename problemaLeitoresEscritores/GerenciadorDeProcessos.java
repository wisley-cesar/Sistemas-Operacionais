package problemaLeitoresEscritores;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import problemaLeitoresEscritores.Processo;


public class GerenciadorDeProcessos {
    private static final int QUANTUM = 1000;
    private static final String FILE_PATH = "simulacao_processos.txt";

    private List<Processo> processos;
    private Random random;

    public GerenciadorDeProcessos() {
        this.processos = new ArrayList<>();
        this.random = new Random();
    }

    public void inicializarProcessos(int quantidade) {
        for (int i = 0; i < quantidade; i++) {
            int tempoTotal = random.nextInt(10000) + 1000; // Gera tempos aleatórios entre 1000 e 10.000
            processos.add(new Processo(i, tempoTotal));
        }
    }

    public void executarProcessos() {
        try (FileWriter writer = new FileWriter(FILE_PATH)) {
            boolean processosAtivos;

            do {
                processosAtivos = false;

                for (Processo processo : processos) {
                    if (processo.estaFinalizado()) continue;

                    processosAtivos = true;
                    processo.setEstado("EXECUTANDO");
                    System.out.println("Executando Processo PID: " + processo.getPid());

                    for (int i = 0; i < QUANTUM; i++) {
                        processo.executarCiclo(random);
                        if (processo.getEstado().equals("BLOQUEADO")) break;
                    }

                    if (processo.estaFinalizado()) {
                        System.out.println("Processo PID " + processo.getPid() + " finalizado.");
                    } else if (processo.getEstado().equals("BLOQUEADO")) {
                        System.out.println("Processo PID " + processo.getPid() + " bloqueado.");
                        if (random.nextInt(100) < 50) { // Chance de desbloqueio
                            processo.setEstado("PRONTO");
                        }
                    } else {
                        processo.setEstado("PRONTO");
                    }

                    processo.redefinirQuantum(QUANTUM);
                    processo.salvarEstado(writer);
                }
            } while (processosAtivos);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
