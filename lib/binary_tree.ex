defmodule BSTree do
  @moduledoc """
  Simple binary tree that:
  - skips duplicated values
  """

  defstruct value: nil, left: nil, right: nil

  def empty do
    %BSTree{}
  end

  def add(%BSTree{value: nil}, value) do
    %BSTree{value: value}
  end

  def add(%BSTree{left: nil, value: node_value} = tree, value) when node_value > value do
    %{tree | left: %BSTree{value: value}}
  end

  def add(%BSTree{left: left, value: node_value} = tree, value) when node_value > value do
    %{tree | left: add(left, value)}
  end

  def add(%BSTree{right: nil, value: node_value} = tree, value) when node_value < value do
    %{tree | right: %BSTree{value: value}}
  end

  def add(%BSTree{right: right, value: node_value} = tree, value) when node_value < value do
    %{tree | right: add(right, value)}
  end

  # skip duplicates
  def add(tree, _), do: tree

  def contains?(%BSTree{value: node_value}, node_value), do: true

  def contains?(%BSTree{right: nil, value: node_value}, value) when node_value < value do
    false
  end

  def contains?(%BSTree{right: right, value: node_value}, value) when node_value < value do
    contains?(right, value)
  end

  def contains?(%BSTree{left: nil, value: node_value}, value) when node_value > value do
    false
  end

  def contains?(%BSTree{left: left, value: node_value}, value) when node_value > value do
    contains?(left, value)
  end

  # remove root
  def delete(%BSTree{left: nil, right: nil, value: value}, value), do: empty()

  # remove internal node or leaf
  def delete(tree, value), do: do_delete(tree, value)

  defp do_delete(tree, value)

  defp do_delete(%BSTree{left: nil, right: nil, value: value}, value), do: nil

  defp do_delete(nil, _), do: nil

  defp do_delete(%BSTree{left: left, value: node_value} = tree, value)
       when node_value > value do
    %{tree | left: do_delete(left, value)}
  end

  defp do_delete(%BSTree{right: right, value: node_value} = tree, value)
       when node_value < value do
    %{tree | right: do_delete(right, value)}
  end

  defp do_delete(%BSTree{left: left, right: nil, value: value}, value), do: left

  defp do_delete(%BSTree{left: nil, right: right, value: value}, value), do: right

  defp do_delete(%BSTree{left: left, right: right, value: value}, value) do
    {min_in_right_subtree, right_subtree_without_min} = delete_min_from_subtree(right)
    %BSTree{value: min_in_right_subtree, left: left, right: right_subtree_without_min}
  end

  defp delete_min_from_subtree(%BSTree{left: nil, right: right, value: value}) do
    {value, right}
  end

  defp delete_min_from_subtree(%BSTree{left: left, right: right, value: value} = tree) do
    {min_value, new_subtree} = delete_min_from_subtree(left)
    {min_value, %{tree | left: new_subtree, right: right, value: value}}
  end
end
