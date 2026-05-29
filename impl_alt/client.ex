defmodule EchoClient do
  def start(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port, [
      :binary,
      packet: :line,
      active: false
    ])

    IO.puts("Conectado ao servidor!")
    send_loop(socket)
  end

  defp send_loop(socket) do
    message = IO.gets("Digite uma mensagem: ")

    :gen_tcp.send(socket, message)

    {:ok, response} = :gen_tcp.recv(socket, 0)
    IO.puts("Echo: #{String.trim(response)}")

    send_loop(socket)
  end
end

EchoClient.start(~c"localhost", 4000)