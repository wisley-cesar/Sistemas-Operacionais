class AlgoritimosGerenciamento {
  List<int> memoria = List.filled(32, 0);
  int ultimoIndice = 0;
  Map<int, List<int>> mapaBuracos = {};

  int algoritmoFirstFit(int tamanhoProcesso) {
    int memoriaTotal = memoria.length;
    int espacoLivre = 0;

    for (int i = 0; i < memoriaTotal; i++) {
      if (memoria[i] == 0) {
        espacoLivre++;
      } else {
        espacoLivre = 0;
      }

      if (espacoLivre == tamanhoProcesso) {
        for (int j = i - tamanhoProcesso + 1; j <= i; j++) {
          memoria[j] = 1;
        }
        return i - tamanhoProcesso + 1;
      }
    }

    return -1;
  }

  int algoritmoNextFit(int tamanhoProcesso) {
    int memoriaTotal = memoria.length;
    int espacoLivre = 0;

    for (int i = ultimoIndice; i < memoriaTotal + ultimoIndice; i++) {
      int indiceAtual = i % memoriaTotal;

      if (memoria[indiceAtual] == 0) {
        espacoLivre++;
      } else {
        espacoLivre = 0;
      }

      if (espacoLivre == tamanhoProcesso) {
        if (indiceAtual - tamanhoProcesso + 1 >= 0) {
          for (int j = indiceAtual - tamanhoProcesso + 1;
              j <= indiceAtual;
              j++) {
            memoria[j] = 1;
          }
          ultimoIndice = indiceAtual + 1;
          return indiceAtual - tamanhoProcesso + 1;
        }
      }
    }

    return -1;
  }

  int algoritmoBestFit(int tamanhoProcesso) {
    int memoriaTotal = memoria.length;
    int melhorIndice = -1;
    int menorBuraco = memoriaTotal + 1;

    for (int i = 0; i < memoriaTotal; i++) {
      if (memoria[i] == 0) {
        int espacoLivre = 0;

        while (
            i + espacoLivre < memoriaTotal && memoria[i + espacoLivre] == 0) {
          espacoLivre++;
        }

        if (espacoLivre >= tamanhoProcesso && espacoLivre < menorBuraco) {
          melhorIndice = i;
          menorBuraco = espacoLivre;
        }

        i += espacoLivre - 1;
      }
    }

    if (melhorIndice != -1) {
      for (int i = melhorIndice; i < melhorIndice + tamanhoProcesso; i++) {
        memoria[i] = 1;
      }
      return melhorIndice;
    }

    return -1;
  }

  void atualizarMapaBuracos() {
    mapaBuracos.clear();
    int memoriaTotal = memoria.length;

    for (int i = 0; i < memoriaTotal; i++) {
      if (memoria[i] == 0) {
        int espacoLivre = 0;

        while (
            i + espacoLivre < memoriaTotal && memoria[i + espacoLivre] == 0) {
          espacoLivre++;
        }

        if (!mapaBuracos.containsKey(espacoLivre)) {
          mapaBuracos[espacoLivre] = [];
        }
        mapaBuracos[espacoLivre]!.add(i);

        i += espacoLivre - 1;
      }
    }
  }

  int algoritmoQuickFit(int tamanhoProcesso) {
    atualizarMapaBuracos();

    for (int tamanho in mapaBuracos.keys) {
      if (tamanho >= tamanhoProcesso) {
        int indiceInicio = mapaBuracos[tamanho]!
            .removeAt(0); // Remove o primeiro índice disponível.

        for (int i = indiceInicio; i < indiceInicio + tamanhoProcesso; i++) {
          memoria[i] = 1;
        }

        if (tamanho > tamanhoProcesso) {
          int buracoRestante = tamanho - tamanhoProcesso;
          int novoIndice = indiceInicio + tamanhoProcesso;

          if (!mapaBuracos.containsKey(buracoRestante)) {
            mapaBuracos[buracoRestante] = [];
          }
          mapaBuracos[buracoRestante]!.add(novoIndice);
        }

        return indiceInicio;
      }
    }

    return -1;
  }

  int algoritmoWorstFit(int tamanhoProcesso) {
    int memoriaTotal = memoria.length;
    int piorIndice = -1;
    int maiorBuraco = 0;

    for (int i = 0; i < memoriaTotal; i++) {
      if (memoria[i] == 0) {
        int espacoLivre = 0;

        while (
            i + espacoLivre < memoriaTotal && memoria[i + espacoLivre] == 0) {
          espacoLivre++;
        }

        if (espacoLivre >= tamanhoProcesso && espacoLivre > maiorBuraco) {
          piorIndice = i;
          maiorBuraco = espacoLivre;
        }

        i += espacoLivre - 1;
      }
    }

    if (piorIndice != -1) {
      for (int i = piorIndice; i < piorIndice + tamanhoProcesso; i++) {
        memoria[i] = 1;
      }
      return piorIndice;
    }

    return -1;
  }

  void desalocarProcesso(int indiceInicio, int tamanhoProcesso) {
    for (int i = indiceInicio; i < indiceInicio + tamanhoProcesso; i++) {
      memoria[i] = 0;
    }
    print(
        'Processo desalocado nos blocos $indiceInicio até ${indiceInicio + tamanhoProcesso - 1}');
  }
}
