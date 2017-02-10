//
//  TableViewController.swift
//  TD4
//
//  Created by GELE Axel on 30/01/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import UIKit
import SWXMLHash
import SDWebImage
import Carlos

class myTableViewCell : UITableViewCell
{
    @IBOutlet weak var  label: UILabel!
    @IBOutlet weak var  monImageView: UIImageView!

}

class TableViewController: UITableViewController {
    var categories = [Categorie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting the indicator view
        let myIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        myIndicatorView.center = self.view.center
        myIndicatorView.hidesWhenStopped = true
        myIndicatorView.color = UIColor.white
        myIndicatorView.backgroundColor = UIColor.black
        self.view.addSubview(myIndicatorView)
        myIndicatorView.startAnimating()
        //self.present(indicatorViewController, animated: true, completion: nil)

        
        //carlos framework's cache
        let cache = MemoryCacheLevel<String, NSData>().compose(DiskCacheLevel())
        
        // adding the bar button to send an email
        let barButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.pushFormulaire))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        // get the current language.
        var currentLanguage = NSLocale.preferredLanguages[0]
        currentLanguage = currentLanguage.substring(to: currentLanguage.index(currentLanguage.startIndex, offsetBy: 2))
        let url : URL
        //get the right url by doing a switch on the language
        switch currentLanguage{
        case "en":
            url = URL(string: "http://fairmont.lanoosphere.com/mobile/getdata?lang=en")!
        case "fr":
            url = URL(string: "http://fairmont.lanoosphere.com/mobile/getdata?lang=fr")!
        default:
            url = URL(string: "http://fairmont.lanoosphere.com/mobile/getdata?lang=en")!
        }

        let request = cache.get(url.absoluteString)
        request.onSuccess(){
            value in
            NSLog("cached")
            let xml = SWXMLHash.lazy(value as Data)
            for elem in xml["data"]["categories"]["category"].all {
                
                let category = Categorie(sort: Int((elem.element?.attribute(by: "sort")?.text)!)!, name: (elem.element?.attribute(by: "name")?.text)!)
                
                for elemt2 in elem["element"].all
                {
                    category.elementList.append(Element(name: (elemt2.element?.attribute(by: "name")?.text)!, image: URL(string: (elemt2.element?.attribute(by: "image")?.text)!)!, description: (elemt2.element?.attribute(by: "descr")?.text)!, image_large : (elemt2.element?.attribute(by: "image_large")?.text)!))
                }
                
                self.categories.append(category)
                self.tableView.reloadData()
                
                myIndicatorView.stopAnimating()

            }
        }
        .onFailure
        {
            error in
            
            NSLog("not cached")
            let data = try? Data(contentsOf: url)
            cache.set(data! as NSData, forKey: url.absoluteString)
            let xml = SWXMLHash.lazy(data!)
            for elem in xml["data"]["categories"]["category"].all {
            let category = Categorie(sort: Int((elem.element?.attribute(by: "sort")?.text)!)!, name: (elem.element?.attribute(by: "name")?.text)!)
        
            for elemt2 in elem["element"].all
            {
                category.elementList.append(Element(name: (elemt2.element?.attribute(by: "name")?.text)!, image: URL(string: (elemt2.element?.attribute(by: "image")?.text)!)!, description: (elemt2.element?.attribute(by: "descr")?.text)!, image_large : (elemt2.element?.attribute(by: "image_large")?.text)!))
            }
        
            self.categories.append(category)
            self.tableView.reloadData()
            myIndicatorView.stopAnimating()
            }
        }

        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "HOME"
    }
    
    
    func pushFormulaire()
    {
//        let myFormulaireController = FormulaireController()
//        self.present(myFormulaireController, animated: true, completion: nil)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "formulaire") as! FormulaireController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        //self.present(nextViewController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return categories[section].elementList.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableView", for: indexPath) as! myTableViewCell

        // Configure the cell...
        cell.label.text = self.categories[indexPath.section].elementList[indexPath.row].name

        //let data = try? Data(contentsOf: categories[indexPath.section].elementList[indexPath.row].image)
        cell.monImageView.setShowActivityIndicator(true)
        cell.monImageView.setIndicatorStyle(.gray)
        cell.monImageView.sd_setImage(with: self.categories[indexPath.section].elementList[indexPath.row].image)
        //cell.monImageView.image = UIImage(data: data!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return categories[section].name
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let viewController = UIViewController()
        viewController.title = categories[indexPath.section].elementList[indexPath.row].name
        if(categories[indexPath.section].elementList[indexPath.row].image_large != "")
        {
            let myImage = try? UIImage(data: Data(contentsOf: URL(string: categories[indexPath.section].elementList[indexPath.row].image_large)!))
            let myImageView = UIImageView(image: myImage!)
            viewController.view.addSubview(myImageView)
            
            self.navigationController?.pushViewController(viewController, animated: true)
            NSLog(categories[indexPath.section].elementList[indexPath.row].image_large)
        }
        else
        {
            let myWebview = UIWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            myWebview.loadHTMLString(categories[indexPath.section].elementList[indexPath.row].description, baseURL: nil)
            myWebview.backgroundColor = UIColor.gray
            myWebview.isOpaque = false
            viewController.view = myWebview
            //let urlRequest = URLRequest(url: URL(string: categories[indexPath.section].elementList[indexPath.row].description)!)
            //myWebview.loadRequest(urlRequest)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
