defmodule RBTree.Node do
  defstruct value: nil, left: nil, right: nil, color: :red
end

defmodule RBTree do
  @moduledoc """
  Difference between AVLTree and RBTree:
  1. AVL trees provide faster lookups than Red Black Trees because they are more strictly balanced.
  2. Red Black Trees provide faster insertion and removal operations than AVL trees as fewer rotations are done due to relatively relaxed balancing.
  3. AVL trees store balance factors or heights with each node, thus requires storage for an integer per node whereas Red Black Tree requires only 1 bit of information per node.
  4. Red Black Trees are used in most of the language libraries like map, multimap, multiset in C++ whereas AVL trees are used in databases where faster retrievals are required.
  """

  alias RBTree.Node

  def empty do
    %RBTree.Node{}
  end

  def add(%Node{value: nil}, value) do
    %Node{value: value, color: :black}
  end

  def add(tree, value) do
    %Node{do_add(tree, value) | color: :black}
  end

  defp do_add(nil, value), do: %Node{value: value}

  defp do_add(tree, value) do
    node_value = tree.value

    cond do
      node_value > value -> repaint(%{tree | left: do_add(tree.left, value)}, value)
      node_value < value -> repaint(%{tree | right: do_add(tree.right, value)}, value)
      true -> tree
    end
  end

  defp repaint(
         tree = %Node{
           value: grandparent_value,
           right: %Node{value: right_value},
           left: %Node{value: left_value}
         },
         value
       ) do
    cond do
      grandparent_value > value and left_value > value ->
        repaint(tree, tree.left, tree.right, tree.left.left)

      grandparent_value > value and left_value < value ->
        repaint(tree, tree.left, tree.right, tree.left.right)

      grandparent_value < value and right_value > value ->
        repaint(tree, tree.right, tree.left, tree.right.left)

      grandparent_value < value and right_value < value ->
        repaint(tree, tree.right, tree.left, tree.right.right)

      true ->
        tree
    end
  end

  defp repaint(tree, _), do: tree

  defp repaint(grandparent, parent, uncle, node)

  defp repaint(grandparent, _, _, nil), do: grandparent

  defp repaint(grandparent = %Node{color: color}, _, _, %Node{color: color}),
    do: grandparent

  defp repaint(
         grandparent = %Node{value: grandparent_value},
         parent = %Node{color: :red, value: parent_value},
         uncle = %Node{color: :red},
         %Node{color: :red}
       ) do
    left = if grandparent_value > parent_value, do: parent, else: uncle
    right = if left == parent, do: uncle, else: parent

    %Node{
      grandparent
      | right: %Node{right | color: :black},
        left: %Node{left | color: :black},
        color: :red
    }
  end

  defp repaint(
         grandparent = %Node{value: grandparent_value},
         parent = %Node{color: :red, value: parent_value},
         _uncle = %Node{color: :black},
         node = %Node{color: :red, value: value}
       ) do
    cond do
      # left left
      grandparent_value > parent_value and parent_value > value ->
        %Node{parent | color: :black, right: %Node{grandparent | left: parent.right, color: :red}}

      # right right
      grandparent_value < parent_value and parent_value < value ->
        %Node{parent | color: :black, left: %Node{grandparent | right: parent.left, color: :red}}

      # left rigth
      grandparent_value > parent_value and parent_value < value ->
        %Node{
          node
          | color: :black,
            left: %Node{parent | right: node.left},
            right: %Node{grandparent | color: :red, left: node.right}
        }

      # right left
      grandparent_value < parent_value and parent_value > value ->
        %Node{
          node
          | color: :black,
            right: %Node{parent | left: node.right},
            left: %Node{grandparent | color: :red, right: node.left}
        }
    end
  end

  defp repaint(grandparent, _, _, _), do: grandparent

  def delete(_, _), do: nil
end

defimpl Tree, for: RBTree do
  def right(%RBTree.Node{right: right}), do: right
  def left(%RBTree.Node{left: left}), do: left
  def value(%RBTree.Node{value: value}), do: value
  def add(tree, value), do: RBTree.add(tree, value)
  def delete(tree, value), do: RBTree.delete(tree, value)
end
