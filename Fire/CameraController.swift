//
//  CameraController.swift
//  Fire
//
//  Created by Moogun Jung on 10/17/17.
//  Copyright © 2017 Moogun. All rights reserved.
//


import UIKit
import AVFoundation

@available(iOS 10.0, *)
@available(iOS 10.0, *)
class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Top section
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "down15"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Bottom section
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "shutter60"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto() {
        print("Capturing photo...")
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.__availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    
    //MARK:- Save taken image
    
    var previewImage: UIImage?
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let output = AVCapturePhotoOutput()
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        //defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        //2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    //MARK:- Passing image to new question
    
    var delegate: NewQuestionController?
    
    @objc func imageSaved() {
        delegate?.isImageSelected = true
        delegate?.selectedImage = previewImage
    }
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //transitioningDelegate = self
        
        setupCaptureSession()
        setupHUD()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageSaved), name: .imageSaved, object: nil)
    }
    
    func viewWillDisappear(animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
   
    fileprivate func setupHUD() {

        //MARK: Cover view
        
        let viewWidth = view.frame.width
        let halfViewwidth = viewWidth / 2
        
        let viewHeight = view.frame.height
        let halfViewHeight = viewHeight / 2
        
        let topCoverHeight = halfViewHeight - halfViewwidth
        
        let topCoverView = UIView()
        topCoverView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.addSubview(topCoverView)
        topCoverView.anchor(top: self.view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: topCoverHeight)
        
        let bottomCoverView = UIView()
        bottomCoverView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.addSubview(bottomCoverView)
        bottomCoverView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: topCoverHeight)
        
        let boundary = UIImageView()
        boundary.image = #imageLiteral(resourceName: "boundary300")
        boundary.contentMode = .scaleAspectFit
        view.addSubview(boundary)
        boundary.anchor(top: topCoverView.bottomAnchor, left: topCoverView.leftAnchor, bottom: bottomCoverView.topAnchor, right: topCoverView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        // also need to add same coverview for preview
        
        //MARK:- Button view
        
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    }
    
   
    
}

