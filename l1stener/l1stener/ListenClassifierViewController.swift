//
//  ListenClassifierViewController.swift
//  l1stener
//
//  Created by nju on 2022/1/4.
//

import UIKit
import SoundAnalysis
import AVFAudio

class ListenClassifierViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    var model: MLModel! = nil
    var analysisQueue = DispatchQueue(label: "syh1en.AnalysisQueue")
    var streamAnalyzer: SNAudioStreamAnalyzer! = nil
    var audioEngine: AVAudioEngine! = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        do {
            let soundClassifier = try l1stenSoundClassifier(configuration: MLModelConfiguration())
            model = soundClassifier.model
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func classifyTouched(_ sender: Any) {
        let inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        do {
            let request = try SNClassifySoundRequest(mlModel: model)
            let requestObserver = ResultsObserver()
            requestObserver.classLabel = resultLabel
            requestObserver.confidenceLabel = confidenceLabel
            streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
            try streamAnalyzer.add(request, withObserver: requestObserver)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat) { buffer, time in
                self.analysisQueue.async {
                    self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
            }
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
    }
}
