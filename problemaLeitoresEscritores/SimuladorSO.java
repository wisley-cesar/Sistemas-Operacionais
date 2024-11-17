package problemaLeitoresEscritores;

public class SimuladorSO {
    public static void main(String[] args) {
        GerenciadorDeProcessos gerenciador = new GerenciadorDeProcessos();
        gerenciador.inicializarProcessos(10); // Inicializa 10 processos
        gerenciador.executarProcessos(); // Executa a simulação
    }
}
