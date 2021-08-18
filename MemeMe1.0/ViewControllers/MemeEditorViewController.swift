//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 5/29/21.
//

import UIKit


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageViewPicker: UIImageView!
    var meme = Meme()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //if using simulator, album will be the only option otherwise, a physical device will allow for camera use
        // when picking an image
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //disable the upload button
        uploadButton.isEnabled = false
        
        self.view.backgroundColor = UIColor.black

        
        // setup textfields
        setupTextField(textField: topTextfield)
        setupTextField(textField: bottomTextfield)
        
        subscribeToKeyboardNotifications()
        
        //hide the tab bar for better ui
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomTextfield.delegate = self
        topTextfield.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func hideShow(_ isHiddenValue:Bool) {
        toolBar.isHidden = isHiddenValue
        navBar.isHidden = isHiddenValue
    }
    
    
    //MARK: handle the MemedImage
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        hideShow(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        hideShow(false)

        
        return memedImage
    }

    
    
    // Handle textfield setup
    func setupTextField(textField: UITextField){

        // topTextfield.defaultTextAttributes =
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSAttributedString.Key.strokeWidth:  -5.0
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.background = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 17.0
        
    }
    
    
    
    // MARK: ACTIONs for choosing an image or camera & saving
    @IBAction func pickAnImage(_ sender: Any) {

        let pickImageController = pickImage(type: UIImagePickerController.SourceType.photoLibrary)
        present(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {

        let cameraController = pickImage(type: UIImagePickerController.SourceType.camera)
        present(cameraController, animated: true, completion: nil)
        
    }
    
    // general functions
    func pickImage(type: UIImagePickerController.SourceType) -> UIImagePickerController {
        uploadButton.isEnabled = true
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = type
        return controller
    }
    
    
    @IBAction func save(_ sender: Any) {
        let image = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems:[image],applicationActivities: nil)

        present(activityController, animated: true, completion: nil)
        
        //completion handler
        activityController.completionWithItemsHandler = {(_ activityType: UIActivity.ActivityType?, completed:
                                                            Bool, _ arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                //save the meme
                self.meme = Meme(topText: self.topTextfield.text, bottomText: self.bottomTextfield.text, originalImage: self.imageViewPicker.image, memeImage: image)
                
                // add to the array in AppDelegate
                (UIApplication.shared.delegate as! AppDelegate).memes.append(self.meme)
                print("Saved the meme!")
                self.dismiss(animated: true, completion: nil)
            }else{
                print("cancelled")
                self.dismiss(animated: true, completion: nil)
            }
            
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        topTextfield.text = .none
        topTextfield.text = "TOP"
        
        bottomTextfield.text = .none
        bottomTextfield.text = "BOTTOM"
        
        imageViewPicker.image = .none
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // MARK: Protocols for image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // save the chosen image to the imageViewPicker
        let pic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageViewPicker.image = pic
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // now dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK : Protocols for textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.clearsOnBeginEditing = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: keyboard notifications and methods
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextfield.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        if bottomTextfield.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    
    func subscribeToKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
     }

}

