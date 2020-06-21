defprotocol Tree do
  def right(tree)
  def left(tree)
  def value(tree)
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
end
