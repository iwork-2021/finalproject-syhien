//
//  RequestObserver.swift
//  l1stener
//
//  Created by nju on 2021/12/30.
//

import Foundation
import SoundAnalysis
import UIKit

// Observer object that is called as analysis results are found.
class ResultsObserver : NSObject, SNResultsObserving {
    
    var classLabel: UILabel?
    var confidenceLabel: UILabel?
    var classificationResult = String()
    var classificationConfidence = Double()
    
    var counts: [String:Int] = ["blues":0,
                                "classical":0,
                                "country":0,
                                "disco":0,
                                "hiphop":0,
                                "jazz":0,
                                "metal":0,
                                "pop":0,
                                "reggae":0,
                                "rock":0,
    ]
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        // Get the top classification.
        guard let result = result as? SNClassificationResult,
              let classification = result.classifications.first else { return }
        
        // Determine the time of this result.
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds)
        print("Analysis result for audio at time: \(formattedTime)")
        
        let confidence = classification.confidence * 100.0
        let percent = String(format: "%.2f%%", confidence)
        
        // Print the result as Sound: percentage confidence.
        print("\(classification.identifier): \(percent) confidence.\n")
        
        classificationResult = classification.identifier
        classificationConfidence = confidence
        
        DispatchQueue.main.async {
            self.classLabel?.text = classification.identifier
            self.confidenceLabel?.text = String(confidence)
        }
        
        counts[classification.identifier]! += 1
    }
    
    func domainGenre() -> String {
        return counts.sorted(by: { $0.1 > $1.1 }).first!.key
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
