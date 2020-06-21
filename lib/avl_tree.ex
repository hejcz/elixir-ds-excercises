defmodule AVLTree do
  @moduledoc """
  Simple binary tree that:
  - skips duplicated values
  """

  defstruct value: nil, left: nil, right: nil, height: 0

  def empty do
    %AVLTree{}
  end

  def add(%AVLTree{value: nil}, value) do
    %AVLTree{value: value, height: 1}
  end

  # does not need to be rebalanced
  def add(%AVLTree{left: nil, value: node_value, height: height} = tree, value) when node_value > value do
    %{tree | left: %AVLTree{value: value, height: 1}, height: max(height, 2)}
  end

  # does not need to be rebalanced
  def add(%AVLTree{right: nil, value: node_value, height: height} = tree, value) when node_value < value do
    %{tree | right: %AVLTree{value: value, height: 1}, height: max(height, 2)}
  end

  def add(%AVLTree{left: left, value: node_value, height: height} = tree, value) when node_value > value do
    new_left = add(left, value)
    new_subtree = %{tree | left: new_left, height: max(new_left.height + 1, height)}
    rebalance(balance(new_subtree), new_subtree)
  end

  def add(%AVLTree{right: right, value: node_value, height: height} = tree, value) when node_value < value do
    new_right = add(right, value)
    new_subtree = %{tree | right: new_right, height: max(new_right.height + 1, height)}
    rebalance(balance(new_subtree), new_subtree)
  end

  # skip duplicates
  def add(tree, _), do: tree

  # more over left
  defp rebalance(2, %AVLTree{left: left, right: right, value: node_value}) do
    %AVLTree{value: left.value, left: left.left, right: %AVLTree{value: node_value, left: left.right, right: right, height: height(right) + 1}, height: left.height}
  end

  # more over right
  defp rebalance(-2, %AVLTree{left: left, right: right, value: node_value}) do
    %AVLTree{value: right.value, right: right.right, left: %AVLTree{value: node_value, right: right.left, left: left, height: height(left) + 1}, height: right.height}
  end

  defp rebalance(_, subtree), do: subtree

  defp balance(%AVLTree{left: left, right: right}), do: height(left) - height(right)

  defp height(nil), do: 0

  defp height(%AVLTree{height: height}), do: height

  def contains?(%AVLTree{value: value}, value), do: true

  def contains?(%AVLTree{right: right, value: node_value}, value) when node_value < value do
    case right do
      nil -> false
      _ -> contains?(right, value)
    end
  end

  def contains?(%AVLTree{left: left, value: node_value}, value) when node_value > value do
    case left do
      nil -> false
      _ -> contains?(left, value)
    end
  end

  # remove root
  def delete(%AVLTree{left: nil, right: nil, value: value}, value), do: empty()

  # remove internal node or leaf
  def delete(tree, value), do: do_delete(tree, value)

  # no sub-trees
  defp do_delete(%AVLTree{left: nil, right: nil, value: value}, value), do: nil

  defp do_delete(nil, _), do: nil

  # remove in left sub-tree
  defp do_delete(%AVLTree{left: left, value: node_value} = tree, value)
       when node_value > value do
    %{tree | left: do_delete(left, value)}
  end

  # remove in right sub-tree
  defp do_delete(%AVLTree{right: right, value: node_value} = tree, value)
       when node_value < value do
    %{tree | right: do_delete(right, value)}
  end

  # only left sub-tree
  defp do_delete(%AVLTree{left: left, right: nil, value: value}, value), do: left

  # only right sub-tree
  defp do_delete(%AVLTree{left: nil, right: right, value: value}, value), do: right

  # two sub-trees
  defp do_delete(%AVLTree{left: left, right: right, value: value}, value) do
    {min_in_right_new_left, right_new_left_without_min} = remove_min_from_new_left(right)
    %AVLTree{value: min_in_right_new_left, left: left, right: right_new_left_without_min}
  end

  defp remove_min_from_new_left(%AVLTree{left: nil, right: right, value: value}) do
    {value, right}
  end

  defp remove_min_from_new_left(%AVLTree{left: left, right: right, value: value} = tree) do
    {min_value, new_new_left} = remove_min_from_new_left(left)
    {min_value, %{tree | left: new_new_left, right: right, value: value}}
  end

  def to_sorted_list(tree) do
    to_sorted_list(tree, [])
  end

  defp to_sorted_list(nil, acc) do
    acc
  end

  defp to_sorted_list(%AVLTree{left: left, right: right, value: value}, acc) do
    to_sorted_list(left, [value | to_sorted_list(right, acc)])
  end

  def min(%AVLTree{left: left, value: value}) do
    case left do
      nil -> value
      _ -> min(left)
    end
  end

  def max(%AVLTree{right: right, value: value}) do
    case right do
      nil -> value
      _ -> max(right)
    end
  end

end
