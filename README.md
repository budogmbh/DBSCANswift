# DBSCANswift

Simple Swift based DBSCAN implementation for clustering of CLLocation objects

---
## Description

**DBSCAN** stands for _Density-based spatial clustering of applications with noise_. It is a data clustering algorithm.

http://en.wikipedia.org/wiki/DBSCAN


The current implementation support only CLLocation data.


## Usage
1. Copy the DBSCAN.swift file to the project

2. Example Data:

```swift
// create locations array...
let locations: [CLLocation]

// ...and fill it with CLLocation objects
locations.append(CLLocation(latitude: 48.1623, longitude: 11.5798))
locations.append(CLLocation(latitude: 48.1621, longitude: 11.5799))
locations.append(CLLocation(latitude: 48.1603, longitude: 11.5763))
```


3. Find clusters:

```swift
let dbscan = DBSCAN(locations)
let (mapping, centroids) = dbscan.findCluster(maximumDistance: 75.0, memberCount: 1)
```

- `maximumDistance` is the maximum distance of locations in a cluster defined in meters
- `memberCount` defines the minimum required Locations in a single cluster to filter noice
- `mapping` contains a list of cluster index for each provided location
- `centroids` contains the center locations of each cluster and a index reference to the contained locations
