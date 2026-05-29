defmodule EchoServer do
  def start(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [
      :binary,
      packet: :line,
      active: false,
      reuseaddr: true
    ])

    IO.puts("Servidor escutando na porta #{port}...")
    accept_loop(listen_socket)
  end

  defp accept_loop(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    IO.puts("Cliente conectado!")

    spawn(fn -> handle_client(client_socket) end)

    accept_loop(listen_socket)
  end

  defp handle_client(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        message = String.trim(data)
        IO.puts("Recebido: #{message}")

        if message == "crash" do
          raise "Exceção artificial! Processo filho vai morrer."
        end

        :gen_tcp.send(socket, data)
        handle_client(socket)

      {:error, :closed} ->
        IO.puts("Cliente desconectou.")
    end
  end
end

EchoServer.start(4000)