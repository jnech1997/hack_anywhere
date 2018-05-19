//
//  ViewController.swift
//  GhostControl
//
//  Created by Will Estey and Joseph Nechleba on 4/21/18.

import Cocoa
import AVFoundation
import Foundation


class ViewController: NSViewController, NSSpeechRecognizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet var previewView: NSView!
    @IBOutlet weak var direction_label: NSTextField!
    @IBOutlet weak var mouse_pos_field: NSTextField!
    @IBAction func make_space(_ sender: Any) {
        var possibleError: NSDictionary?
        var possibleError1: NSDictionary?
        var possibleError2: NSDictionary?
        var possibleError3: NSDictionary?
        let a_script = NSAppleScript.init(source:"do shell script \"open -a 'Mission Control'\"")
        let a_script1 = NSAppleScript.init(source:"delay 0.5")
        let a_script2 = NSAppleScript.init(source:"tell application \"System Events\" to click (every button whose value of attribute \"AXDescription\" is \"add desktop\") of group 2 of group 1 of group 1 of process \"Dock\"");
        let a_script3 = NSAppleScript.init(source: "tell application \"System Events\" to key code 53");
        a_script?.executeAndReturnError(&possibleError);
        a_script1?.executeAndReturnError(&possibleError1);
        a_script2?.executeAndReturnError(&possibleError2);
        a_script3?.executeAndReturnError(&possibleError3);
        if let error = possibleError {
            print("ERROR: \(error)")
        }
        else if  let error = possibleError1 {
            print("ERROR: \(error)")
        }
        else if let error = possibleError2 {
            print("ERROR: \(error)")
        }
        else if let error = possibleError3 {
            print("ERROR: \(error)")
        }
    }
    @IBAction func move_left(_ sender: Any) {
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(source: "tell application \"System Events\" to key code 123 using control down")
        a_script?.executeAndReturnError(&possibleError);
        if let error = possibleError {
            print("ERROR: \(error)")
        }
    }
    @IBAction func move_right(_ sender: Any) {
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(source: "tell application \"System Events\" to key code 124 using control down")
        a_script?.executeAndReturnError(&possibleError);
        if let error = possibleError {
            print("ERROR: \(error)")
        }
    }
    
    @IBAction func sayButtonClicked(_ sender: Any) {
        var x:Int? = 0
        var y:Int? = 0
        let mouse_pos_string = mouse_pos_field.stringValue
        if mouse_pos_string.isEmpty {
            print("is empty")
        }
        else {
            var coordinates = mouse_pos_string.characters.split{$0 == " "}.map(String.init)
            if (coordinates.count != 2) {
                print("must enter two coordinates");
            }
            else {
                x = Int(coordinates[0])
                y = Int(coordinates[1])
                print(x)
                print(y)
                if (x != nil && y != nil) {
                    let cg_point = CGPoint.init(x: x!, y: y!)
                    CGDisplayMoveCursorToPoint(CGMainDisplayID(), cg_point)
                }
            }
        }
    }
    
    func make_space_face() {
        var possibleError: NSDictionary?
        var possibleError1: NSDictionary?
        var possibleError2: NSDictionary?
        var possibleError3: NSDictionary?
        let a_script = NSAppleScript.init(source:"do shell script \"open -a 'Mission Control'\"")
        let a_script1 = NSAppleScript.init(source:"delay 0.5")
        let a_script2 = NSAppleScript.init(source:"tell application \"System Events\" to click (every button whose value of attribute \"AXDescription\" is \"add desktop\") of group 2 of group 1 of group 1 of process \"Dock\"");
        let a_script3 = NSAppleScript.init(source: "tell application \"System Events\" to key code 53");
        a_script?.executeAndReturnError(&possibleError);
        a_script1?.executeAndReturnError(&possibleError1);
        a_script2?.executeAndReturnError(&possibleError2);
        a_script3?.executeAndReturnError(&possibleError3);
        if let error = possibleError {
            //print("ERROR: \(error)")
        }
        else if  let error = possibleError1 {
            //print("ERROR: \(error)")
        }
        else if let error = possibleError2 {
            //print("ERROR: \(error)")
        }
        else if let error = possibleError3 {
            //print("ERROR: \(error)")
        }
    }
    
    func move_left_face() {
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(source: "tell application \"System Events\" to key code 123 using control down")
        a_script?.executeAndReturnError(&possibleError);
        if let error = possibleError {
            //print("ERROR: \(error)")
        }
    }
    
    func move_right_face() {
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(source: "tell application \"System Events\" to key code 124 using control down")
        a_script?.executeAndReturnError(&possibleError);
        if let error = possibleError {
            //print("ERROR: \(error)")
        }
    }
    
    func initCamera() {
        var capture_session: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        capture_session = AVCaptureSession()
        capture_session?.sessionPreset = AVCaptureSessionPresetLow
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //print(videoDevice)
        
        do {
            let input = try AVCaptureDeviceInput(device: videoDevice)
            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
            ]
            capture_session?.addInput(input)
            capture_session?.addOutput(output)
            let captureSessionQueue = DispatchQueue(label: "GhostControlQueue", attributes: [])
            output.setSampleBufferDelegate(self, queue: captureSessionQueue)
            let videoConnection = output.connection(withMediaType: AVMediaTypeVideo)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session:capture_session)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = (view.layer?.bounds)!
            previewView.layer?.addSublayer(videoPreviewLayer!)
            for connection in output.connections {
                if let conn = connection as? AVCaptureConnection {
                    if conn.isVideoOrientationSupported {
                        //print(conn.isVideoMinFrameDurationSupported);
                        conn.videoMinFrameDuration = CMTimeMake(1, 10)
                        conn.videoOrientation = AVCaptureVideoOrientation.portrait
                    }
                }
            }
            capture_session?.commitConfiguration()
            capture_session?.startRunning()
            //print(captureSessionQueue)
        } catch {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //initCamera()
        let speecher:NSSpeechRecognizer = NSSpeechRecognizer.init()!;
        speecher.commands = ["move desktop right", "move desktop left", "make new desktop space"];
        speecher.delegate = self;
        speecher.listensInForegroundOnly = false;
        speecher.startListening()
    }
    
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command:AnyObject?) {
        //print(command!);
        if (command as! String == "make new desktop space") {
            make_space_face();
        }
        else if (command as! String == "move desktop left") {
            move_left_face();
        }
        else if (command as! String == "move desktop right") {
            move_right_face();
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let image = CIImage(cvImageBuffer: imageBuffer)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let faces = faceDetector?.features(in: image, options: [CIDetectorEyeBlink:true, CIDetectorSmile:true]) as! [CIFaceFeature]
        for face in faces {
            if (!face.leftEyeClosed && face.rightEyeClosed) {
                move_left_face();
            }
            else if (face.leftEyeClosed && !face.rightEyeClosed) {
                move_right_face();
            }
            else if (face.hasSmile) {
                make_space_face();
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

