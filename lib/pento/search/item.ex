defmodule Pento.Search.Item do
  defstruct [:sku]

  @types%{sku: :integer}

  alias Pento.Search.Item
  import Ecto.Changeset

  def changeset(%Item{} = sku, attrs)do
    {sku, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:sku])
    |> validate_number(:sku, greater_than: 1000000, less_than: 9999999)
  end

end
