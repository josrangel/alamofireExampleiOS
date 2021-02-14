//
//  ViewController.swift
//  Alamofire101
//
//  Created by jrangel on 13/02/21.
//
//  more info of alamofire: https://codewithchris.com/alamofire/
//                          https://www.efectoapple.com/tutorial-alamofire-intro-2/
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var pokemonTableView: UITableView!

    var jsonArray: NSArray?
    var nameArray: Array<String> = []
    var imageURLArray: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self

        downloadDataFromApi()
    }

    private func downloadDataFromApi() {
        AF.request("http://private-5d2b9-efectoapplepokemonapp.apiary-mock.com/pokemonList") .responseJSON { response in
              //2.
            let JSON = response.value
                 //3.
                 self.jsonArray = JSON as? NSArray
                 //4.
                 for item in self.jsonArray! as! [NSDictionary]{
                    //5.
                    let name = item["name"] as? String
                    let imageURL = item["image"] as? String
                    self.nameArray.append((name)!)
                    self.imageURLArray.append((imageURL)!)
                 }
                 //6.
            self.pokemonTableView.reloadData()
           }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PokemonTableViewCell

        cell.pokemonName.text = self.nameArray[indexPath.row]

        let url = self.imageURLArray[indexPath.row]
        AF.download(url).responseData { response in
            if let data = response.value {
                cell.pokemonImage.image = UIImage(data: data)
            }
        }
        return cell
    }
}

