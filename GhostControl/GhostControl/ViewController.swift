//
//  ViewController.swift
//  GhostControl
//
//  Created by Will Estey and Joseph Nechleba on 4/21/18.

import Cocoa
import AVFoundation
import Foundation


class ViewController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet var previewView: NSView!
    @IBOutlet weak var direction_label: NSTextField!
    @IBOutlet weak var mouse_pos_field: NSTextField!
    @IBAction func make_space(_ sender: Any) {
        let url = URL.init(fileURLWithPath: "/Users/josephnechleba/Desktop/make_space.scpt")
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(contentsOf: url, error: &possibleError)
        a_script?.executeAndReturnError(&possibleError);
        if let error = possibleError {
            print("ERROR: \(error)")
        }
    }
    @IBAction func move_left(_ sender: Any) {
        let url = URL.init(fileURLWithPath: "/Users/josephnechleba/Desktop/move_space_left.scpt")
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(contentsOf: url, error: &possibleError)
        a_script?.executeAndReturnError(&possibleError);
        if let error = possibleError {
            print("ERROR: \(error)")
        }
    }
    @IBAction func move_right(_ sender: Any) {
        let url = URL.init(fileURLWithPath: "/Users/josephnechleba/Desktop/move_space_right.scpt")
        var possibleError: NSDictionary?
        let a_script = NSAppleScript.init(contentsOf: url, error: &possibleError)
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
    
    func initCamera() {
        var capture_session: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        capture_session = AVCaptureSession()
        capture_session?.sessionPreset = AVCaptureSessionPresetLow
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        print(videoDevice)
        
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
                        print(conn.isVideoMinFrameDurationSupported);
                        conn.videoMinFrameDuration = CMTime.init(seconds: 1, preferredTimescale: Int32.init(1))
                        conn.videoOrientation = AVCaptureVideoOrientation.portrait
                    }
                }
            }
            capture_session?.commitConfiguration()
            capture_session?.startRunning()
            print(captureSessionQueue)
        } catch {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initCamera()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print(sampleBuffer);
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let image = CIImage(cvImageBuffer: imageBuffer)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let faces = faceDetector?.features(in: image) as! [CIFaceFeature]
        print("Number of faces: \(faces.count)");
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

