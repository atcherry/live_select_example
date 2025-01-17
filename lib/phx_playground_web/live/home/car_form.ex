defmodule PhxPlayground.CarForm do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :dealer, :string

    embeds_many :cars, Cars, primary_key: false do
      field :make, :string
      field :model, :string
    end
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:dealer])
    |> cast_embed(:cars, with: &cars_changeset/2)
  end

  defp cars_changeset(schema, params) do
    schema
    |> cast(params, [:make, :model])
  end
end
