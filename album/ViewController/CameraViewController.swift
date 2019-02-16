//
//  CameraViewController.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var img: UIView!
    
    private var updatePath: String = ""
    weak private var pictureReceiveDelegate: PictureReceiveDelegate?
    
    private var captureSession : AVCaptureSession!
    private var stillImageOutput : AVCapturePhotoOutput?
    private var previewLayer : AVCaptureVideoPreviewLayer?
    
    static func makeCameraViewController(pictureReceiveDelegate: PictureReceiveDelegate?) -> CameraViewController? {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController {
            
            vc.pictureReceiveDelegate = pictureReceiveDelegate
            return vc
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        guard let output = stillImageOutput else { return }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            if(captureSession.canAddInput(input)){
                captureSession.addInput(input)
                
                if(captureSession.canAddOutput(output)){
                    captureSession.addOutput(output)
                    captureSession.startRunning()
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    img.layer.addSublayer(previewLayer!)
                    
                    previewLayer?.position = CGPoint(x: self.img.frame.width / 2, y: self.img.frame.height / 2)
                    previewLayer?.bounds = img.frame
                }
            }
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    // デリゲート。カメラで撮影が完了した後呼ばれる。
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            // JPEG形式で画像データを取得
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            var image = UIImage(data: photoData!)
            
            // 90度回転修正
            UIGraphicsBeginImageContext(image!.size)
            image?.draw(in: CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height))
            let context = UIGraphicsGetCurrentContext()
            context?.rotate(by: CGFloat(Double.pi / 2))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // フォトライブラリに保存
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            
//            let saveImg = SaveImage()
//            let savePath = saveImg.save(image: image!, updatePath: updatePath)
            
            if let img = image {
                let nextView = EditPictureViewController.makePictureViewController(picImage: img, pictureReceiveDelegate: pictureReceiveDelegate)
                self.navigationController?.pushViewController(nextView, animated: true)
            }
        }
    }
}
