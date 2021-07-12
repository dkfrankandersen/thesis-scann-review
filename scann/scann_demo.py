import numpy as np
import h5py
import os
import requests
import tempfile
import time

import scann

print("Entering scann_demo.py")

print("Downloading dataset")
with tempfile.TemporaryDirectory() as tmp:
    response = requests.get("http://ann-benchmarks.com/glove-100-angular.hdf5")
    loc = os.path.join(tmp, "glove.hdf5")
    with open(loc, 'wb') as f:
        f.write(response.content)
    
    glove_h5py = h5py.File(loc, "r")


print("List dataset keys")
list(glove_h5py.keys())

dataset = glove_h5py['train']
queries = glove_h5py['test']
print(dataset.shape)
print(queries.shape)

normalized_dataset = dataset / np.linalg.norm(dataset, axis=1)[:, np.newaxis]
# configure ScaNN as a tree - asymmetric hash hybrid with reordering
# anisotropic quantization as described in the paper; see README

# use scann.scann_ops.build() to instead create a TensorFlow-compatible searcher
searcher = scann.scann_ops_pybind.builder(normalized_dataset, 10, "dot_product").tree(
    num_leaves=2000, num_leaves_to_search=100, training_sample_size=250000).score_ah(
    2, anisotropic_quantization_threshold=0.2).reorder(100).build()


def compute_recall(neighbors, true_neighbors):
    total = 0
    for gt_row, row in zip(true_neighbors, neighbors):
        total += np.intersect1d(gt_row, row).shape[0]
    return total / true_neighbors.size


# this will search the top 100 of the 2000 leaves, and compute
# the exact dot products of the top 100 candidates from asymmetric
# hashing to get the final top 10 candidates.
start = time.time()
neighbors, distances = searcher.search_batched(queries)
end = time.time()

# we are given top 100 neighbors in the ground truth, so select top 10
print("Recall:", compute_recall(neighbors, glove_h5py['neighbors'][:, :10]))
print("Time:", end - start)

# increasing the leaves to search increases recall at the cost of speed
start = time.time()
neighbors, distances = searcher.search_batched(queries, leaves_to_search=150)
end = time.time()

print("Recall:", compute_recall(neighbors, glove_h5py['neighbors'][:, :10]))
print("Time:", end - start)


# increasing reordering (the exact scoring of top AH candidates) has a similar effect.
start = time.time()
neighbors, distances = searcher.search_batched(queries, leaves_to_search=150, pre_reorder_num_neighbors=250)
end = time.time()

print("Recall:", compute_recall(neighbors, glove_h5py['neighbors'][:, :10]))
print("Time:", end - start)

# we can also dynamically configure the number of neighbors returned
# currently returns 10 as configued in ScannBuilder()
neighbors, distances = searcher.search_batched(queries)
print(neighbors.shape, distances.shape)

# now returns 20
neighbors, distances = searcher.search_batched(queries, final_num_neighbors=20)
print(neighbors.shape, distances.shape)

# we have been exclusively calling batch search so far; the single-query call has the same API
start = time.time()
neighbors, distances = searcher.search(queries[0], final_num_neighbors=5)
end = time.time()

print(neighbors)
print(distances)
print("Latency (ms):", 1000*(end - start))

print("scann_demo finished")