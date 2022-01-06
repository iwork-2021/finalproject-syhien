//
//  AddMusicViewController.swift
//  l1stener
//
//  Created by nju on 2021/12/30.
//

import UIKit
import UniformTypeIdentifiers
import SoundAnalysis

class AddMusicViewController: UIViewController, UIDocumentPickerDelegate {
    
    var coreDataConnect: CoreDataConnect! = nil
    var allTableView: UITableView?
    var model: MLModel!
    var audioFileAnalyzer: SNAudioFileAnalyzer!

    @IBOutlet weak var URLInputField: UITextField!
    @IBOutlet weak var RenameInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        coreDataConnect = CoreDataConnect(context: context)
        
        do {
            let soundClassifier = try l1stenSoundClassifier(configuration: MLModelConfiguration())
            model = soundClassifier.model
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func AddFromURL(_ sender: UIButton) {
        guard URLInputField.text!.isEmpty == false && RenameInputField.text!.isEmpty == false else {
            return
        }
        let musicURL = URL(string: URLInputField.text!)
        print(musicURL!)
        let downloadTask = URLSession.shared.downloadTask(with: musicURL!) { url, response, error in
            guard let fileURl = url else { return }
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let savedURL = documentsURL.appendingPathComponent(self.RenameInputField.text!)
                print(fileURl)
                print(savedURL)
                try FileManager.default.moveItem(at: fileURl, to: savedURL)
                
                // 开始识别
                self.audioFileAnalyzer = try SNAudioFileAnalyzer(url: savedURL)
                let resultsObserver = ResultsObserver()
                do {
                    let request = try SNClassifySoundRequest(mlModel: self.model)
                    try self.audioFileAnalyzer.add(request, withObserver: resultsObserver)
                } catch {
                    print(error.localizedDescription)
                }
                self.audioFileAnalyzer.analyze()
                let genre = resultsObserver.domainGenre()
                print("genre is \(genre)")
                let music = try Data(contentsOf: savedURL)
                if self.coreDataConnect.insert(data: music, fileName: self.RenameInputField.text!, genre: genre) {
                    print("成功添加")
                }
                DispatchQueue.main.async {
                    self.allTableView?.reloadData()
                }
                try FileManager.default.removeItem(at: savedURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        downloadTask.resume()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddFromDevice(_ sender: Any) {
        let types = UTType.types(tag: "wav", tagClass: .filenameExtension, conformingTo: nil)
//        types.append(UTType(tag: "mp3", tagClass: .filenameExtension, conformingTo: nil)!)
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        docPicker.delegate = self
        present(docPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = URL(string: urls[0].absoluteString)!
        print(url)
        do {
            self.audioFileAnalyzer = try SNAudioFileAnalyzer(url: url)
            let resultsObserver = ResultsObserver()
            do {
                let request = try SNClassifySoundRequest(mlModel: self.model)
                try self.audioFileAnalyzer.add(request, withObserver: resultsObserver)
            } catch {
                print(error.localizedDescription)
            }
            self.audioFileAnalyzer.analyze()
            let genre = resultsObserver.domainGenre()
            print("genre is \(genre)")
            let music = try Data(contentsOf: url)
            print(url.lastPathComponent)
            if self.coreDataConnect.insert(data: music, fileName: url.lastPathComponent, genre: genre) {
                print("成功添加")
            }
            DispatchQueue.main.async {
                self.allTableView?.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
