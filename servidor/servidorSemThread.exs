defmodule ServidorSequencial do
  def start() do
    # Pega a porta do Docker, se não achar, usa 5000
    port = String.to_integer(System.get_env("PORT") || "5000")
    
    # Abre o socket. :binary = dados brutos, active: false = controle manual de leitura
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    
    IO.puts("Servidor SEQUENCIAL (Bloqueante) escutando na porta #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    # 1. Fica esperando o telefone tocar
    {:ok, client_socket} = :gen_tcp.accept(socket)
    IO.puts("\n[+] Novo cliente conectado!")

    # 2. BLOQUEIO GERAL: O servidor entra na função abaixo e fica 
    # preso lá dentro até o cliente desligar. Ele não desce para a próxima linha.
    serve_client(client_socket)

    # 3. Só volta a esperar ligações DEPOIS que o cliente atual desconectar
    loop_acceptor(socket)
  end

  defp serve_client(client_socket) do
    case :gen_tcp.recv(client_socket, 0) do
      {:ok, data} ->
        # Se recebeu texto, imprime e manda de volta
        mensagem = String.trim(data)
        IO.puts("Recebido: #{mensagem}")
        :gen_tcp.send(client_socket, "Echo: #{mensagem}\n")
        
        # Chama a si mesmo para continuar ouvindo ESTE MESMO cliente
        serve_client(client_socket)

      {:error, _motivo} ->
        # Se o cliente mandou o sinal de fechar, encerra
        IO.puts("[-] Cliente desconectou.")
        :gen_tcp.close(client_socket)
    end
  end
end

# Dispara a função principal quando rodamos o arquivo
ServidorSequencial.start()