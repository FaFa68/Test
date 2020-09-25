//
//  ViewController.swift
//  Test2
//
//  Created by Farshad Faradji on 24.09.20.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToSignup(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignup", sender: self)
    }
    @IBAction func goToLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
}

