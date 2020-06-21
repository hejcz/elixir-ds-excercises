defmodule GeneralTreeAlgorithmsTest do
  use ExUnit.Case
  doctest GeneralTreeAlgorithms

  test "BS min" do
    tree = BSTree.empty() |> BSTree.add(4) |> BSTree.add(1) |> BSTree.add(5) |> BSTree.add(0)
    assert GeneralTreeAlgorithms.min(tree) == 0
  end

  test "AVL min" do
    tree = AVLTree.empty() |> AVLTree.add(4) |> AVLTree.add(1) |> AVLTree.add(5) |> AVLTree.add(-1)
    assert GeneralTreeAlgorithms.min(tree) == -1
  end

  test "BS max" do
    tree = BSTree.empty() |> BSTree.add(4) |> BSTree.add(1) |> BSTree.add(5) |> BSTree.add(0)
    assert GeneralTreeAlgorithms.max(tree) == 5
  end

  test "AVL max" do
    tree = AVLTree.empty() |> AVLTree.add(4) |> AVLTree.add(1) |> AVLTree.add(6) |> AVLTree.add(-1)
    assert GeneralTreeAlgorithms.max(tree) == 6
  end

  test "BS to list" do
    tree = BSTree.empty() |> BSTree.add(4) |> BSTree.add(1) |> BSTree.add(5) |> BSTree.add(0)
    assert GeneralTreeAlgorithms.to_sorted_list(tree) == [0, 1, 4, 5]
  end

  test "AVL to list" do
    tree = AVLTree.empty() |> AVLTree.add(4) |> AVLTree.add(1) |> AVLTree.add(6) |> AVLTree.add(-1)
    assert GeneralTreeAlgorithms.to_sorted_list(tree) == [-1, 1, 4, 6]
  end
end
