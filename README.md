# IFRN-2026.1-SO-Threads
Segunda atividade avaliativa do primeiro bimestre da disciplina de Sistemas Operacionais do TADS (IFRN/CNAT).

## Como Executar a Aplicação

Esta aplicação foi conteinerizada utilizando **Docker** e **Docker Compose**. Isso significa que você não precisa ter o ambiente do Elixir configurado localmente para rodar e testar o código.

### Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas no seu sistema:
* **Docker**
* **Docker Compose**

---

### Nota

O servidor padrão é com thread. Caso queira alterar para o servidor sem thread, altere o arquivo no `Dockerfile`.

---

### Passo a Passo de Execução

**1. Construir as imagens do projeto**
Abra o seu terminal na raiz do projeto e execute o comando abaixo. O Docker lerá os `Dockerfiles`, fará o download da imagem base do Elixir e empacotará o código:
```bash
docker compose build
```

**2. Iniciar o Servidor**
Suba o contêiner do servidor em segundo plano (modo *detached*). Isso manterá o servidor rodando e liberará o seu terminal para os próximos comandos:
```bash
docker compose up -d servidor
```
> **Dica de Monitoramento:** Caso queira visualizar os avisos de conexão do servidor em tempo real, execute `docker compose logs -f servidor`. Para sair da visualização dos logs, pressione `Ctrl+C`.

**3. Iniciar o Cliente e Interagir**
No mesmo terminal, inicie o cliente em modo interativo. Um prompt de chat será aberto e você poderá enviar mensagens para o servidor:
```bash
docker compose run cliente
```

**4. Testando a Concorrência (Múltiplos Clientes)**
Para comprovar a eficiência dos micro-processos do Elixir em não bloquear conexões (diferente da versão sequencial), simule acessos simultâneos:
1. Mantenha o terminal do seu primeiro cliente aberto e conectado.
2. Abra uma **nova aba ou janela** do seu terminal.
3. Inicie um segundo cliente executando `docker compose run cliente` novamente.
4. Envie mensagens de ambas as janelas. Você notará que o servidor atende a ambos concorrentemente, sem travamentos.

**5. Encerrar e Limpar o Ambiente**
Quando finalizar os seus testes, feche as sessões dos clientes digitando `sair`. Em seguida, para desligar o servidor em segundo plano e remover a rede virtual criada, execute:
```bash
docker compose down --remove-orphans
```
