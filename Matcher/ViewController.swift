//
//  ViewController.swift
//  Matcher
//
//  Created by Andrea Grieser on 7/24/19.
//  Copyright © 2019 Andrea Grieser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tilesView: UIView!
    var tilesArray = [Tile]()
    var numTilesFaceUp = 0
    var prevTileSelected: Tile!
    
    //This version allows 8 maximum pairs (16 tiles)
    let maxNumPairs = 8
    
    var matchesLabel: UILabel!
    var matchesMade = 0 {
        didSet {
            matchesLabel.text = "Matches:  \(matchesMade)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play Again", style: .plain, target: self, action: #selector(restartGame))
        
        
    } //viewDidLoad
    
    override func loadView() {
        view = UIView()
        //view.backgroundColor = .white
        view.backgroundColor = .lightGray
        
        //Add the matches label to the view
        matchesLabel = UILabel()
        matchesLabel.translatesAutoresizingMaskIntoConstraints = false
        matchesLabel.textAlignment = .left
        //matchesLabel.text = "Matches:  0"
        view.addSubview(matchesLabel)
        //Initialize text
        matchesMade = 0
        
        tilesView = UIView()
        drawBoard(tilesView)

    } //loadView

    func drawBoard(_ tilesView: UIView) {
        
        matchesMade = 0
        
        //Create the tile array
        let numPairs = maxNumPairs
        
        for tileNumber in 0..<numPairs {
            //Add two since we need matching pairs
            for _ in 0...1 {
                let tile = Tile(backImage: "TileBack", frontImage: "TileFront\(tileNumber + 1)", frontSideUp: true)
                tile.toggleTile()
                tilesArray.append(tile)
            } //create pair
        } //tileArray creation
        
        //Mix up the order
        tilesArray.shuffle()
        
        //print("tilesArray: \(String(describing: tilesArray[0].frontImage)), \(String(describing: tilesArray[1].frontImage))")
        
        //Create view with the tiles
        tilesView.translatesAutoresizingMaskIntoConstraints = false
        //tilesView.layer.borderWidth = 1
        tilesView.layer.borderWidth = 0
        tilesView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(tilesView)
        
        NSLayoutConstraint.activate([
            tilesView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, constant: 20),
            //height anchor constraints cause a crash?
            //tilesView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, constant: -20),
            //tilesView.heightAnchor.constraint(equalToConstant: 100),
            tilesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tilesView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            //Using constant 0 seems to put it right at the bottom edge
            //tilesView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0)
            tilesView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200),
            matchesLabel.topAnchor.constraint(equalTo: tilesView.bottomAnchor),
            matchesLabel.leadingAnchor.constraint(equalTo: tilesView.layoutMarginsGuide.leadingAnchor)
            ])
        
        let viewWidth = UIScreen.main.bounds.width - 40
        print("viewWidth = \(viewWidth)")
        let viewHeight = UIScreen.main.bounds.height - 40
        print("viewHeight = \(viewHeight)")
        
        let numPerRow = CGFloat(4.0)
        //let numPerColumn = CGFloat(4.0)
        
        //let width = 90
        //let height = 90
        let width = Int(viewWidth / numPerRow)
        let height = width
        //let height = Int(viewHeight / numPerColumn)
        print("width = \(width), height = \(height)")
        
        var colSpacer = 0
        var rowSpacer = 0
        var tileToAdd: Tile
        var tileIndex = 0
        
       
        for row in 0...3 {
            for column in 0...3 {
               
                tileToAdd = tilesArray[tileIndex]
                colSpacer = column * 5
                rowSpacer = row * 5
                print("Column = \(column), colSpacer = \(colSpacer), Row = \(row), rowSpacer = \(rowSpacer)")
                let frame = CGRect(x: (column * width) + colSpacer, y: (row * height) + rowSpacer, width: width, height: height)
                print("Frame:  x=\(frame.minX), y=\(frame.minY)")
                tileToAdd.frame = frame
                tileToAdd.addTarget(self, action: #selector(tileTapped), for: .touchUpInside)
                
                tilesView.addSubview(tileToAdd)
               
                tileIndex += 1
            }//for column
        } //for row
        
        //tilesView.subviews.shuffle()
        
    } //drawBoard

    @objc func restartGame() {
        print("In restartGame")
        tilesArray.removeAll()
        tilesView.removeFromSuperview()
        tilesView = UIView()
        drawBoard(tilesView)
        
    } //restartGame
    
    @objc func tileTapped(_ sender: UIButton) {
        print("In tileTapped")
        
        //How long (in seconds) to wait when showing two unmatched tiles
        //let delayTime = 1
        
        guard let tile = sender as? Tile else { return }
        guard let alreadyMatched = tile.matched else { return }
        if !alreadyMatched {
            tile.toggleTile()
            guard let faceUp = tile.frontSideUp else { return }
        
            print("faceUp = \(faceUp)")
            if faceUp   {
                //Tile was turned from face down to face up
                numTilesFaceUp += 1
                print("numTilesFaceUp = \(numTilesFaceUp)")
                if numTilesFaceUp <= 2 {
                    //One or two tiles are face up
                    //numTilesFaceUp += 1
                    if numTilesFaceUp == 2 {
                        //Figure out if we have a match
                        if tile.frontImage == prevTileSelected.frontImage {
                            //We have a match
                            matchesMade += 1
                            //Set the tiles to their matched state and color
                            tile.matchTiles(tile1: tile, tile2: prevTileSelected)
                            //Reset numTilesFaceUp
                            numTilesFaceUp = 0
                        
                            guard let currentText = matchesLabel.text else { return }
                        
                            if matchesMade == maxNumPairs {
                                matchesLabel.text = "\(currentText) - YOU WIN!!"
                            }
                        } else {
                            //Wait a few seconds, then turn selected tiles face down
                            //let delay = 2 * Double(NSEC_PER_SEC)
                            //var time:  dispatch_time_t = dispatch_time(dispatch_time_t(DispatchTime.now()), Int64(delay))
                            //dispatch_after(time, dispatch_ge)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                tile.toggleTile()
                                self.prevTileSelected.toggleTile()
                                self.numTilesFaceUp -= 2
                            }
                        } //no match
                    
                    } else {
                        //Only 1 tile - remember it
                        //if let frontImage = tile.frontImage { prevTileFront = frontImage } else {prevTileFront = "" }
                        prevTileSelected = tile
                        // prevTileSelected = Tile(backImage: tile.backImage!, frontImage: tile.frontImage!, frontSideUp: tile.frontSideUp!)
                    }
                } else {
                    //Too many face up tiles; put this one back face down
                    print("Too many face up; calling toggleTile")
                    tile.toggleTile()
                    numTilesFaceUp -= 1
                    print("numTilesFaceUp = \(numTilesFaceUp)")
                }
            } else {
                // Card is face down.  Decrement number of face up (?)
                if numTilesFaceUp > 0 {
                    numTilesFaceUp -= 1
                }
            } //tile was face down
        }
    } //tile not already matched
    
    
} //viewDidLoad

