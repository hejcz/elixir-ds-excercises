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
  def add(%AVLTree{left: nil, value: node_value, height: height} = tree, value)
      when node_value > value do
    %{tree | left: %AVLTree{value: value, height: 1}, height: max(height, 2)}
  end

  # does not need to be rebalanced
  def add(%AVLTree{right: nil, value: node_value, height: height} = tree, value)
      when node_value < value do
    %{tree | right: %AVLTree{value: value, height: 1}, height: max(height, 2)}
  end

  def add(%AVLTree{left: left, value: node_value, height: height} = tree, value)
      when node_value > value do
    new_left = add(left, value)
    rebalance(%{tree | left: new_left, height: max(new_left.height + 1, height)})
  end

  def add(%AVLTree{right: right, value: node_value, height: height} = tree, value)
      when node_value < value do
    new_right = add(right, value)
    rebalance(%{tree | right: new_right, height: max(new_right.height + 1, height)})
  end

  # skip duplicates
  def add(tree, _), do: tree

  defp rebalance(tree) do
    rebalance(balance(tree), tree)
  end

  # more over left
  defp rebalance(-2, %AVLTree{left: left} = tree) do
    case balance(left) do
      1 -> rotate_right(%AVLTree{tree | left: rotate_left(left)})
      -1 -> rotate_right(tree)
    end
  end

  # more over right
  defp rebalance(2, %AVLTree{right: right} = tree) do
    case balance(right) do
      -1 -> rotate_left(%AVLTree{tree | right: rotate_right(right)})
      1 -> rotate_left(tree)
    end
  end

  defp rebalance(_, subtree), do: subtree

  defp new_node(value, left, right) do
    %AVLTree{
      value: value,
      right: right,
      left: left,
      height: max(height(left), height(right)) + 1
    }
  end

  defp rotate_left(%AVLTree{right: right, left: left, value: node_value}) do
    new_node(right.value, new_node(node_value, left, right.left), right.right)
  end

  defp rotate_right(%AVLTree{right: right, left: left, value: node_value}) do
    new_node(left.value, left.left, new_node(node_value, left.right, right))
  end

  defp balance(nil), do: 0

  defp balance(%AVLTree{left: left, right: right}), do: height(right) - height(left)

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
  defp do_delete(%AVLTree{left: left, right: right, value: node_value} = tree, value)
       when node_value > value do
    new_left = do_delete(left, value)
    rebalance(%{tree | left: new_left, height: 1 + max(height(new_left), height(right))})
  end

  # remove in right sub-tree
  defp do_delete(%AVLTree{right: right, left: left, value: node_value} = tree, value)
       when node_value < value do
    new_right = do_delete(right, value)
    rebalance(%{tree | right: new_right, height: 1 + max(height(left), height(new_right))})
  end

  # only left sub-tree
  defp do_delete(%AVLTree{left: left, right: nil, value: value}, value), do: left

  # only right sub-tree
  defp do_delete(%AVLTree{left: nil, right: right, value: value}, value), do: right

  # two sub-trees
  defp do_delete(%AVLTree{left: left, right: right, value: value}, value) do
    {min_in_right_new_left, right_new_left_without_min} = remove_min_from_new_left(right)
    rebalance(new_node(min_in_right_new_left, left, right_new_left_without_min))
  end

  defp remove_min_from_new_left(%AVLTree{left: nil, right: right, value: value}) do
    {value, right}
  end

  defp remove_min_from_new_left(%AVLTree{left: left} = tree) do
    {min_value, new_new_left} = remove_min_from_new_left(left)
    {min_value, rebalance(%{tree | left: new_new_left})}
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
