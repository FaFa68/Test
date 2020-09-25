//
//  LoginViewController.swift
//  Test2
//
//  Created by Farshad Faradji on 24.09.20.
//

import UIKit

class LoginViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Login(_ sender: UIButton) {
        generallogin()
    }
    
    @IBAction func Login2(_ sender: UIButton) {
        generallogin()
    }
    
    func generallogin(){
        guard let url = URL(string: "https") else { return }
        let email = emailTf.text
        let password = passwordTf.text
        let body: [String: Any] = ["email": email,
                                   "password": password,
                                   "timezone": "Europe/Berlin",
                                   "deviceInfo": "Swagger API"]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? NSDictionary
                    guard let token = json!["token"] else {
                        return
                    }
                    print(json)
                    print("Token: \(token)")
                    self.defaults.set(token, forKey: "token")
                    
                    guard let status = json!["status"] as? Int else {
                        print("Error")
                        return
                    }
                    if status == 200 {
                        
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUser" {
            guard let vc = segue.destination as? UserViewController else { return }
            vc.segueText = "Welcome " + emailTf.text!
        }
        if segue.identifier == "goToUser2" {
            guard let vc = segue.destination as? UserViewController else { return }
            vc.segueText = "Welcome " + emailTf.text!
        }
    }
}

