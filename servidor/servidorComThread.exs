defmodule ServidorConcorrente do
  def start() do
    port = String.to_integer(System.get_env("PORT") || "5000")
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])

    IO.puts("Servidor CONCORRENTE (Micro-processos) escutando na porta #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    # 1. Fica esperando o telefone tocar
    {:ok, client_socket} = :gen_tcp.accept(socket)
    IO.puts("\n[+] Novo cliente conectado!")

    # 2. A MÁGICA: O Task.start cria um processo independente na Máquina Virtual.
    # Esse processo vai rodar a função 'serve_client' em paralelo.
    Task.start(fn -> serve_client(client_socket) end)

    # 3. Como o Task rodou em paralelo, o programa não bloqueia e
    # desce IMEDIATAMENTE para cá, ficando livre para aceitar o próximo cliente.
    loop_acceptor(socket)
  end

  defp serve_client(client_socket) do
    # A lógica da conversa é exatamente igual ao anterior
    case :gen_tcp.recv(client_socket, 0) do
      {:ok, data} ->
        IO.puts("Recebido: #{String.trim(data)}")
        :gen_tcp.send(client_socket, "Echo: #{String.trim(data)}\n")
        serve_client(client_socket)

      {:error, _motivo} ->
        IO.puts("[-] Cliente desconectou.")
        :gen_tcp.close(client_socket)
    end
  end
end

ServidorConcorrente.start()
