# -*- coding: utf-8 -*-
"""
Grupo al058
92438 Catarina Carreiro
92440 Cristiano Clemente
"""

import numpy as np
import math


def createdecisiontree(D, Y, noise=False):
    examples = np.concatenate((D, np.reshape(Y, (-1, 1))), axis=1)
    attributes = list(range(0, len(D[0])))

    short_tree = decision_tree_learning(examples, attributes)
    
    if(noise):
        short_tree = chi_squared_pruning(short_tree, examples)

    return short_tree

def decision_tree_learning(examples, attributes, default=-1):
    if default != -1:
        if np.shape(examples)[0] == 0:
            return default

        elif count(0, examples) == np.shape(examples)[0]:
            return 0

        elif count(1, examples) == np.shape(examples)[0]:
            return 1

        elif len(attributes) == 0:
            return most_frequent_classification(examples)

    most_important_attribute = retrieve_most_important_attribute(attributes, examples)

    examples_subtree_false = examples[examples[:, most_important_attribute] == 0, :]
    subtree_false = decision_tree_learning(examples_subtree_false, attributes[:], most_frequent_classification(examples))

    examples_subtree_true = examples[examples[:, most_important_attribute] == 1, :]
    subtree_true = decision_tree_learning(examples_subtree_true, attributes[:], most_frequent_classification(examples))

    if subtree_false == subtree_true and (default != -1 or isinstance(subtree_false, list)):
        return subtree_false

    tree = [most_important_attribute, subtree_false, subtree_true]
    return tree


def count(x, examples):
    return np.count_nonzero(examples[:, -1] == x)


def most_frequent_classification(examples):
    if count(0, examples) >= count(1, examples):
        return 0
    else:
        return 1


def retrieve_most_important_attribute(attributes, examples):
    most_important_attribute = attributes[0]
    max_information_gain = information_gain(attributes[0], examples)

    for attribute in attributes:
        if information_gain(attribute, examples) >= max_information_gain:
            most_important_attribute = attribute
            max_information_gain = information_gain(attribute, examples)

    attributes.remove(most_important_attribute)

    return most_important_attribute


def information_gain(attribute, examples):
    p = count(1, examples)
    n = count(0, examples)

    return entropy(p, n) - remainder(p, n, attribute, examples)

def remainder(p, n, attribute, examples):
    p0 = count(1, examples[examples[:, attribute] == 0, :])
    n0 = count(0, examples[examples[:, attribute] == 0, :])

    p1 = count(1, examples[examples[:, attribute] == 1, :])
    n1 = count(0, examples[examples[:, attribute] == 1, :])

    return (p0+n0)/(p+n)*entropy(p0, n0) + (p1+n1)/(p+n)*entropy(p1, n1)

def entropy(p, n):
    if p==0 or n==0:
        return 0

    pp = p/(p+n)
    pn = n/(p+n)
    return -(pp*math.log2(pp) + pn*math.log2(pn))


def chi_squared_pruning(tree, examples, root=True):
    if isinstance(tree[1], list):
        tree[1] = chi_squared_pruning(tree[1], examples[examples[:, tree[0]] == 0, :], False)

    if isinstance(tree[2], list):
        tree[2] = chi_squared_pruning(tree[2], examples[examples[:, tree[0]] == 1, :], False)
    
    if not root and not isinstance(tree[1], list) and not isinstance(tree[2], list):
        p = count(1, examples)
        n = count(0, examples)

        p0 = count(1, examples[examples[:, tree[0]] == 0, :])
        n0 = count(0, examples[examples[:, tree[0]] == 0, :])
        p0hat = p * (p0+n0)/(p+n)
        n0hat = n * (p0+n0)/(p+n)

        p1 = count(1, examples[examples[:, tree[0]] == 1, :])
        n1 = count(0, examples[examples[:, tree[0]] == 1, :])
        p1hat = p * (p1+n1)/(p+n)
        n1hat = n * (p1+n1)/(p+n)

        delta = (p0-p0hat)**2/p0hat + (n0-n0hat)**2/n0hat + (p1-p1hat)**2/p1hat + (n1-n1hat)**2/n1hat
        
        if delta < 3.84:
            return most_frequent_classification(examples)
        else:
            return tree
    else:
        return tree
