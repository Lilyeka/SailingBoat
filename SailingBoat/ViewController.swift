//
//  ViewController.swift
//  SailingBoat
//
//  Created by Лилия Левина on 13/06/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var boat : UIImageView = {
        let boat = UIImageView(image: UIImage(named: "boat"))
        boat.frame = CGRect(x: 300, y: 30, width: 50, height: 50)
        return boat
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boat)
        simultaneouslyGroupedAnimations()
    }
    
    func  simultaneouslyGroupedAnimations() {
        //first animation, the movement of the boat along its curving path
        let h : CGFloat = 200
        let v : CGFloat = 75
        let path = CGMutablePath()
        var leftright: CGFloat = 1
        var next : CGPoint = self.boat.layer.position
        var pos : CGPoint
        path.move(to: CGPoint(x: next.x, y: next.y))
        for _ in 0 ..< 4 {
            pos = next
            leftright *= -1
            next = CGPoint(x:pos.x + h*leftright, y:pos.y + v)
            path.addCurve(to: CGPoint(x: next.x, y: next.y),
                          control1: CGPoint(x: pos.x, y: pos.y + 30),
                          control2: CGPoint(x: next.x, y: next.y - 30))
        }
        let anim1 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        anim1.path = path
        anim1.calculationMode = .paced
        
        //second animation, the reversal of the direction the boat is facing
        let revs = [0.0, .pi, 0.0, .pi]
        let anim2 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
        anim2.values = revs
        anim2.valueFunction = CAValueFunction(name: .rotateY)
        anim2.calculationMode = .discrete
        
        //third animation, the rocking of the boat. It has a short duration, and repeats indefinitely
        let pitches = [0.0, .pi/60.0, 0.0, -.pi/60, 0.0]
        let anim3 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        anim3.values = pitches
        anim3.repeatCount = .greatestFiniteMagnitude
        anim3.duration = 0.5
        anim3.isAdditive = true
        anim3.valueFunction = CAValueFunction(name: .rotateZ)
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2, anim3]
        group.duration = 8
        self.boat.layer.add(group, forKey: nil)
        CATransaction.setDisableActions(true)
        self.boat.layer.position = next
    }
}

