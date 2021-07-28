//
//  Check.swift
//  Charging
//
//  Created by haiphan on 27/07/2021.
//

import UIKit
import MediaPlayer

class Check: UIViewController {

    @IBOutlet weak var viewCheck: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        
//        guard let path = Bundle.main.path(forResource: "iphone8", ofType:"mp4"), let url = URL(string: path) else {
//            debugPrint("video.m4v not found")
//            return
//        }
//        
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
//        
//        let playerLayer = AVPlayerLayer(player: player)
//        self.view.layoutIfNeeded()
//        playerLayer.frame = self.viewCheck.bounds
//        self.viewCheck.layer.addSublayer(playerLayer)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            player.play()
//        }
        
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
