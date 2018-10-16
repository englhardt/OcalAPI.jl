# OcalAPI.jl
_A Julia package providing a JSON REST API for one-class active learning._

[![Build Status](https://travis-ci.com/englhardt/OcalAPI.jl.svg?branch=master)](https://travis-ci.com/englhardt/OcalAPI.jl)
[![Coverage Status](https://coveralls.io/repos/github/englhardt/OcalAPI.jl/badge.svg?branch=master)](https://coveralls.io/github/englhardt/OcalAPI.jl?branch=master)

This package implements a JSON REST API for active learning strategies for one-class learning.
The package has been developed to offer an easy to use API to our [OCAL project](https://www.ipd.kit.edu/ocal/). The package wraps the whole active learning cycle in one simple request.

## Running

We recommend running the API with the provided Docker container:

```
docker pull aengl/ocal-api
docker run -it ocal-api
```

The API is then available at http://localhost:8081.
To bind to a specific `HOST` and `PORT`, pass additional environment variables:
```
docker run -e OCAL_API_HOST=HOST -e OCAL_API_PORT=PORT -p PORT:PORT -it ocal-api
```

Our API documentation based on [Swagger](https://swagger.io/).
To interactively explore the API we offer a Docker Compose that includes the API and a [Swagger UI](https://swagger.io/tools/swagger-ui/).
Install Docker Compose by following the instructions [here](https://docs.docker.com/compose/install/). Then, run the following commands to start the API and the documentation:
```
git clone https://github.com/englhardt/OcalAPI.jl
cd OcalAPI.jl
docker-compose up
```

The API documentation is then available at http://localhost:8080 and the API itself at http://localhost:8081.

## Overview
This API wraps one active-learning cycle in a single JSON request.
The input consists of the following elements:
- `data`: An array of `n` observations with `d` dimensions each. Format: `[[x_1_1, ..., x_1_d], ... [x_n_1, ..., x_n_d]]`
- `labels`: An array of `n` labels with values in `{"U", "Lin", "Lout"}`. Format: `["U", ....]`
- `params`: An object with additional parameters for the active-learning cycle.
  - `C`: Cost factor for the classifier, e.g., `0.05`
  - `gamma`: Kernel parameter for the [RBF kernel](http://scikit-learn.org/stable/modules/generated/sklearn.metrics.pairwise.rbf_kernel.html), e.g., `2`
  - `classifier`: The classifier to train (see list bellow), e.g., `SVDDneg`
  - `query_strategy`: The query strategy to use for selecting the query object (see list bellow), e.g., `RandomQs`
- `query_history`: An array of arrays containing the indices of the observations labeled in the last `k` iterations. Example with 2 labeled observation in 3 iterations: `[[1, 2], [4, 7], [8, 10]]`
- `subspaces`:
- `subspace_grids`: An array per subspace containing observations to score. Format for each `data_subspaceX` is the same as for `data`. Then, the full format for `subspace_grids` with `S` subspaces is `[data_subspace1, ..., data_subspaceS]`

The API then fits a global model on `data` with the specified `classifier`.
The observations are then classified with this model.
Next, the query strategy is executed.
For the visualization, a model is fit for each subspace.
Then, the API calculates the prediction and distance to the decision boundary for each observation given in `subspace_grids`.
Additionally, the subspaces are ranked by their importance.

The output consists of the following elements:
- `prediction_global`: Prediction of the global model for `data` ("inlier" or "outlier"), e.g., `["inlier", "outlier", "inlier"]`
- `prediction_subspaces`: Array of predictions for `data` for each subspace. The format for each subspace prediction is the same as for `prediction_global`.
- `score_subspace_grids`: This is an array of arrays. The inner array `dist_subspaceX` is the distance to the decision boundary for each observation in `data_subspaceX` of a single subspace. The outer array format with `S` subspaces then is `[dist_subspace1, ..., dist_subspaceS]`.
- `query_ids`: An array of indices selected by the query strategy, e.g., `[2, 3]`
- `ranking_subspaces`: An array giving a ranking for the subspaces. The number at index `X` indicates the rank of subspace `X`. Example with 3 subspaces: `[3, 1, 2]`, i.e, resulting in the order subspace 2, then 3 and 1.

The file `example/request.json` gives an example for a request.
The expected result is stored in `example/response.json`.
Start the API and then run the example with the following command:

```
curl -X POST "http://localhost:8081/" -H "Content-Type: application/json" -d @example/request.json -o example/response.json --compressed
```

### Classifiers
This is a list of the available classifiers that are implemented in [SVDD.jl](https://github.com/englhardt/SVDD.jl):

* Vanilla Support Vector Data Description (VanillaSVDD) [1]
* SVDD with negative examples (SVDDNeg) [1]
* Semi-supervised Anomaly Detection (SSAD) [2]

### Active learning strategies
This is a list of the available active learning strategies that are implemented in [OneClassActiveLearning.jl](https://github.com/englhardt/OneClassActiveLearning.jl):
- Data-based query strategies
  - MinimumMarginQs and ExpectedMinimumMarginQs [3]
  - MaximumEntropyQs [3]
  - MaximumLossQs [4]
- Model-based query strategies
    - HighConfidenceQs [5]
    - DecisionBoundaryQs
- Hybrid query strategies
    - NeighborhoodBasedQs [6]
    - BoundaryNeighborCombination [7]
- Baselines
  - RandomQs
  - RandomOutlierQs

## Authors
We welcome contributions and bug reports.

This package is developed and maintained by [Holger Trittenbach](https://github.com/holtri/) and [Adrian Englhardt](https://github.com/englhardt).

## References
[1] Tax, David MJ, and Robert PW Duin. "Support vector data description." Machine learning 54.1 (2004): 45-66.

[2] Görnitz, Nico, et al. "Toward supervised anomaly detection." Journal of Artificial Intelligence Research 46 (2013): 235-262.

[3] A. Ghasemi, H. R. Rabiee, M. Fadaee, M. T. Manzuri, and M. H. Rohban. Active learning from positive and unlabeled data. In 2011 IEEE 11th International Conference on Data Mining Workshops, pages 244–250, Dec 2011.

[4] A. Ghasemi, M. T. Manzuri, H. R. Rabiee, M. H. Rohban, and S. Haghiri. Active one-class learning by kernel density estimation. In 2011 IEEE International Workshop on Machine Learning for Signal Processing, pages 1–6, Sept 2011.

[5] V. Barnabé-Lortie, C. Bellinger, and N. Japkowicz. Active learning for one-class classification. In 2015 IEEE 14th International Conference on Machine Learning and Applications (ICMLA), pages 390–395, Dec 2015.

[6] N. Görnitz, M. Kloft, K. Rieck, and U. Brefeld. Toward supervised anomaly detection. Journal of Artificial Intelligence Research (JAIR), pages 235–262, Jan. 2013.

[7] L. Yin, H. Wang, and W. Fan. Active learning based support vector data description method for robust novelty detection. Knowledge-Based Systems, pages 40–52, Aug. 2018.
