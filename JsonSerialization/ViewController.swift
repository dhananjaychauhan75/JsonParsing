//
//  ViewController.swift
//  JsonSerialization
//
//  Created by Dhananjay  on 20/03/24.
//

import UIKit
struct Result {
    let name: String
    let value: String
}

struct InputData : Decodable{
    var name,value : String
}

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnConvert: UIButton!
    var item1: String?
    var dicData = [String:String]()
    var arrData = [Result]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setUpData()
    }

    func setupUI() {
        btnConvert.layer.cornerRadius = 20
        btnConvert.layer.borderWidth = 1
        btnConvert.layer.borderColor = UIColor.black.cgColor
        btnConvert.backgroundColor = .green
        txtView.text = """
{
"name":"Dhananjay",
"value": "chutiya"
}

{
"name":"Ajay",
"value": "Makhvana"
}

{
"name":"Gorang",
"value": "Vyas"
}

{
"name":"Hiral",
"value": "Vyas"
}
"""
    }
    
    @IBAction func btnConvertClicked(_ sender: Any) {
        validateJson()
    }
    
    func setUpData() {
        tblView.dataSource = self
        tblView.delegate = self
    }
    
    func validateJson() {
        dicData.removeAll()
        arrData.removeAll()
        let text = txtView.text
        var start = false
        var arr = [String]()
        var str = ""
        text?.forEach({ later in
            if later == "{" && !start{
                start = true
                str = ""
            }
            if start {
                str += "\(later)"
            }
            if later == "}"{
                arr.append(str)
               start = false
            }
        })
        txtView.layer.borderColor = UIColor.red.cgColor
        if !start {
            txtView.text = arr.joined(separator: "\n")
            parsJSONUsingJsonDecoder(arr)
        } else {
            txtView.text = """
{
"name":"Dhananjay",
"value": "Chauhan"
}
"""
        }
    }
    
    func parsJSONUsingJson(_ arr:[String]) {
        arr.forEach { json in
            let data = json.data(using: .utf8)
            do{
                let s = try JSONSerialization.jsonObject(with: data!,options: []) as? [String:String]
                for (key,value) in s ?? [String:String](){
                    self.dicData[key] = value
                }
            } catch {
                print("nahi hua kuch",error)
            }
        }
        for (k,v) in dicData {
            arrData.append(Result(name: k, value: "\(v)"))
        }
        tblView.reloadData()
    }
    
    func parsJSONUsingJsonDecoder(_ arr:[String]) {
        arr.forEach { json in
            let data = json.data(using: .utf8)
            do{
                let dat = try JSONDecoder().decode(InputData.self,from: data ?? Data())
                arrData.append(Result(name: dat.name, value: dat.value))
            } catch {
                print("nahi hua kuch",error)
            }
        }
        tblView.reloadData()
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath) as! FieldCell
        cell.backgroundColor = .black
        cell.lblTitle.text = arrData[indexPath.row].name
        cell.lblValue.text = arrData[indexPath.row].value
        return cell
    }
}
