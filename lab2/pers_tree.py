from math import ceil, log2


def is_2_power(num: int) -> bool:
    return num & (num - 1) == 0


class Node:

    def __init__(self, left: "Node",
                 right: "Node", l_ind: int,
                 r_ind: int, is_leaf: bool, val: int):

        self.left = left
        self.right = right
        self.l_ind = l_ind
        self.r_ind = r_ind
        self.is_leaf = is_leaf
        self.val = val


class PersTree:

    def __init__(self, elements: list[int]):

        self.real_nodes_count: int = None
        self.nodes_count: int = None
        self.height: int = None
        self.roots: list[Node] = []

        len_of_elements = len(elements)

        if not is_2_power(len_of_elements):
            self.real_nodes_count = int(2**(ceil(log2(len_of_elements))))

        else:
            self.real_nodes_count = len_of_elements

        self.nodes_count = self.real_nodes_count * 2 - 1
        self.height = int(log2(self.real_nodes_count + 1))

        cur_layer: list[Node] = []
        prev_layer: list[Node] = []

        for i in range(self.real_nodes_count):
            val = elements[i] if i < len_of_elements else 0
            cur_layer.append(Node(None, None, i, i, True, val))

        cur_layer, prev_layer = prev_layer, cur_layer

        while len(prev_layer) != 1:
            for i in range(len(prev_layer)//2):
                left = prev_layer[2*i]
                right = prev_layer[2*i + 1]
                val = left.val + right.val
                l_ind = left.l_ind
                r_ind = right.r_ind

                cur_layer.append(Node(left, right, l_ind, r_ind, False, val))

            cur_layer, prev_layer = prev_layer, cur_layer
            cur_layer.clear()

        self.roots.append(prev_layer[0])

    def set_elem(self, version: int = None,
                 pos: int = None, val: int = None,
                 cur_node: Node = None):

        if cur_node == None:
            cur_node = self.roots[version]

        if cur_node.is_leaf:
            node = Node(None, None, pos, pos, True, val)
            return node

        else:
            if pos <= cur_node.left.r_ind:
                l_node = self.set_elem(None, pos, val, cur_node.left)
                r_node = cur_node.right

            else:
                l_node = cur_node.left
                r_node = self.set_elem(None, pos, val, cur_node.right)

            val = l_node.val + r_node.val

            node = Node(l_node, r_node, cur_node.l_ind,
                        cur_node.r_ind, False, val)

            return node

    def get_sum(self, version: int = None,
                l: int = None, r: int = None,
                cur_node: Node = None):

        if cur_node == None:
            cur_node = self.roots[version]

        if cur_node.l_ind - cur_node.r_ind > 0:
            return 0

        elif cur_node.l_ind == l and cur_node.r_ind == r:
            return cur_node.val

        else:
            if not cur_node.is_leaf:
                l_sum = self.get_sum(None,
                                     max(cur_node.left.l_ind, l),
                                     max(cur_node.left.r_ind, r),
                                     cur_node.left)

                r_sum = self.get_sum(None,
                                     max(cur_node.right.l_ind, l),
                                     max(cur_node.right.r_ind, r),
                                     cur_node.right)

                return l_sum + r_sum

            else:
                return 0

    def get_elem(self, version: int, pos: int):

        return self.get_sum(version, pos, pos)
