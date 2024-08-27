defmodule Proxy do
  def start_proxy() do
    {:ok, proxysock} = :gen_tcp.listen(8080, [:binary, active: false, reuseaddr: true])
    IO.puts("PROXY LISTENING ON PORT 8080")
    accept_loop(proxysock)
  end

  def accept_loop(proxysock) do
    {:ok, clientsock} = :gen_tcp.accept(proxysock)
    spawn(fn -> client_handler(clientsock) end)
    accept_loop(proxysock)
  end

  def client_handler(clientsock) do
    IO.puts("")
    IO.puts("CONNECTED TO CLIENT")
    listen_loop(clientsock)
  end

  defp listen_loop(clientsock) do
    case :gen_tcp.recv(clientsock, 0) do
      {:ok, data} ->
        IO.inspect(data, label: "Received data", limit: :infinity)
        listen_loop(clientsock)
      {:error, :closed} ->
        IO.puts("Client disconnected")
      {:error, reason} ->
        IO.puts("Error receiving data: #{inspect(reason)}")
    end
  end
end
