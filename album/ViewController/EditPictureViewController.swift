//
//  PictureViewController.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

class EditPictureViewController: UIViewController {
    @IBOutlet weak var picture: UIImageView!
    
    private var picImage = UIImage()
    private var rotateImage = UIImage()
    private var displayImageView = UIImageView()
    private var angle : CGFloat = 0
    private var editView : PictureEditPanel?
    private var trimRectView : TrimRect?
    private var editPictureHeight = UIScreen.main.bounds.height * 0.9
    private var pictureFrame = CGRect()
    weak private var pictureReceiveDelegate: PictureReceiveDelegate?
    
    static func makePictureViewController(picImage: UIImage, pictureReceiveDelegate: PictureReceiveDelegate?) -> EditPictureViewController {
        
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditPictureViewController") as! EditPictureViewController
        nextView.picImage = picImage
        nextView.pictureReceiveDelegate = pictureReceiveDelegate
        
        return nextView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPicture()
        setupTrimRect()
        setupEditPanel()
    }
    
    private func setupPicture() {
        picture.translatesAutoresizingMaskIntoConstraints = true
        picture.image = picImage
        rotateImage = picImage
        displayImageView.image = picImage
        view.addSubview(displayImageView)
    }
    
    private func setupTrimRect() {
        let frame =  CGRect(x: picture.bounds.origin.x, y: picture.bounds.origin.y, width: UIScreen.main.bounds.width, height: editPictureHeight)
        trimRectView = TrimRect(frame: frame, rect: frame)
        switchDisplay(isDisp: false)
        
        self.view.addSubview(trimRectView!)
        
    }
    
