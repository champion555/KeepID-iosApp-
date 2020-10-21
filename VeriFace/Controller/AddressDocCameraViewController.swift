//
//  AddressDocCameraViewController.swift
//  VeriFace
//
//  Created by Admin on 9/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
class AddressDocCameraViewController: UIViewController {
    @IBOutlet weak var rectFrameView: UIView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var btnTake: UIButton!
    @IBOutlet weak var btnReTake: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    var captureSession = AVCaptureSession()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var originalImage: UIImage?
    let imagePicker = UIImagePickerController()
    let shapeLayer = CAShapeLayer()
    var cropRect: CGRect!
    var IdType: String = ""
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var isFlash: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        //set up capture session
        setupCaptureSession()
        //set up devic
        setupDevice()
        //set up input and output
        setupInputOutput()
        //set up preview the photo that take from camera or gallery
        setupPreviewLayer()
        //start capture
        startRunningCaptureSession()
        
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let xPos = 0.04 * screenWidth
        let yPos = 0.19 * screenHeight
        let rectWidth = screenWidth - 2 * xPos
        let rectHeight = screenHeight - 3.55 * yPos
        cropRect = CGRect(x:CGFloat(xPos), y:CGFloat(yPos), width:CGFloat(rectWidth), height:CGFloat(rectHeight))
        txtTitle.text = "Powered by BIOMIID"
        if IdType == "AddressDoc"{
            txtMessage.text = "Place the Address Document inside the Frame and take the Photo"
        }
    }
    func configureView(){
        previewImage.isHidden = true
        btnTake.layer.cornerRadius = 10
        btnReTake.layer.cornerRadius = 10
        btnTake.isHidden = true
        btnReTake.isHidden = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setupDevice() {
        //get Camera from device
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        //set the camera to back or front
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        //set up the backCamera to current camera
        currentCamera = backCamera
    }
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!) //if there is camera in device
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    func cropImage(_ inputImage: UIImage) -> UIImage?
    {
        let xPos = 0.19 * inputImage.size.width
        let yPos = 0.11 * inputImage.size.height
        let rectWidth = inputImage.size.width - 0.8 * xPos
        let rectHeight = inputImage.size.height - 4.3 * yPos
        let rectangle = CGRect(x:CGFloat(xPos), y:CGFloat(yPos), width:CGFloat(rectWidth), height:CGFloat(rectHeight))
        
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:rectangle)
        else {
            return nil
        }
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        let rotateImage: UIImage = croppedImage.rotateImage(radians: .pi/2)!
        
        let timestamp = NSDate().timeIntervalSince1970
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "IDDocPhoto" + "\(timestamp)" + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let data = rotateImage.jpegData(compressionQuality:  1.0)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data!.write(to: fileURL)
                print("file saved")
                  if IdType == "AddressDoc"{
                    AppUtils.savetoUserDefaults(value: fileURL.absoluteString, key: "AddressDocPath")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingAddressDocViewController") as! KYCSettingAddressDocViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch {
                print("error saving file:", error)
            }
        }
        
        return croppedImage
    }
    
    @IBAction func onCapture(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onPhotoTake(_ sender: Any) {
        cropImage(originalImage!)
    }
    @IBAction func onReTake(_ sender: Any) {
        previewImage.isHidden = true
        btnTake.isHidden = true
        btnReTake.isHidden = true
        btnCapture.isHidden = false
        btnFlash.isHidden = false
        txtTitle.text = "Powered by BIOMIID"
        if IdType == "AddressDoc"{
            txtMessage.text = "Place the Address Document inside the Frame and take the Photo"
        }
    }
    @IBAction func onFlash(_ sender: Any) {
        if isFlash == false{
            toggleTorch(on: true)
            btnFlash.setImage(UIImage(named: "camera_flash_on.png"), for: .normal)
            isFlash = true
        }else{
            toggleTorch(on: false)
            btnFlash.setImage(UIImage(named: "camera_flash_off.png"), for: .normal)
            isFlash = false
        }
        
    }
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
extension AddressDocCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {

            let image :UIImage = UIImage(data: imageData)!
            previewImage.isHidden = false
            btnTake.isHidden = false
            btnReTake.isHidden = false
            previewImage.image = image
            originalImage = previewImage.image
            btnCapture.isHidden = true
            btnFlash.isHidden = true
            txtTitle.text = "Preview Captured ID Document"
            txtMessage.text = "Make sure the ID Document image is clear to read"
        }
    }
}
extension UIImage {
    func rotateImage(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
