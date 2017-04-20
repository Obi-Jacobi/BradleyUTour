//
//  LandmarkViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 4/12/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import RealmSwift

class LandmarkViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mainView: UIView!
    
    @IBAction func buttonPressed(_ sender: Any) {
        
    }
    
    var landmark:Landmark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 15
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.darkGray.cgColor
        
        guard let landmark = landmark
            else {
                return
        }
        titleLabel.text = landmark.name
        descriptionText.text = landmark.landmarkDescription
        
        if let image = UIImage(data: landmark.image as Data) {
            imageView.image = image
        }
        else {
            imageView.image = UIImage(named: "Kaboom")
            
            descriptionText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi dapibus pharetra metus, id euismod odio pretium in. Quisque risus augue, hendrerit quis est eu, gravida semper justo. Aenean varius nec mauris iaculis posuere. Vestibulum interdum sapien vitae rutrum pharetra. Sed eget ex magna. Aenean tortor ex, tempus a elit nec, lobortis pretium lorem. Mauris viverra a leo sed gravida. In tempus lectus in iaculis commodo. Maecenas vehicula dapibus ipsum. Donec porta turpis nec tellus hendrerit efficitur. Fusce bibendum accumsan velit eu vestibulum. Ut congue metus aliquet diam gravida, rutrum feugiat risus semper. Phasellus sit amet leo eu massa ultricies scelerisque. Duis efficitur elementum accumsan. Praesent mattis nunc ut risus posuere, dictum sodales velit venenatis. Nunc quis ultrices ipsum, efficitur finibus *purus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut dignissim vestibulum odio nec sollicitudin. Pellentesque ac condimentum dui. Vestibulum semper augue sit amet pretium eleifend. Suspendisse venenatis ac ante nec cursus. Vestibulum ante ipsum" /*primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum sem enim, aliquet sed placerat vitae, varius sed nunc. Aliquam laoreet, tortor eu rutrum aliquet, ipsum magna feugiat arcu, vehicula accumsan sapien tortor vitae sapien. Nam commodo dapibus nibh eu viverra.Ut sit amet ligula id lacus tempor accumsan. Nullam in ornare augue, quis iaculis nisi. Sed libero justo, consequat sit amet sagittis eget, convallis id lacus. Curabitur magna diam, pretium et metus sed, dapibus dignissim diam. Proin elementum massa convallis hendrerit tincidunt. Sed semper purus a felis facilisis lacinia. Maecenas efficitur sodales fermentum. Praesent lacinia luctus faucibus."*/
            descriptionText.sizeToFit()
            let constraints = mainView.constraints
            for constraint in constraints {
                if constraint.firstAttribute == NSLayoutAttribute.height {
                    //print("Right here")
                    print(descriptionText.frame.height)
                    print(doneButton.frame.origin.y)
                    if (descriptionText.frame.origin.y + descriptionText.frame.height) >= doneButton.frame.origin.y {
                        let difference = (descriptionText.frame.origin.y + descriptionText.frame.height) - doneButton.frame.origin.y
                        constraint.constant += difference + 15
                    }
                }
            }
        }
        
        //descriptionText.text = ""
        
        // Do any additional setup after loading the view.
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
