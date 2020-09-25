//
//  User2ViewController.swift
//  Test2
//
//  Created by Farshad Faradji on 25.09.20.
//

import UIKit

class User2ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var nickNameTf: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var dogRacesTableView: UITableView!
    let defaults = UserDefaults.standard
    var dogRacesAndId: [String:String] = [String:String]()
    var dogRacesArray: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerDog(_ sender: UIButton) {
        
        guard let url = URL(string: "https") else { return }
        guard let nickname = nickNameTf.text else {return}
        let birthday = birthdayPicker.date
        let relationship = "owner"
        let gender = "male"
        //        let bread1Id = dogRaces[]
        let body: [String: Any] = ["nickname": nickname,
                                   "birthday": birthday,
                                   //"breed1Id": ,
                                   "gender": "male",
                                   "relationship": "owner"]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        let token = defaults.object(forKey: "token")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func getDogRaces(_ sender: UIButton) {
        
        let string = "https"
        guard let url = URL(string: string) else {return}
        var request = URLRequest(url: url)
        //        let token = defaults.object(forKey: "token")
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
                        self.dogRacesAndId[dogDeName] = dogNames["id"]
                        self.dogRacesArray.append(dogDeName)
                    }
                } catch let error {
                    print(error)
                }
            }
        }.resume()
        preparePickerView()
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogRacesArray.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as UITableViewCell
        cell.textLabel?.text =  dogRacesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let indexPath = tableView.indexPathForSelectedRow
        //        let selectedCell = tableView.cellForRow(at: indexPath) as UITableViewCell
        
    }
    func preparePickerView() {
        dogRacesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        dogRacesTableView.delegate = self
        dogRacesTableView.dataSource = self
    }
}
