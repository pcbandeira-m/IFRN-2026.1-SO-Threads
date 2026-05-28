defmodule Cliente do
  def start() do
    # Busca o nome do servidor no Docker
    host = System.get_env("HOST") || "localhost"
    port = String.to_integer(System.get_env("PORT") || "5000")

    IO.puts("Conectando ao servidor em #{host}:#{port}...")

    # O Erlang exige que endereços web sejam charlists (lista de caracteres) em vez de Strings puras
    {:ok, socket} = :gen_tcp.connect(String.to_charlist(host), port, [:binary, active: false])

    IO.puts("Conectado! Digite uma mensagem (ou 'sair' para encerrar):")
    loop_conversa(socket)
  end

  defp loop_conversa(socket) do
    # IO.gets pausa o programa e espera você digitar algo no terminal
    mensagem = IO.gets("Você: ") |> String.trim()

    if mensagem == "sair" do
      IO.puts("Desconectando...")
      :gen_tcp.close(socket)
    else
      # Envia a mensagem com uma quebra de linha
      :gen_tcp.send(socket, mensagem <> "\n")

      # Fica aguardando a resposta do servidor
      {:ok, resposta} = :gen_tcp.recv(socket, 0)
      IO.puts("Servidor: #{String.trim(resposta)}\n")

      # Repete o ciclo
      loop_conversa(socket)
    end
  end
end

Cliente.start()
