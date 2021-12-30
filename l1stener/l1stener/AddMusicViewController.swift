//
//  AddMusicViewController.swift
//  l1stener
//
//  Created by nju on 2021/12/30.
//

import UIKit

class AddMusicViewController: UIViewController {
    
    var coreDataConnect: CoreDataConnect! = nil
    var allTableView: UITableView?

    @IBOutlet weak var URLInputField: UITextField!
    @IBOutlet weak var RenameInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        coreDataConnect = CoreDataConnect(context: context)
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
                let music = try Data(contentsOf: savedURL)
                if self.coreDataConnect.insert(data: music, fileName: self.RenameInputField.text!, genre: "pop") {
                    print("成功添加")
                }
                try FileManager.default.removeItem(at: savedURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        downloadTask.resume()
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
