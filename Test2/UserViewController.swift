//
//  UserViewController.swift
//  Test2
//
//  Created by Farshad Faradji on 24.09.20.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var dogRacesTableView: UITableView!
    var segueText: String?
    var dogRaces: [String] = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        welcomeLabel.text = segueText
        dogRacesTableView.reloadData()
        dogRacesTableView.isHidden = true
    }
    
    @IBAction func getDogRaces(_ sender: UIButton) {
        
        let string = "https"
        guard let url = URL(string: string) else {return}
        var request = URLRequest(url: url)
        
        let token = defaults.object(forKey: "token")
        //        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            if let data = data , let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            // Convert HTTP Response Data to a Dictionary
            if let data = data {
                print("Data: \(data)")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    guard let dogsArray = json as? [Any] else {return}
                    print("data_array: \(dogsArray)")
                    for dog in dogsArray {
                        let dogDic = dog as? [String: Any]
                        guard let dogNames = dogDic!["names"] as? [String:String] else {return}
                        guard let dogDeName = dogNames["de"] else {return}
                        print("Dog_De_Name: \(dogDeName)")
                        self.dogRaces.append(dogDeName)
                    }
                } catch let error {
                    print(error)
                }
            }
        }.resume()
        prepareTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dogRaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text =  dogRaces[indexPath.row]
        return cell
    }
    
    func prepareTableView() {
        dogRacesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dogRacesTableView.delegate = self
        dogRacesTableView.dataSource = self
        dogRacesTableView.isHidden = false
    }
}

