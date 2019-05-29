defmodule ElixirBoilerplateGraphQL.Types.Global do
  use Absinthe.Schema.Notation

  # Queries
  object :system_queries do
    @desc "The application version"
    field :version, :string do
      resolve(fn _, _, _ -> {:ok, application_version()} end)
    end
  end

  @desc "A mutation result"
  object :mutation_result do
    field(:successful, :boolean)
  end

  defp application_version, do: Application.get_env(:elixir_boilerplate, :version)
end
