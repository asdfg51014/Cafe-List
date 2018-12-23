//
//  AboutViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/1.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    var section0 = ["Cafe Nomad 粉專", "Cafe Nomad 官方網站"]
    
    var section0Image = ["facebook", "internet"]
    
    var section1 = ["icons8 官方網站"]
    
    var section1Image = ["icons8", "unsplash"]
    
    var section2 = ["問題回報", "GitHub", "Medium"]
    
    var section2Image = ["mail", "github", "medium"]
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var logoImage: UIImageView!
    
    func sendEmail() -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["albert.ch1994@gmail.com"])
        mail.setSubject("我有問題要告訴你!")
       return mail
    }
    
    func showEmailError(){
        let sendMailErrorAlert = UIAlertController(title: "錯誤", message: "你的裝置無法傳送信件", preferredStyle: .alert)
        let dissmiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dissmiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func settingNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .lightGray
        navigationController?.navigationBar.tintColor = .brown
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
        settingNavigationBar()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell0", for: indexPath) as! AboutCell0TableViewCell
                cell.titleLabel.text = "此 APP 資料為臺灣 Cafe Nomad 社群提供。"
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! AboutCell1TableViewCell
                cell.myImage.image = UIImage(named: section0Image[0])
                cell.myLabel.text = section0[0]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! AboutCell1TableViewCell
                cell.myImage.image = UIImage(named: section0Image[1])
                cell.myLabel.text = section0[1]
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell0", for: indexPath) as! AboutCell0TableViewCell
                cell.titleLabel.text = "此 APP icons 由 icons8 提供。"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! AboutCell1TableViewCell
                cell.myImage.image = UIImage(named: section1Image[0])
                cell.myLabel.text = section1[0]
                return cell
            }
        default:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell0", for: indexPath) as! AboutCell0TableViewCell
                cell.titleLabel.text = "iOS APP 作者：Albert.C" + "\n目前於好想工作室擔任iOS Camp學員"
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! AboutCell1TableViewCell
                cell.myImage.image = UIImage(named: section2Image[0])
                cell.myLabel.text = section2[0]
                return cell
            } else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! AboutCell1TableViewCell
                cell.myImage.image = UIImage(named: section2Image[1])
                cell.myLabel.text = section2[1]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! AboutCell1TableViewCell
                cell.myImage.image = UIImage(named: section2Image[2])
                cell.myLabel.text = section2[2]
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                let url = URL(string: "https://www.facebook.com/cafenomad.tw/")
                let safariController = SFSafariViewController(url: url!)
                present(safariController, animated:  true, completion:  nil)
            } else if indexPath.row == 2{
                let url = URL(string: "https://cafenomad.tw/")
                let safariController = SFSafariViewController(url: url!)
                present(safariController, animated:  true, completion:  nil)
            }
        case 1:
            if indexPath.row == 1 {
                let url = URL(string: "https://icons8.com/")
                let safariController = SFSafariViewController(url: url!)
                present(safariController, animated:  true, completion:  nil)
            } 
        default:
            if indexPath.row == 1 {
                let mailComposeViewController = sendEmail()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    showEmailError()
                }
            } else if indexPath.row == 2 {
                let url = URL(string: "https://github.com/asdfg51014")
                let safariController = SFSafariViewController(url: url!)
                present(safariController, animated:  true, completion:  nil)
            } else if indexPath.row == 3 {
                let url = URL(string: "https://medium.com/@albert1994")
                let safariController = SFSafariViewController(url: url!)
                present(safariController, animated:  true, completion:  nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}
