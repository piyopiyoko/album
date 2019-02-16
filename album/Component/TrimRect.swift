//
//  TrimRect.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit

@IBDesignable
class TrimRect: UIImageView, UIGestureRecognizerDelegate {
    
    var apexArray = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
    var apexIndex = -1
    var minPos = CGPoint()
    var maxPos = CGPoint()
    
    let frameRectArray = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    
    init(frame: CGRect, rect: CGRect) {
        super.init(frame: frame)
        
        setApexArray(rect: rect)
        
        setGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setApexArray(rect: CGRect) {
        
        apexArray[0].x = rect.origin.x
        apexArray[0].y = rect.origin.y
        apexArray[1].x = rect.width
        apexArray[1].y = rect.origin.y
        apexArray[2].x = rect.width
        apexArray[2].y = rect.height
        apexArray[3].x = rect.origin.x
        apexArray[3].y = rect.height
        
        minPos = CGPoint(x: apexArray[0].x, y: apexArray[0].y)
        maxPos = CGPoint(x: apexArray[2].x, y: apexArray[2].y)
        
        setRect()
    }
    
    func switchDisplay(isDisp: Bool) {
        self.isUserInteractionEnabled = isDisp
        
        if(isDisp) {
            self.alpha = 1
        }
        else {
            self.alpha = 0
        }
    }
    
    private func makeRect(leftUpPos: CGPoint, rightDownPos: CGPoint) ->UIImage {
        
        UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: self.frame.height))
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        // トリミング矩形外の塗りつぶし
        context.setFillColor(UIColor.black.cgColor)
        context.setAlpha(0.5)
        context.fill(CGRect(x: 0, y: 0, width: self.bounds.width, height: leftUpPos.y))
        context.fill(CGRect(x: rightDownPos.x, y: leftUpPos.y, width: self.bounds.width - rightDownPos.x, height: rightDownPos.y - leftUpPos.y))
        context.fill(CGRect(x: 0, y: rightDownPos.y, width: self.bounds.width, height: self.bounds.height - rightDownPos.y))
        context.fill(CGRect(x: 0, y: leftUpPos.y, width: leftUpPos.x, height: rightDownPos.y - leftUpPos.y))
        
