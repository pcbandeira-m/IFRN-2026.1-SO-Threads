FROM elixir:alpine

WORKDIR /app
COPY servidor/ .

# Comando padrão ao ligar o contêiner (concorrente como padrão)
CMD ["elixir", "servidorComThread.exs"]