//
//  AboutViewController.swift
//  l1stener
//
//  Created by nju on 2021/12/28.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let textString = NSMutableAttributedString(string: "项目地址: ", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 22)])
        textString.append(NSMutableAttributedString(string: "Github", attributes: [NSAttributedString.Key.link: URL(string: "https://github.com/iwork-2021/finalproject-syhien")!, NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))
        textString.append(NSAttributedString(string: "\n\n\n"))
        textString.append(NSMutableAttributedString(string: "个人主页: ", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]))
        textString.append(NSMutableAttributedString(string: "syhien", attributes: [NSAttributedString.Key.link: URL(string: "https://github.com/syhien")!, NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))
        textString.append(NSAttributedString(string: "\n\n\n"))
        textString.append(NSMutableAttributedString(string: "Email: ", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]))
        textString.append(NSMutableAttributedString(string: "syhien@outlook.at", attributes: [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))
        textString.append(NSAttributedString(string: "\n\n\n"))
        text.attributedText = textString
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataConnect = CoreDataConnect(context: context)
        
        print("测试一下core data")
        let downloadTask = URLSession.shared.downloadTask(with: URL(string: "https://box.nju.edu.cn/f/f4a9a4d53b9e47e2a92d/?dl=1")!) { url, response, error in
            guard let fileURl = url else { return }
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let savedURL = documentsURL.appendingPathComponent(fileURl.lastPathComponent)
                try FileManager.default.moveItem(at: fileURl, to: savedURL)
                let music = try Data(contentsOf: savedURL)
                if coreDataConnect.insert(data: music, fileName: "okinodokusama.wav", genre: "pop") {
                    print("成功添加示例wav")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        downloadTask.resume()
        
        print(FileManager.default.fileExists(atPath: "/2mix_Mst_okinodoku_off_Vocal_210307.wav"))
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
