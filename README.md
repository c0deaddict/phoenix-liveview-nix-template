# Phoenix LiveView template with Nix support

This is a [Phoenix](https://www.phoenixframework.org/) [LiveView](https://hexdocs.pm/phoenix_live_view/welcome.html) template with Nix support.

## Initial generated template (first commit)

```bash
mix local.hex
mix archive.install hex phx_new
mix phx.new demo --live --database postgres
```

## Build and run the server

```bash
nix build .#
PHX_SERVER=true PORT=4000 SECRET_KEY_BASE=$(pwgen -s1 64) DATABASE_URL=ecto://postgres:postgres@localhost:5433/demo_dev RELEASE_COOKIE=xyz result/bin/demo start
```

# Demo

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
