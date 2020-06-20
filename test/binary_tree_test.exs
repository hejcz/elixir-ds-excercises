defmodule BinaryTreeTest do
  use ExUnit.Case
  doctest BSTree

  import BSTree

  test "does not add duplicates" do
    assert BSTree.empty() |> BSTree.add(4) |> BSTree.add(4) ==
             BSTree.empty() |> BSTree.add(4)
  end

  test "contains" do
    tree = example_tree()
    assert contains?(tree, 4) == true
    assert contains?(tree, 11) == true
    assert contains?(tree, 22) == false
    assert contains?(tree, 1) == false
  end

  test "remove leaf" do
    tree = example_tree()

    assert tree |> BSTree.delete(4) ==
             Enum.reduce(
               [6, 3, 10, 8, 12, 7, 11, 13],
               BSTree.empty(),
               &BSTree.add(&2, &1)
             )
  end

  test "remove node with single subtree" do
    tree = example_tree()

    assert tree |> BSTree.delete(8) ==
             Enum.reduce(
               [6, 3, 10, 4, 12, 7, 11, 13],
               BSTree.empty(),
               &BSTree.add(&2, &1)
             )
  end

  test "remove node with two subtrees" do
    tree = example_tree()

    assert tree |> BSTree.delete(12) ==
             Enum.reduce(
               [6, 3, 10, 4, 8, 13, 7, 11],
               BSTree.empty(),
               &BSTree.add(&2, &1)
             )
  end

  test "remove node with two subtrees 2" do
    tree = example_tree()

    assert tree |> BSTree.delete(10) ==
             Enum.reduce(
               [6, 3, 11, 4, 8, 12, 7, 13],
               BSTree.empty(),
               &BSTree.add(&2, &1)
             )
  end

  test "remove all nodes but one" do

    tree = example_tree()

    assert tree |> delete(10) |> delete(6) |> delete(12) ==
             Enum.reduce(
               [7, 3, 4, 11, 8, 13],
               empty(),
               & add(&2, &1)
             )
  end

  test "remove from empty node" do
    assert empty() |> delete(10) == empty()
  end

  test "remove value from root" do
    assert empty() |> add(10) |> delete(10) == empty()
  end

  defp example_tree do
    Enum.reduce([6, 3, 10, 4, 8, 12, 7, 11, 13], BSTree.empty(), &BSTree.add(&2, &1))
  end
end
