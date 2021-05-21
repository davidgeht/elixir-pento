defmodule Pento.Search do
  alias Pento.Search.Item

  def search_sku_number(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)

  end
end
