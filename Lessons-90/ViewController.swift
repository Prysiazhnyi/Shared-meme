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
        title = "Your image!"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clearImage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    @IBAction func loadImage(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func topText(_ sender: Any) {
        textCoreGraphics(x: 10, y: 20, isBottomAligned: false)
    }
    @IBAction func bottomText(_ sender: Any) {
        textCoreGraphics(x: 10, y: 20, isBottomAligned: true)
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
    
    func textCoreGraphics(x: CGFloat, y: CGFloat, isBottomAligned: Bool) {
        guard let originalImage = viewImage.image else {
            print("No image found")
            return
        }
        
        // Создаем алерт для ввода текста
        let ac = UIAlertController(title: "Enter your text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // Действие при подтверждении
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text, !text.isEmpty else { return }
            
            let renderer = UIGraphicsImageRenderer(size: originalImage.size)
            
            let img = renderer.image { ctx in
                // Рисуем оригинальное изображение
                originalImage.draw(at: .zero)
                
                // Атрибуты текста
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Chalkduster", size: 60) ?? UIFont.boldSystemFont(ofSize: 60),
                    .foregroundColor: UIColor.red,
                    .paragraphStyle: {
                        let style = NSMutableParagraphStyle()
                        style.alignment = .center
                        return style
                    }()
                ]
                
                // Рассчитываем размер текста
                let maxSize = CGSize(width: originalImage.size.width - 20, height: .greatestFiniteMagnitude)
                let textBounds = text.boundingRect(
                    with: maxSize,
                    options: .usesLineFragmentOrigin,
                    attributes: attributes,
                    context: nil
                )
                
                // Рассчитываем начальную позицию для текста
                let textHeight = textBounds.height
                let textY: CGFloat = isBottomAligned
                ? originalImage.size.height - textHeight - y // Текст снизу
                : y // Текст сверху
                
                let textRect = CGRect(
                    x: x,
                    y: textY,
                    width: originalImage.size.width - 20, // Оставляем отступы
                    height: textHeight
                )
                
                // Рисуем текст
                text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            }
            
            // Обновляем изображение
            self?.viewImage.image = img
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
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
    
    @objc func clearImage() {
        print("Tap Cancel")
        viewImage.image = nil // Убираем изображение из UIImageView
    }
}