    private func setupEditPanel() {
        
        let posY = editPictureHeight
        let h = UIScreen.main.bounds.height - posY
        editView = PictureEditPanel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.size.width, height: h))
        
        // 完了ボタン
        editView?.finishButton.addTarget(self, action: #selector(finishClick(_:)), for: .touchUpInside)
        
        // キャンセルボタン
        editView?.cancelButton.addTarget(self, action: #selector(cancelClick(_:)), for: .touchUpInside)
        
        // トリミングボタン
        editView?.trimButton.addTarget(self, action: #selector(trimClick(_:)), for: .touchUpInside)
        
        // 回転ボタン
        editView?.rotateButton.addTarget(self, action: #selector(rotateClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(editView!)
    }
    
    @objc func finishClick(_ sender:UITapGestureRecognizer) {
        
        moveOutEditPanel()
        switchDisplay(isDisp: false)
    }
    
    @objc func cancelClick(_ sender:UITapGestureRecognizer) {
        
        let alert = UIAlertController(
            title: "",
            message: "編集中のデータが消えますが、よろしいでしょうか？",
            preferredStyle: .alert)
        
        // OK
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] action in
            self.picture.image = self.picImage
            self.displayImageView.image = self.picImage
            self.rotateImage = self.picImage
            self.angle = 0
            self.switchDisplay(isDisp: false)
            self.moveOutEditPanel()
        }))
        
        // キャンセル
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func trimClick(_ sender:UITapGestureRecognizer) {
        
        picture.image = trimRectView?.trimPicture(trimImg: picture.image!, picFrame: picture.frame)
        rotateImage = picture.image!
        displayImageView.image = picture.image!
        trimDisplayImageView()
    }
    
    @objc func rotateClick(_ sender:UITapGestureRecognizer) {
        
        var scale : CGFloat = 1
        angle += 90
        if(angle >= 360) {
            angle = 0
        }
        var imgSize = rotateImage.size
        if(angle == 90 || angle == 270) {
            imgSize = CGSize(width: rotateImage.size.height, height: rotateImage.size.width)
        }
        let widthScale = picture.frame.width / imgSize.width
        let heightScale = picture.frame.height / imgSize.height
        scale = widthScale
        if(widthScale > heightScale) {
            scale = heightScale
        }
        imgSize = CGSize(width: imgSize.width * scale, height: imgSize.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: imgSize.width / 2, y: imgSize.height / 2)
        context.scaleBy(x: scale, y: -scale)
        
        let radian: CGFloat = (-angle) * CGFloat(Double.pi) / 180.0
        context.rotate(by: radian)
        
        context.draw(self.rotateImage.cgImage!, in: CGRect(x:-self.rotateImage.size.width/2, y:-self.rotateImage.size.height/2, width:self.rotateImage.size.width, height:self.rotateImage.size.height))
        
        let rotatedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 画面サイズに回転画像を貼り付け
        let drawSize = CGSize(width: picture.frame.width, height: picture.frame.height)
        UIGraphicsBeginImageContextWithOptions(drawSize, false, 0.0)
        let r = CGRect(x: (picture.frame.width - rotatedImage.size.width) / 2, y: (picture.frame.height - rotatedImage.size.height) / 2, width: rotatedImage.size.width, height: rotatedImage.size.height)
        rotatedImage.draw(in: r)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.picture.image = img
        
        // 表示用ImageViewの修正
        imgSize = CGSize(width: imgSize.height, height: imgSize.width)
        fixDisplayImageView(imgSize: imgSize, isFrameAnim: true)
    }
    
    private func trimDisplayImageView() {
        
        var imgSize = getImgSize(imgSize: rotateImage.size)
        if(angle == 0 || angle == 180) {
            imgSize = CGSize(width: imgSize.height, height: imgSize.width)
        }
        else {
            imgSize = CGSize(width: imgSize.width, height: imgSize.height)
        }
        
        // 表示用ImageViewの修正
        imgSize = CGSize(width: imgSize.height, height: imgSize.width)
        
        angle = 0
        fixDisplayImageView(imgSize: imgSize, isFrameAnim: false)
    }
    
    private func initDisplayImageView() {
        
        var imgSize = rotateImage.size
        if(angle == 90 || angle == 270) {
            imgSize = CGSize(width: rotateImage.size.height, height: rotateImage.size.width)
        }
        imgSize = getImgSize(imgSize: imgSize)
        
        // 表示用ImageViewの修正
        imgSize = CGSize(width: imgSize.width, height: imgSize.height)
        
        fixDisplayImageView(imgSize: imgSize, isFrameAnim: false)
        
    }
    
    private func getImgSize(imgSize: CGSize) -> CGSize {
        
        var scale : CGFloat = 1
        let widthScale = picture.frame.width / imgSize.width
        let heightScale = picture.frame.height / imgSize.height
        scale = widthScale
        if(widthScale > heightScale) {
            scale = heightScale
        }
        return CGSize(width: imgSize.width * scale, height: imgSize.height * scale)
    }
    
    private func fixDisplayImageView(imgSize : CGSize, isFrameAnim: Bool) {
        
        if(isFrameAnim) {
            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                self.rotateDisplayImageView(imgSize: imgSize)
            })
        }
        else {
            self.rotateDisplayImageView(imgSize: imgSize)
        }
        
        let x1 = displayImageView.frame.origin.x
        let y1 = displayImageView.frame.origin.y
        let x2 = displayImageView.frame.width
        let y2 = displayImageView.frame.height
        trimRectView?.setApexArray(rect: CGRect(x: x1, y: y1, width: x1 + x2, height: y1 + y2))
    }
    
    private func rotateDisplayImageView(imgSize : CGSize) {
        
        self.displayImageView.frame = CGRect(x: (UIScreen.main.bounds.size.width - imgSize.width) / 2, y: (self.picture.frame.height - imgSize.height) / 2 + self.picture.frame.origin.y, width: imgSize.width, height: imgSize.height)
        
        self.displayImageView.transform = CGAffineTransform(rotationAngle: self.angle * CGFloat(Double.pi) / 180.0)
    }
    
    // 編集パネルを画面外へしまう
    func moveOutEditPanel() {
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.editView?.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + self.editView!.height / 2)
        })
        
        UIView.animate(withDuration: 1, animations: { [unowned self] in
            self.picture.frame = self.pictureFrame
        })
    }
    
    private func switchDisplay(isDisp: Bool) {
        trimRectView?.switchDisplay(isDisp: isDisp)
        
        if(isDisp) {
            self.picture.alpha = 0
            self.trimRectView?.alpha = 1
            self.displayImageView.alpha = 1
        }
        else {
            self.picture.alpha = 1
            self.trimRectView?.alpha = 0
            self.displayImageView.alpha = 0
        }
    }
    
    private func save(image : UIImage, updatePath : String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let newPath = path + "/image"
        do {
            try FileManager.default.createDirectory(atPath: newPath, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            
        }
        
        // 画像保存
        var fileName = ""
        if(updatePath != "") {
            fileName = updatePath
        }
        else {
            fileName = getNowClockString()
        }
        let savePath = newPath + "/" + fileName + ".png"
        if let data = image.pngData(){
            FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
        }
        return savePath.lastPathComponent
    }
    
    private func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    @IBAction func clickRetry(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickEdit(_ sender: Any) {
        let movePos = CGPoint(x: UIScreen.main.bounds.width / 2, y: self.editView!.posY + self.editView!.height / 2)
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.editView?.center = movePos
        })
        
        pictureFrame = picture.frame
        
        let frame = CGRect(x: self.picture.frame.origin.x, y: self.picture.frame.origin.y, width: self.picture.frame.width, height: self.editPictureHeight)
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.picture.frame = frame
            }, completion: { [unowned self] result in
                self.switchDisplay(isDisp: true)
        })
        
        self.initDisplayImageView()
    }
    
    @IBAction func clickOk(_ sender: Any) {
        guard let img = picture.image else { return }
        
        let savePath = save(image: img, updatePath: "")
        pictureReceiveDelegate?.receivePicture(paths: [savePath])
        
        if let cnt = self.navigationController?.viewControllers.count {
            self.navigationController?.viewControllers.remove(at: cnt - 2)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
