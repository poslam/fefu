class Node:
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right

class PersistentTree:
    def __init__(self, root=None):
        self.root = root
        self.version = {0: self.root}

    def add_node(self, value, parent_version=0, left=None, right=None):
        parent = self.version[parent_version]
        new_node = Node(value, left, right)
        if parent is None:
            self.root = new_node
        elif parent.left is None:
            parent.left = new_node
        else:
            parent.right = new_node
        self.version[parent_version + 1] = self.root

    def get_node(self, version, node):
        if node is None:
            return None
        if version == 0:
            return node
        return self.get_node(version - 1, self.version[version].left if node == self.version[version].right else self.version[version].right)

# Example usage     
tree = PersistentTree()
tree.add_node(1)
tree.add_node(2, 1)
tree.add_node(3, 1)
tree.add_node(4, 2)
tree.add_node(5, 2)
tree.add_node(6, 3)
tree.add_node(7, 3)
tree.add_node(8, 4)
tree.add_node(9, 5)
tree.add_node(10, 6)
tree.add_node(11, 7)

# Get node with value 8 from version 2
node = tree.get_node(2, tree.root.right.left)
print(node.value)
