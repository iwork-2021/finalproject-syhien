//
//  ListenClassifyViewController.swift
//  l1stener
//
//  Created by nju on 2022/1/6.
//

import UIKit
import AVFAudio
import SoundAnalysis
import CoreML

class ListenClassifyViewController: UIViewController {
    
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    var audioEngine = AVAudioEngine()
    
    var streamAnalyzer: SNAudioStreamAnalyzer! = nil
    var resultsObserver: ResultsObserver! = nil
    
    let analysisQueue = DispatchQueue(label: "syh1en.AnalysisQueue")
    
    var model: MLModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            let genreClassifier = try l1stenSoundClassifier(configuration: MLModelConfiguration())
            model = genreClassifier.model
        } catch {
            print(error.localizedDescription)
        }
        
        let inputFormat = self.audioEngine.inputNode.inputFormat(forBus: 0)
        streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        resultsObserver = ResultsObserver()
        resultsObserver.classLabel = predictLabel
        resultsObserver.confidenceLabel = confidenceLabel
        
        do {
            let request = try SNClassifySoundRequest(mlModel: model)
            try streamAnalyzer.add(request, withObserver: resultsObserver)
        } catch {
            print(error.localizedDescription)
        }
        
        self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        do {
            try self.audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
    }
}
