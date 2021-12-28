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
