package problemaLeitoresEscritores;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;

public class Processo {
    private int pid;
    private int tempoExecutado;
    private int tempoTotal;
    private int quantumRestante;
    private int ciclosCPU;
    private int eventosES;
    private String estado;

    public Processo(int pid, int tempoTotal) {
        this.pid = pid;
        this.tempoTotal = tempoTotal;
        this.tempoExecutado = 0;
        this.quantumRestante = 1000;
        this.ciclosCPU = 0;
        this.eventosES = 0;
        this.estado = "PRONTO";
    }

    public int getPid() {
        return pid;
    }

    public boolean estaFinalizado() {
        return tempoExecutado >= tempoTotal;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public void redefinirQuantum(int quantum) {
        this.quantumRestante = quantum;
    }

    public void executarCiclo(Random random) {
        if (quantumRestante > 0 && !estaFinalizado()) {
            tempoExecutado++;
            ciclosCPU++;
            quantumRestante--;

            if (random.nextInt(100) < 5) { // Simula evento de E/S
                estado = "BLOQUEADO";
                eventosES++;
            } else if (quantumRestante == 0 || estaFinalizado()) {
                estado = "PRONTO";
            }
        }
    }

    public void salvarEstado(FileWriter writer) throws IOException {
        writer.write("PID: " + pid +
                     ", Executado: " + tempoExecutado + "/" + tempoTotal +
                     ", Estado: " + estado +
                     ", Ciclos CPU: " + ciclosCPU +
                     ", Eventos E/S: " + eventosES + "\n");
    }
}
