defmodule ElixirBoilerplateGraphQL.Schema do
  use Absinthe.Schema

  alias ElixirBoilerplateGraphQL.Types.{
    Global
  }

  # Scalars
  import_types(Absinthe.Type.Custom)

  # Types
  import_types(Global)

  # Queries
  query do
    import_fields(:system_queries)
  end

  # Mutations
  # mutation do
  #  import_fields(:first_mutations)
  # end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
