//
//  GIFViewController.swift
//  twitter
//
//  Created by alexhl09 on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK
import SFProgressCircle

@objc public protocol GIFDelegate {
    func mySelectedGIF(gif : GPHMedia)
   
}
@objc public class GIFViewController: UIViewController, UITextViewDelegate {
  
    

    
    let giphy = GiphyViewController()
    var delegate : GIFDelegate!
    override public func viewDidLoad() {
        super.viewDidLoad()
       
GiphyUISDK.configure(apiKey: "l2BYa4E677tC2E54mGcOAMdeRAIEH3JK")
        giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji]
giphy.showConfirmationScreen = true
        giphy.renditionType = .fixedWidth
        giphy.theme = .dark
        giphy.layout = .waterfall
        giphy.delegate = self
        present(giphy, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true )
        
    }
    @IBAction func addGif(_ sender: Any) {
        
        
    }
    
    
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 140;

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GIFViewController: GiphyDelegate {
    public func didSelectMedia(_ media: GPHMedia) {
        // your user tapped a GIF!
        print(media.url)
    }
    public func didDismiss(controller: GiphyViewController?) {
        // your user dismissed the controller without selecting a GIF.
    }
}
