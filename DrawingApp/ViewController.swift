//
//  ViewController.swift
//  DrawingApp
//
//  Created by Janarthan Subburaj on 31/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Canvasview: CanvasView!
    @IBOutlet var FeaturesView: UIView!
    @IBOutlet weak var Collectionview: UICollectionView!
    @IBOutlet weak var BtnArrow: UIButton!
    @IBOutlet weak var WidthSlider: UISlider!
    @IBOutlet weak var OpacitySlider: UISlider!
    var BlurView = UIVisualEffectView()
    var kHeight: CGFloat = 130
    var animationTime = 0.35
    var colorsArray: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3823936913, green: 0.8900789089, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.4528176247, blue: 0.4432695911, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()
        OpacitySlider.tintColor = .red
        FeaturesView.transform = CGAffineTransform(translationX: 0, y: kHeight - (kHeight - 80))

    }
    @IBAction func OnClickHideShowFeatureView(_ sender: UIButton){
        if sender.isSelected {
            UIView.animate(withDuration: animationTime) {
                sender.isSelected = false
                self.BtnArrow.setBackgroundImage(#imageLiteral(resourceName: "up-arrow"), for: .normal)
                self.FeaturesView.transform = CGAffineTransform(translationX: 0, y: self.kHeight - (self.kHeight - 80))
            }
        } else {
            UIView.animate(withDuration: animationTime) {
                sender.isSelected = true
                self.BtnArrow.setBackgroundImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
                self.FeaturesView.transform = CGAffineTransform.identity
            }
        }
    }
    
    @IBAction func OnClickBrushWidth(_ sender: UISlider) {
        Canvasview.strokeWidth = CGFloat(sender.value)
    }
    
    @IBAction func OnClickOpacity(_ sender: UISlider) {
        Canvasview.strokeOpacity = CGFloat(sender.value)
    }
    @IBAction func OnClickClear(_ sender: Any) {
        Canvasview.clearCanvasView()
    }
    @IBAction func OnClickUndo(_ sender: Any) {
        Canvasview.undoDraw()
    }
    @IBAction func OnClickSave(_ sender: Any) {
       let image = Canvasview.takeScreenshot()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextType:)), nil)
    }
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextType: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your Drawing Save Successfully", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let view = cell.viewWithTag(111) {
            view.layer.cornerRadius = 3
            view.backgroundColor = colorsArray[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colorsArray[indexPath.row]
        Canvasview.strokeColor = color
    }
    
}

extension UIView {

    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