        // トリミング矩形
        context.setStrokeColor(UIColor.white.cgColor)
        context.setAlpha(1)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: leftUpPos.x, y: leftUpPos.y))
        context.addLine(to: CGPoint(x: rightDownPos.x, y: leftUpPos.y))
        context.move(to: CGPoint(x: rightDownPos.x, y: leftUpPos.y))
        context.addLine(to: CGPoint(x: rightDownPos.x, y: rightDownPos.y))
        context.move(to: CGPoint(x: rightDownPos.x, y: rightDownPos.y))
        context.addLine(to: CGPoint(x: leftUpPos.x, y: rightDownPos.y))
        context.move(to: CGPoint(x: leftUpPos.x, y: rightDownPos.y))
        context.addLine(to: CGPoint(x: leftUpPos.x, y: leftUpPos.y))
        
        // 線の太さが変わるので、一旦閉じる
        context.closePath()
        context.strokePath()
        
        // 四隅強調
        context.setLineWidth(1.5)
        context.move(to: CGPoint(x: leftUpPos.x, y: leftUpPos.y))
        context.addLine(to: CGPoint(x: leftUpPos.x + 10, y: leftUpPos.y))
        context.closePath()
        context.addLine(to: CGPoint(x: leftUpPos.x, y: leftUpPos.y + 10))
        context.move(to: CGPoint(x: rightDownPos.x, y: leftUpPos.y))
        context.addLine(to: CGPoint(x: rightDownPos.x - 10, y: leftUpPos.y))
        context.closePath()
        context.addLine(to: CGPoint(x: rightDownPos.x, y: leftUpPos.y + 10))
        context.move(to: CGPoint(x: rightDownPos.x, y: rightDownPos.y))
        context.addLine(to: CGPoint(x: rightDownPos.x - 10, y: rightDownPos.y))
        context.closePath()
        context.addLine(to: CGPoint(x: rightDownPos.x, y: rightDownPos.y - 10))
        context.move(to: CGPoint(x: leftUpPos.x, y: rightDownPos.y))
        context.addLine(to: CGPoint(x: leftUpPos.x + 10, y: rightDownPos.y))
        context.closePath()
        context.addLine(to: CGPoint(x: leftUpPos.x, y: rightDownPos.y - 10))
        
        // ドラッグ中の線
        switch apexIndex {
        case 0:
            context.move(to: CGPoint(x: 0, y: leftUpPos.y))
            context.addLine(to: CGPoint(x: self.bounds.width, y: leftUpPos.y))
            context.move(to: CGPoint(x: leftUpPos.x, y: 0))
            context.addLine(to: CGPoint(x: leftUpPos.x, y: self.bounds.height))
            break
        case 1:
            context.move(to: CGPoint(x: 0, y: leftUpPos.y))
            context.addLine(to: CGPoint(x: self.bounds.width, y: leftUpPos.y))
            context.move(to: CGPoint(x: rightDownPos.x, y: 0))
            context.addLine(to: CGPoint(x: rightDownPos.x, y: self.bounds.height))
            break
        case 2:
            context.move(to: CGPoint(x: rightDownPos.x, y: 0))
            context.addLine(to: CGPoint(x: rightDownPos.x, y: self.bounds.height))
            context.move(to: CGPoint(x: 0, y: rightDownPos.y))
            context.addLine(to: CGPoint(x: self.bounds.width, y: rightDownPos.y))
            break
        case 3:
            context.move(to: CGPoint(x: 0, y: rightDownPos.y))
            context.addLine(to: CGPoint(x: self.bounds.width, y: rightDownPos.y))
            context.move(to: CGPoint(x: leftUpPos.x, y: 0))
            context.addLine(to: CGPoint(x: leftUpPos.x, y: self.bounds.height))
            break
        case 4:
            context.move(to: CGPoint(x: 0, y: leftUpPos.y))
            context.addLine(to: CGPoint(x: self.bounds.width, y: leftUpPos.y))
            break
        case 5:
            context.move(to: CGPoint(x: rightDownPos.x, y: 0))
            context.addLine(to: CGPoint(x: rightDownPos.x, y: self.bounds.height))
            break
        case 6:
            context.move(to: CGPoint(x: 0, y: rightDownPos.y))
            context.addLine(to: CGPoint(x: self.bounds.width, y: rightDownPos.y))
            break
        case 7:
            context.move(to: CGPoint(x: leftUpPos.x, y: 0))
            context.addLine(to: CGPoint(x: leftUpPos.x, y: self.bounds.height))
            break
        default:
            break
        }
        
        context.closePath()
        context.strokePath()
        
        // UIImageの取得
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    // ジェスチャーのセット
    func setGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(TrimRect.pan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
    
    // ドラッグイベント
    @objc func pan(_ sender: UIPanGestureRecognizer){
        if(sender.state == UIGestureRecognizer.State.ended) {
            apexIndex = -1
            setRect()
            return
        }
        var pos : CGPoint = sender.location(ofTouch: 0, in: self)
        
        if(sender.state == UIGestureRecognizer.State.began) {
            // 四隅の当たり判定
            for i in 0...3 {
                if(CalcDistance(srcPt: pos, destPt: apexArray[i], buff: 20.0)) {
                    apexIndex = i
                }
            }
            // 四辺の当たり判定
            if(apexIndex == -1) {
                for i in 4...7 {
                    let n = i - 4
                    var m = i - 3
                    if(m > 3) {
                        m = 0
                    }
                    if(calcTouchLine(touchPos: pos, startPos: apexArray[n], endPos: apexArray[m], buff: 40.0)) {
                        apexIndex = i
                    }
                }
            }
            
        }
        if(apexIndex > -1) {
            if(pos.x < minPos.x) {
                pos.x = minPos.x
            }
            if(pos.x > maxPos.x) {
                pos.x = maxPos.x
            }
            if(pos.y < minPos.y) {
                pos.y = minPos.y
            }
            if(pos.y > maxPos.y) {
                pos.y = maxPos.y
            }
            setPosToRect(pos: pos, index: apexIndex)
            setRect()
        }
    }
    
    private func setRect() {
        
        // 微妙な隙間ができる対策
        let lx = (apexArray[0].x * 100).rounded() / 100
        let ly = (apexArray[0].y * 100).rounded() / 100
        let rx = (apexArray[2].x * 100).rounded() / 100
        let ry = (apexArray[2].y * 100).rounded() / 100
        let img = makeRect(leftUpPos: CGPoint(x: lx, y: ly), rightDownPos: CGPoint(x: rx, y: ry))
        self.image = img
    }
    
    // 四隅のタッチ判定
    private func CalcDistance(srcPt: CGPoint, destPt: CGPoint, buff: CGFloat) -> Bool {
        let dd = sqrt(pow(destPt.x - srcPt.x, 2) + pow(destPt.y - srcPt.y , 2))
        if(dd < buff) {
            return true
        }
        else {
            return false
        }
    }
    
    private func calcTouchLine(touchPos: CGPoint, startPos: CGPoint, endPos: CGPoint, buff: CGFloat) -> Bool {
        var start = CGPoint()
        var end = CGPoint()
        if(startPos.x == endPos.x) {
            start = CGPoint(x: startPos.x - buff / 2, y: startPos.y)
            end = CGPoint(x: endPos.x + buff / 2, y: endPos.y)
        }
        else {
            start = CGPoint(x: startPos.x, y: startPos.y - buff / 2)
            end = CGPoint(x: endPos.x, y: endPos.y + buff / 2)
        }
        if(start.x > end.x) {
            let temp = start.x
            start.x = end.x
            end.x = temp
        }
        if(start.y > end.y) {
            let temp = start.y
            start.y = end.y
            end.y = temp
        }
        if(touchPos.x >= start.x && touchPos.y >= start.y && touchPos.x <= end.x && touchPos.y <= end.y) {
            return true
        }
        return false
    }
    
    private func setPosToRect(pos: CGPoint, index: Int) {
        switch index {
        case 0:
            // 0番目のとき、1番目のy座標と、3番目のx座標も更新
            apexArray[index] = pos
            apexArray[1].y = pos.y
            apexArray[3].x = pos.x
            break
        case 1:
            // 1番目のとき、2番目のx座標と、0番目のy座標も更新
            apexArray[index] = pos
            apexArray[2].x = pos.x
            apexArray[0].y = pos.y
            break
        case 2:
            // 2番目のとき、3番目のy座標と、1番目のx座標も更新
            apexArray[index] = pos
            apexArray[3].y = pos.y
            apexArray[1].x = pos.x
            break
        case 3:
            // 3番目のとき、0番目のx座標と、2番目のy座標も更新
            apexArray[index] = pos
            apexArray[0].x = pos.x
            apexArray[2].y = pos.y
            break
        case 4:
            // 4番目のとき、0番目のy座標と、1番目のy座標を更新
            apexArray[0].y = pos.y
            apexArray[1].y = pos.y
            break
        case 5:
            // 5番目のとき、1番目のx座標と、2番目のx座標を更新
            apexArray[1].x = pos.x
            apexArray[2].x = pos.x
            break
        case 6:
            // 6番目のとき、2番目のy座標と、3番目のy座標を更新
            apexArray[2].y = pos.y
            apexArray[3].y = pos.y
            break
        case 7:
            // 7番目のとき、3番目のx座標と、0番目のx座標を更新
            apexArray[3].x = pos.x
            apexArray[0].x = pos.x
            break
        default:
            break
        }
    }
    
    // 画像の切り抜き
    func trimPicture(trimImg : UIImage, picFrame : CGRect) -> UIImage {
        
        let dispScale = UIScreen.main.scale
        let scaleX = picFrame.width / trimImg.size.width
        let scaleY = picFrame.height / trimImg.size.height
        var scale = scaleX
        if(scaleX > scaleY) {
            scale = scaleY
        }
        
        // トリミングした画像を白紙の上に貼り付け
        UIGraphicsBeginImageContextWithOptions(picFrame.size, false, 0.0)
        let drawRect = CGRect(x: (picFrame.size.width - trimImg.size.width * scale) / 2, y: (picFrame.size.height - trimImg.size.height * scale) / 2, width: trimImg.size.width * scale, height: trimImg.size.height * scale)
        trimImg.draw(in: drawRect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 切り抜き
        let x1 = apexArray[0].x - picFrame.origin.x
        let y1 = apexArray[0].y - picFrame.origin.y
        let x2 = apexArray[2].x - picFrame.origin.x
        let y2 = apexArray[2].y - picFrame.origin.y
        let rect2 = CGRect(x: x1 * dispScale, y: y1 * dispScale, width: (x2 - x1) * dispScale, height: (y2 - y1) * dispScale)
        
        let cropCGImageRef = img.cgImage!.cropping(to: rect2)
        let cropImage = UIImage(cgImage: cropCGImageRef!)
        
        return cropImage
    }
}
