//
//  SignupViewController.swift
//  Test2
//
//  Created by Farshad Faradji on 24.09.20.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Signup(_ sender: UIButton) {
        let email = emailTf.text
        let password = passwordTF.text
        let username = usernameTf.text
        guard let url = URL(string: "https") else { return }
        let body: [String: Any] = ["email": email,
                                   "password": password,
                                   "username": username,
                                   "analytics": true,
                                   "gender": "male",
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
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
