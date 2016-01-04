defmodule PersonalTwitterBot do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    case Application.get_env(:extwitter, :oauth) do
      nil ->
        ExTwitter.configure(
          consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
          consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
          access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
          access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
        )
      _ -> :ok
    end
 
    children = [
      # Start the endpoint when the application starts
      supervisor(PersonalTwitterBot.Endpoint, []),
      worker(Database, []),
      worker(TwitterStream, ["apple"])
      # Here you could define other workers and supervisors as children
      # worker(PersonalTwitterBot.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PersonalTwitterBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PersonalTwitterBot.Endpoint.config_change(changed, removed)
    :ok
  end
end
