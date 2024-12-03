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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    @IBAction func loadImage(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func topText(_ sender: Any) {
        textCoreGraphics(x: 0, y: 20)
    }
    @IBAction func bottomText(_ sender: Any) {
        guard let originalImage = viewImage.image else {
            print("bottomText - No image found")
            return
        }
        textCoreGraphics(x: 0, y: originalImage.size.height - 300)
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
    
    func textCoreGraphics(x: CGFloat, y: CGFloat) {
        guard let originalImage = viewImage.image else {
            print("topText - No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: originalImage.size)
        
        let img = renderer.image { ctx in
            // Рисуем оригинальное изображение
            originalImage.draw(at: .zero)
            
            // Текст и атрибуты
            let text = "From Storm Viewer\n(задание из project-27\n Core Graphics)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Chalkduster", size: 60) ?? UIFont.boldSystemFont(ofSize: 60),
                .foregroundColor: UIColor.red,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    return style
                }()
            ]
            
            // Рассчитываем прямоугольник для текста
            let textRect = CGRect(
                x: x,
                y: y, // отступ от верхней границы изображения
                width: originalImage.size.width,
                height: 300 // Высота под текст
            )
            
            // Рисуем текст в прямоугольнике
            text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        
        viewImage.image = img
    }
    
    @objc func shareTapped() {
        guard let image = viewImage.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        let imageName = "image from Lessons-90.jpg"
        // Создайте временный файл
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileURL = temporaryDirectory.appendingPathComponent(imageName)
        
        do {
            // Запишите данные изображения в файл
            try image.write(to: fileURL)
            
            // Передаем файл вместо данных изображения
            let itemsToShare: [Any] = [fileURL]
            
            let vc = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        } catch {
            print("Error saving image: \(error)")
        }
    }
}

