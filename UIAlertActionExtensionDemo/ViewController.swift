//
//  ViewController.swift
//  UIAlertActionExtensionDemo
//
//  Created by JiongXing on 2017/8/10.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onPopButton(_ sender: UIButton) {
        let cameraAction = UIAlertAction(title: "拍摄", style: .default) { (action) in
            print("拍摄")
        }
        let photoAction = UIAlertAction(title: "相册", style: .default) { (action) in
            print("相册")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dump(UIAlertAction.propertyNames)
        // 设置颜色
        cameraAction.setTextColor(UIColor.darkText)
        photoAction.setTextColor(UIColor.darkText)
        cancelAction.setTextColor(UIColor.darkText)
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

