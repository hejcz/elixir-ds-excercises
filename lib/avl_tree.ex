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

  def add(%AVLTree{value: node_value} = tree, value)
      when node_value > value do
    case tree.left do
      nil ->
        %{tree | left: %AVLTree{value: value, height: 1}, height: max(tree.height, 2)}

      _ ->
        new_left = add(tree.left, value)
        rebalance(%{tree | left: new_left, height: max(new_left.height + 1, tree.height)})
    end
  end

  def add(%AVLTree{value: node_value} = tree, value)
      when node_value < value do
    case tree.right do
      nil ->
        %{tree | right: %AVLTree{value: value, height: 1}, height: max(tree.height, 2)}

      _ ->
        new_right = add(tree.right, value)
        rebalance(%{tree | right: new_right, height: max(new_right.height + 1, tree.height)})
    end
  end

  def add(tree, _), do: tree

  defp rebalance(tree) do
    rebalance(balance(tree), tree)
  end

  # more over left
  defp rebalance(-2, tree) do
    case balance(tree.left) do
      1 -> rotate_right(%AVLTree{tree | left: rotate_left(tree.left)})
      -1 -> rotate_right(tree)
    end
  end

  # more over right
  defp rebalance(2, tree) do
    case balance(tree.right) do
      -1 -> rotate_left(%AVLTree{tree | right: rotate_right(tree.right)})
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

  defp rotate_left(tree) do
    new_node(tree.right.value, new_node(tree.value, tree.left, tree.right.left), tree.right.right)
  end

  defp rotate_right(tree) do
    new_node(tree.left.value, tree.left.left, new_node(tree.value, tree.left.right, tree.right))
  end

  defp balance(nil), do: 0

  defp balance(tree), do: height(tree.right) - height(tree.left)

  defp height(nil), do: 0

  defp height(tree), do: tree.height

  # remove root
  def delete(%AVLTree{left: nil, right: nil, value: value}, value), do: empty()

  # remove internal node or leaf
  def delete(tree, value), do: do_delete(tree, value)

  # no sub-trees
  defp do_delete(%AVLTree{left: nil, right: nil, value: value}, value), do: nil

  defp do_delete(nil, _), do: nil

  # remove in left sub-tree
  defp do_delete(%AVLTree{value: node_value} = tree, value)
       when node_value > value do
    new_left = do_delete(tree.left, value)
    rebalance(%{tree | left: new_left, height: 1 + max(height(new_left), height(tree.right))})
  end

  # remove in right sub-tree
  defp do_delete(%AVLTree{value: node_value} = tree, value)
       when node_value < value do
    new_right = do_delete(tree.right, value)
    rebalance(%{tree | right: new_right, height: 1 + max(height(tree.left), height(new_right))})
  end

  # only left sub-tree
  defp do_delete(%AVLTree{left: left, right: nil, value: value}, value), do: left

  # only right sub-tree
  defp do_delete(%AVLTree{left: nil, right: right, value: value}, value), do: right

  # two sub-trees
  defp do_delete(%AVLTree{value: value} = tree, value) do
    {min_in_right_new_left, right_new_left_without_min} = remove_min_from_subtree(tree.right)
    rebalance(new_node(min_in_right_new_left, tree.left, right_new_left_without_min))
  end

  defp remove_min_from_subtree(%AVLTree{left: nil, right: right, value: value}) do
    {value, right}
  end

  defp remove_min_from_subtree(tree) do
    {min_value, new_new_left} = remove_min_from_subtree(tree.left)
    {min_value, rebalance(%{tree | left: new_new_left})}
  end
end

defimpl Tree, for: AVLTree do
  def right(%AVLTree{right: right}), do: right
  def left(%AVLTree{left: left}), do: left
  def value(%AVLTree{value: value}), do: value
  def add(tree, value), do: AVLTree.add(tree, value)
  def delete(tree, value), do: AVLTree.delete(tree, value)
end
