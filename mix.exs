defmodule Nest.Mixfile do
  use Mix.Project

  def project do
    [ app: :nest,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [ { :eredis, "1.0.4", git: "https://github.com/wooga/eredis.git" } ]
  end
end
