//
//  SentMemesCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 7/26/21.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

    // obtain the array of Memes from AppDelegate
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(AddNewMeme))
        

        // Do any additional setup after loading the view.
        let space:CGFloat = 1.5
        let dimension = (view.frame.size.width - (4 * space)) / 2.0
        let heightDimension = (view.frame.size.height - (4 * space) / 2.0)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: heightDimension)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @objc func AddNewMeme(){
        
        self.performSegue(withIdentifier: "NewMemeSegue", sender: self)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Configure the cell
        cell.memeImageView?.image = meme.memeImage!
    
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(identifier: "SentMemesDetailViewController") as? SentMemesDetailViewController
        
        detailViewController?.meme = memes[(indexPath as NSIndexPath).row]
        detailViewController?.detailImageView?.image = memes[(indexPath as NSIndexPath).row].memeImage
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
}
