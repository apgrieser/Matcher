//
//  Tile.swift
//  Matcher
//
//  Created by Andrea Grieser on 8/1/19.
//  Copyright © 2019 Andrea Grieser. All rights reserved.
//

import UIKit

class Tile: UIButton {
    
    var backImage: String?
    var frontImage: String?
    var frontSideUp: Bool?
    var matched: Bool?
    
    required init(backImage: String, frontImage: String, frontSideUp: Bool) {
        
        //Initialize properties
        self.backImage = backImage
        self.frontImage = frontImage
        self.frontSideUp = frontSideUp
        self.matched = false
        
        //Initialize parent class
        super.init(frame: .zero)
        
    } //init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setBackImage() {
        //print("In setBackImage")
        guard let imageName = self.backImage else { return }
        
        if imageName != "" {
          //  print("Using back imageName \(imageName)")
            guard let image = UIImage(named: imageName) as UIImage? else { return }
            self.setImage(image, for: .normal)
            
        }
        
    } //setBackImage
    
    func setFrontImage() {
       // print("In setFrontImage")
        guard let imageName = self.frontImage else { return }
        
        if imageName != "" {
          //  print("Using front imageName \(imageName)")
            guard let image = UIImage(named: imageName) as UIImage? else { return }
            self.setImage(image, for: .normal)
            
        }
        
    } //setBackImage
    
    func toggleTile() {
        
        guard let tileMatched = matched else { return }
        
        //Only toggle if the tile hasn't already found its match
        if !tileMatched {
            
            guard let facingUp = self.frontSideUp else { return }
            
            if facingUp {
                //Tile is face up - turn face down
               // print("in toggleTile - facing up is \(facingUp)")
                //print("calling setBackImage")
                setBackImage()
                self.frontSideUp = false
                
            } else {
                //Tile is face down - turn face up
                //print("in toggleTile - facing up is \(facingUp)")
                //print("calling setBackImage")
                setFrontImage()
                self.frontSideUp = true
                
            } //facingUp
            
        } //!tileMatched
        
    } //toggleTile
    
    func matchTiles(tile1: Tile, tile2: Tile) {
        tile1.matched = true
        tile2.matched = true
        guard let imageFront = tile1.frontImage else { return }
        let tileImageToUse = "\(imageFront)Matched"
        guard let image = UIImage(named: tileImageToUse) as UIImage? else { return }
        tile1.setImage(image, for: .normal)
        tile2.setImage(image, for: .normal)
    }
    
} //Tile
