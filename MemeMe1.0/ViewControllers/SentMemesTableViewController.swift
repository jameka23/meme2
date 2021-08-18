//
//  SentMemesTableViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 8/5/21.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    
    
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func addNewMeme(){
        
        self.performSegue(withIdentifier: "NewMemeSegue", sender: self)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Configure the cell...
        cell.imageView?.image = meme.memeImage!
        cell.textLabel?.text = " \(meme.topText ?? "top text") \(meme.bottomText ?? "bottom text") "

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(identifier: "SentMemesDetailViewController") as? SentMemesDetailViewController
        
        detailViewController?.meme = memes[(indexPath as NSIndexPath).row]
        detailViewController?.detailImageView?.image = memes[(indexPath as NSIndexPath).row].memeImage
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
    

}
