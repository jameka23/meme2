//
//  SentMemesDetailViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 8/5/21.
//

import UIKit

class SentMemesDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var detailImageView: UIImageView!
     
    override func viewDidLoad() {
        detailImageView.image = meme.memeImage
    }
}
