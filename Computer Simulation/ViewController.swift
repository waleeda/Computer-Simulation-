//
//  ViewController.swift
//  Computer Simulation
//
//  Created by waleed azhar on 2016-12-17.
//  Copyright © 2016 waleed azhar. All rights reserved.
//

import UIKit
//represents an object under the force of gravity
class FallingBall {
    //relevent constants & variables
    private let g:Float = -9.8
    var y:Float = 0.0, v:Float = 0.0, t:Float = 0.0
    private var dt:Float = 0.1
    
    init(y0:Float, v0:Float, t0:Float, dt:Float) {
        self.y = y0
        self.v = v0
        self.t = t0
        self.dt = dt
        
    }
    //differetial equations for 1d force
    public func step(){
        y = y + v*dt
        v = v + g*dt
        t = t + dt
        
    }
    
    public func state() -> String {
        return "Y:\(y), V:\(v), T:\(t)"
    }
    
    
    
}

class SimpleHarmonicOscillator {
    //constants & prameters of force equation
    var k:Float = -1
    var damping: Float = 0.97
    var x:Float = 0.0, v:Float = 0.0, t:Float = 0.0
    var dt:Float = 0.16
    
    //set the initial state of the object
    init(k0:Float, x0:Float, v0:Float) {
        self.k = k0
        self.x = x0
        self.v = v0
        
    }
    //differential equation for a spring, calculate next x position
    public func step(){
        v = v + k*x
        v = v * damping
        x = x + v*dt
    }
    
    public func state() -> String {
        return "X:\(x), V:\(v), T:\(t)"
    }
    
    
    
}

//represents a simulation
class Simulation {
    
    var dl: CADisplayLink!
    
    //the force
    var spring = SimpleHarmonicOscillator(k0: -1,
                                          x0: 300,
                                          v0: 0)
    
    //the object under a forcce
    var view = UIView(frame: CGRect(x: 170,
                                    y: 250,
                                    width: 30,
                                    height: 30))
    init(backgroundView:UIView) {
        print("Simulation Started")
        view.backgroundColor = UIColor.red
        backgroundView.addSubview(self.view)
    }
    //start simulation by linking to screen refreshes
    func start() {
        dl = CADisplayLink(target: self, selector: #selector(self.tick(dl:)))
        dl.add(to: RunLoop.main, forMode: .commonModes)
        
    }
    
    func kick()  {
        spring.v += 500
    }
    //take the next step in the simulation
    @objc func tick(dl:CADisplayLink) {
        spring.dt = Float(dl.duration)
        spring.step()
        view.center.x = CGFloat(spring.x) + view.superview!.frame.midX
    }
    
    
}



class ViewController: UIViewController {
    
    var sim:Simulation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sim = Simulation(backgroundView: self.view)
        sim.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func kick(_ sender: UIButton) {
        sim.kick()
    }



}

