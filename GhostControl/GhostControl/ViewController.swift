//
//  ViewController.swift
//  HelloWorld
//
//  Created by Joseph Nechleba on 4/21/18.
//  Copyright © 2018 Joseph Nechleba. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet var previewView: NSView!
    @IBOutlet weak var direction_label: NSTextField!
    @IBOutlet weak var mouse_pos_field: NSTextField!
    @IBAction func sayButtonClicked(_ sender: Any) {
        var x:Int? = 0
        var y:Int? = 0
        let mouse_pos_string = mouse_pos_field.stringValue
        if mouse_pos_string.isEmpty {
            print("is empty")
        }
        else {
            var coordinates = mouse_pos_string.characters.split{$0 == " "}.map(String.init)
            x = Int(coordinates[0])
            y = Int(coordinates[1])
            print(x)
            print(y)
            let cg_point = CGPoint.init(x: x!, y: y!)
            CGDisplayMoveCursorToPoint(CGMainDisplayID(), cg_point)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var capture_session: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        capture_session = AVCaptureSession()
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        print(videoDevice)
        do {
            let input = try AVCaptureDeviceInput(device: videoDevice)
            capture_session?.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session:capture_session)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = (view.layer?.bounds)!
            previewView.layer?.addSublayer(videoPreviewLayer!)
            capture_session?.startRunning()
        } catch {
            return
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

