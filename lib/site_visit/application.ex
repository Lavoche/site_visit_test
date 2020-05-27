defmodule SiteVisit.Application do

  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http, 
        plug: SiteVisit.Endpoint, 
        options: [port: 8085]
        )
    ]

    opts = [strategy: :one_for_one, name: SiteVisit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
