//
//  FormulaireController.swift
//  TD4
//
//  Created by GELE Axel on 06/02/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import UIKit
import MessageUI

class FormulaireController: UIViewController, MFMailComposeViewControllerDelegate {

    //@IBOutlet var formOutlets: [UITextField]!

    @IBOutlet var formOutlets: [UITextField]!

    @IBAction func cacherClavier(_ sender: Any) {
        view.endEditing(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendForm(_ sender: Any) {
        var i = 0
        var errorMessage = ""
        var error = false
        var myTextField : UITextField
        for item in formOutlets
        {
            myTextField = item as UITextField
            switch i {
            case 0:
                if (myTextField.text?.characters.count)! < 5
                {
                    error = true
                    errorMessage = "Le nom doit contenir au moins 5 caractères"
                }
            case 1:
                if (myTextField.text?.characters.count)! < 5
                {
                    error = true
                    errorMessage = "Le prenom doit contenir au moins 5 caractères"
                }
            case 2:
                if(!isValidEmail(testStr: myTextField.text!))
                {
                    error = true
                    errorMessage = "Adresse email invalide"
                }
            case 3:
                if(!isValidPhone(value: myTextField.text!))
                {
                    error = true
                    errorMessage = "le numéro de téléphone doit contenir 10 chiffres"
                }
            default:
                error = false
            }
            
            if error == true
            {
                let alert = UIAlertController(title: "Message", message: errorMessage, preferredStyle: .alert)
                let button = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
                error = false
                break
            }
            i = i + 1
        }
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        var mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients([formOutlets[2].text!])
        mailViewController.setSubject("Ma demande de contact")
        var message = "<p>Nom :" + formOutlets[0].text! + "</p> <p>Prenom : " + formOutlets[1].text! + "</p> <p> Email :" + formOutlets[2].text! + "</p> <p>Telephone : " + formOutlets[3].text! + "</p>"
        mailViewController.setMessageBody(message, isHTML: true)
        self.present(mailViewController, animated: true, completion: nil)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
