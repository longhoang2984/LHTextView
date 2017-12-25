//
//  ViewController.swift
//  LHTextView
//
//  Created by Hoàng Cửu Long on 12/25/17.
//  Copyright © 2017 Long Hoàng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LHTextViewDelegate {

    @IBOutlet weak var lhTextView: LHTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lhTextView.behavior = self
        
        lhTextView.titleColor = .purple
        lhTextView.activeTitleColor = .blue
        lhTextView.lineViewColor = .lightGray
        lhTextView.activeLineViewColor = .blue
//        lhTextView.errorMsg = "Error"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidChange(_ lhTextView: LHTextView) {
        print(lhTextView.text)
    }
}

