//
//  ViewController.swift
//  StartHere
//
//  Created by DrNeurosurg on 16.10.17.
//  Copyright © 2017 DrNeurosurg. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {
    
    lazy var ocrRequest: VNCoreMLRequest = {
        do {
            //THIS MODEL IS TRAINED BY ME FOR FONT "Inconsolata" (Numbers 0...9 and UpperCase Characters A..Z)
            let model = try VNCoreMLModel(for:OCR().model)
            return VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
        } catch {
            fatalError("cannot load model")
        }
    }()
    
    //OUR COMPLETION-HANDLER
    func handleClassification(request: VNRequest, error: Error?)
    {
        guard let observations = request.results as? [VNClassificationObservation]
            else {fatalError("unexpected result") }
        guard let best = observations.first
            else { fatalError("cant get best result")}
        
        //ON MAIN-QUEUE
        DispatchQueue.main.async {
            
            //BEST.IDENTIFIER IS OUR PREDICTION WITH HIGHEST CONFIDENCE !
            print("recognized: " + best.identifier)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //LETS LOAD AN IMAGE FROM RESOURCE (TRY ANOTHER ONE ...)
        let ourFirstImage:UIImage = UIImage(named: "2.PNG")!
        
        //WE NEED AN CIIMAGE - NO NEED TO SCALE
        let ourInput:CIImage = CIImage(image:ourFirstImage)!
        
        //PREPARE THE HANDLER
        let handler = VNImageRequestHandler(ciImage: ourInput, options: [:])
        
        //SOME OPTIONS (TO PLAY WITH..)
        self.ocrRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
        
        //FEED IT TO THE QUEUE
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try  handler.perform([self.ocrRequest])
            } catch {
                print ("Error")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

