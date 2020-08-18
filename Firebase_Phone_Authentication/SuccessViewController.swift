//
//  SuccessViewController.swift
//  FirebasePhoneAuth
//
//  Created by Danish Khan on 18/08/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit
import Lottie


class SuccessViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
           // 3. Set animation content mode
           
           animationView!.contentMode = .scaleAspectFit
           
           // 4. Set animation loop mode
           
        animationView!.loopMode = .playOnce
           
           // 5. Adjust animation speed
           
           animationView!.animationSpeed = 0.7
           
           view.addSubview(animationView!)
           
           // 6. Play animation
           
           animationView!.play()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.dismiss(animated: true) {
//                DispatchQueue.main.async {
//                    self.showHomeView()
//                }
//            }
//        }
 
    }
    
  private func showHomeView() {
         DispatchQueue.main.async {
             let storyBoard = UIStoryboard(name: "Main", bundle: nil)
             guard let homeViewController = storyBoard.instantiateViewController(withIdentifier:"HomeViewController") as? HomeViewController else { return }
             homeViewController.modalPresentationStyle = .fullScreen
             self.present(homeViewController, animated: true, completion: nil)
             
         }
         
     }

}
