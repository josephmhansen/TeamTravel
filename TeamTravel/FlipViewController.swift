//
//  FlipViewController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/15/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class FlipViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "CaptureStarted")))
        }
        sleep(1)
        dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
