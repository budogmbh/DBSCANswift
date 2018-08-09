//
//  DBSCAN.swift
//  Simple DBSCAN implementation for clustering CLLocation arrays
//
//  Created by Tobias Frech
//  2018 budo GmbH
//
//  Based on jDBSCAN: https://github.com/upphiminn/jDBSCAN
//

import Foundation
import CoreLocation


struct Cluster {
    let location: CLLocation
    let members: [Int]
}

class DBSCAN {

    private var locations: [CLLocation]

    private var eps: Double = 0.075
    private var requiredNeighbours: Int = 1

    private var clusters: [[Int]] = []
    private var status: [Int] = []

    init(_ locations: [CLLocation]) {
        self.locations = locations
    }

    private func getRegionNeighbours(_ locationIndex: Int) -> [Int] {
        var neighbours: [Int] = []
        let location = locations[locationIndex]
        for i in 0..<locations.count {
            if i == locationIndex {
                continue
            }
            if location.distance(from: locations[i]) <= eps {
                neighbours.append(i)
            }
        }
        return neighbours
    }


    private func expandCluster(locationIndex: Int, neighbours: [Int], clusterIndex: Int) {
        clusters[clusterIndex - 1].append(locationIndex)
        status[locationIndex] = clusterIndex

        for i in 0..<neighbours.count {
            let currentLocationIndex = neighbours[i]
            if status[currentLocationIndex] == -1 {
                status[currentLocationIndex] = 0
                let currentNeighbours = getRegionNeighbours(currentLocationIndex)
                if currentNeighbours.count >= requiredNeighbours {
                    expandCluster(locationIndex: currentLocationIndex, neighbours: currentNeighbours, clusterIndex: clusterIndex)
                }
            }

            if status[currentLocationIndex] <= 0 {
                status[currentLocationIndex] = clusterIndex
                clusters[clusterIndex - 1].append(currentLocationIndex)
            }
        }
    }

    func findCluster(maximumDistance: Double, memberCount: Int) -> ([Int], [Cluster]) {
        eps = maximumDistance
        requiredNeighbours = memberCount - 1

        clusters = []
        status = Array(repeating:-1, count: locations.count)

        for i in 0..<locations.count {
            if status[i] == -1 {
                status[i] = 0
                let neighbours = getRegionNeighbours(i)
                if neighbours.count < requiredNeighbours {
                    status[i] = 0
                } else {
                    clusters.append([])
                    let clusterIndex = clusters.count
                    expandCluster(locationIndex: i, neighbours: neighbours, clusterIndex: clusterIndex)
                }
            }
        }

        var centroids: [Cluster] = []
        for i in 0..<clusters.count {
            var latitude = 0.0, longitude = 0.0, accuracy = 0.0
            for j in 0..<clusters[i].count {
                let location = locations[clusters[i][j]]
                latitude += location.coordinate.latitude
                longitude += location.coordinate.longitude
                accuracy += location.horizontalAccuracy
            }
            latitude = latitude / Double(clusters[i].count)
            longitude = longitude / Double(clusters[i].count)
            accuracy = accuracy / Double(clusters[i].count)


            let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: 0, horizontalAccuracy: accuracy, verticalAccuracy: 0, timestamp: Date())
            let members = clusters[i]

            centroids.append(Cluster(location: location, members: members))


        }

        return (status, centroids)
    }


}
