from numpy.lib.npyio import load
import h5py
import numpy as np
import time
import scann

def compute_recall(neighbors, true_neighbors):
    total = 0
    for gt_row, row in zip(true_neighbors, neighbors):
        total += np.intersect1d(gt_row, row).shape[0]
    return total / true_neighbors.size

def load_dataset(dataset):
    # Load
    print(f"Loading dataset...{dataset}")
    glove_h5py = h5py.File(dataset, "r")

    print("Keys in dataset")
    print(list(glove_h5py.keys()))

    traindata = glove_h5py['train']
    queries = glove_h5py['test']
    neighbors = glove_h5py['neighbors']

    print(traindata.shape)
    print(queries.shape)
    print(neighbors.shape)
    return traindata, queries, neighbors

def fit(dataset):
    normalized_dataset = dataset / np.linalg.norm(dataset, axis=1)[:, np.newaxis]

    searcher = scann.scann_ops_pybind.builder(normalized_dataset, 10, "dot_product").tree(
        num_leaves=2000, num_leaves_to_search=100, training_sample_size=250000).score_ah(
        2, anisotropic_quantization_threshold=0.2).reorder(1).build()
    return searcher


def query(searcher, v, n):
    reorder = 100
    leaves_to_search = 100
    return searcher.search(v, n, reorder, leaves_to_search)[0]

def main():
    
    dataset, queries, neighbors = load_dataset("datasets/random-xs-20-angular.hdf5")
    #dataset, queries, neighbors = load_dataset("datasets/glove-50-angular.hdf5")
    #dataset, queries, neighbors = load_dataset("datasets/glove-100-angular.hdf5")

    print("--- Create searcher ---")
    start = time.time()
    searcher = fit(dataset)
    end = time.time()
    print("Time:", end - start)


    # print("")
    # print("--- Use searcher ---")
    # results_to_return = 10
    # i = 1
    # start = time.time()
    # results = [query(searcher, queries[i], results_to_return)]
    # # results = [query(searcher, x, results_to_return) for x in queries]
    # end = time.time()
    # #print("results")
    # #print(results)

    # print("Recall:", compute_recall(results, neighbors[:, :10]))
    # print("Time:", end - start)

if __name__ == "__main__":
    main()


