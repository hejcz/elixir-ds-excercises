defprotocol Tree do
  def right(tree)
  def left(tree)
  def value(tree)
  def add(tree, value)
  def delete(tree, value)
end

defmodule GeneralTreeAlgorithms do
  def min(tree) do
    case Tree.left(tree) do
      nil -> Tree.value(tree)
      _ -> min(Tree.left(tree))
    end
  end

  def max(tree) do
    case Tree.right(tree) do
      nil -> Tree.value(tree)
      _ -> max(Tree.right(tree))
    end
  end

  def to_sorted_list(tree) do
    to_sorted_list(tree, [])
  end

  defp to_sorted_list(nil, acc) do
    acc
  end

  defp to_sorted_list(tree, acc) do
    to_sorted_list(Tree.left(tree), [Tree.value(tree) | to_sorted_list(Tree.right(tree), acc)])
  end

  def contains?(nil, _), do: false

  def contains?(tree, value) do
    node_value = Tree.value(tree)

    cond do
      node_value == value -> true
      node_value > value -> contains?(Tree.left(tree), value)
      node_value < value -> contains?(Tree.right(tree), value)
    end
  end
end
