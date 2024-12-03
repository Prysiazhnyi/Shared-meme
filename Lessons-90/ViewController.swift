//
//  ViewController.swift
//  Lessons-90
//
//  Created by Serhii Prysiazhnyi on 03.12.2024.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var viewImage: UIImageView!
    
    //var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func loadImage(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func topText(_ sender: Any) {
        
    }
    @IBAction func bottomText(_ sender: Any) {
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        viewImage.alpha = 0
        viewImage.image = image
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            self.viewImage.alpha = 1
        })
        
        viewImage.image = image
    }
    
    
}

