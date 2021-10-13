//
//  ViewController.swift
//  Simone Says
//
//  Created by Matt Larsen on 3/10/21.
//

import UIKit
import SpriteKit
import GameKit
import AVFoundation
import CoreData

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    enum player:String {
        case one
        case two
    }
    var activePlayer = player.one
    
    @IBOutlet var buttonView: UIView!
    @IBOutlet var multiButton: UIButton!
    
    @IBOutlet var amyButton: UIButton!
    @IBOutlet var megButton: UIButton!
    @IBOutlet var joButton: UIButton!
    @IBOutlet var bethButton: UIButton!
            
    var cheatLabel = UILabel()
    var playbackControl = UISlider()
    var scoreLabel = UILabel()
    var clockLabel = UILabel()
    var currentPlayerLabel = UILabel()
    var currentScore: Int = 0 {
        didSet {
            scoreLabel.attributedText = mutableLevelName()
        }
    }
    
    // TIME
    
    var currentTime: Double = 0 {
        didSet {
//            print("\(currentTime)")
//            scoreLabel.text = "SCORE: \(currentScore) IN \(currentTime)"
        }
    }
    var clockTimer = Timer()
    var playbackTimer = Timer()
    var startTime: TimeInterval = 0
    var finishTime: TimeInterval = 0
    var totalTime: Double = 0
    
    var levelStyle = simone.says.nothing
    
    // DATA
    
    var container: NSPersistentContainer!
    var listManagedObject : [NSManagedObject] = []
    var highScores = [String:[Any]]()
    
    var levelName = String()
    var levelHighScore = Int(0)
    var levelDate = Double(0)
    var levelTime = Float(0)
    
    // MARCH SISTERS
    
    var meg = MarchSister()
    var jo = MarchSister()
    var beth = MarchSister()
    var amy = MarchSister()
    
    var marchSisters = [MarchSister]()
    var marchSistersAutoArray = [MarchSister]()
    var userMarchSisters = [MarchSister]()
    
    var currentMarchSisterArray = [MarchSister]()
    var playerOneMarchSisters = [MarchSister]()
    var playerOneColor = UIColor()
    var playerTwoMarchSisters = [MarchSister]()
    var opposingSisters = [MarchSister]()
    var opposingPlayer = player.one
    var playerTwoColor = UIColor()
    var notListening = true
    var multiButtonRectangle = CGRect()
    var twoPlayerArraySize = 4
    
    var cheatString = String()
    var tornado = false
    var labelShift: CGFloat?
    var currentSister = 0
    var addNumberToArray = 1
    
    var sisterButtons: [UIButton] = []
    
    // SHAPES
    
    var wedge = ShapeHelper.wedge2()
    var originalWedge = ShapeHelper.wedge()
    var orange = ShapeHelper.orangeWedge()
    var boink = ShapeHelper.boink()
    var circle = ShapeHelper.circle()
    var centerCircle = ShapeHelper.circle()
    var flattenedCurve = ShapeHelper.flattenedCurve()
    var inwardCurve = ShapeHelper.inwardCurve()
    var smallWedge = ShapeHelper.smallWedge()
    var manyWedges = [ ShapeHelper.flattenedCurve(), ShapeHelper.smallWedge(),
        ShapeHelper.inwardCurve()]
    var eleph = ShapeHelper.elephant()
    
    var changeShape = UIBezierPath()
    
    // SOUNDS
    var soundPlayer = AVAudioPlayer()
    var instrument = String()
    let synthesizer = AVSpeechSynthesizer()
    
    var flashColor: CGColor?
    var playbackStack = UIStackView()
    let speedButton = UIButton()
    var playbackSpeed = 1.0 {
        didSet {
            speedButton.setTitle("REPLAY\n\(round(playbackSpeed*10)/10)X", for: .normal)
        }
    }
    var doNotPressThisButton = UIButton()
    
    // MULLIGANS
    
    var elephantButton = UIButton()
    var mulligans = [UIButton]()
    var mulliganStack = UIStackView()
    var currentMulligan: Int = 0
    let totalMulligans = 3
    var tempMulliganPattern = [MarchSister]()
    
    // COLORS
    
    let gold = UIColor(red: 1.00, green: 0.75, blue: 0.00, alpha: 1.00).cgColor
    let fontFace = UIFont(name: "KidGames", size: 20)
    let prussianBlue = UIColor(red: 0.01, green: 0.19, blue: 0.28, alpha: 1.00)
    let lightSkyBlue = UIColor(red: 0.52, green: 0.80, blue: 1.00, alpha: 1.00)
    
    let darkSienna = UIColor(red: 0.22, green: 0.02, blue: 0.09, alpha: 1.00)
    let babyPink = UIColor(red: 0.92, green: 0.76, blue: 0.76, alpha: 1.00)
    
    let bottleGreen = UIColor(red: 0.18, green: 0.42, blue: 0.31, alpha: 1.00)
    
    let gradientBG = UIView()
    
    let constantPatternNumber = NumberWang().fourPi
    
    //MARK: - End of declarations
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        levelName = String(levelStyle.rawValue.split(separator: "\n")[0])
        synthesizer.delegate = self
        setLevel()
        setCircle()
        setPlaybackControls()
        setScore()
        setClock()
        
//        saveData()
//        dataFunc()
//        deleteOld()
                
        getHighScore(name: levelName)
        
        sisterButtons = [amyButton, megButton, joButton, bethButton]
        adaline()
        
        buttonView.layer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        marchSisters = [meg, jo, amy, beth]

        if levelStyle == simone.says.multiPlayer || levelStyle == simone.says.patternTap {
            setCurrentPlayerLabel()
            twoPlayer()
        } else {
            singlePlayer()
        }
        
        setButtons()
        multiButton.frame = multiButtonRectangle
        multiButton.center = CGPoint(x: playbackStack.frame.midX, y: view.frame.height - multiButton.frame.height/2 - 20)
        multiButton.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2, leading: 30, bottom: 2, trailing: 30)
        multiButton.setTitle("HOME", for: .normal)
        multiButton.layer.cornerRadius = 20
        multiButton.backgroundColor = .yellow
        
        changeShape = smallWedge
        

        gradientBG.alpha = 1.0
        gradientBG.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.lightGray.cgColor,
            UIColor.darkGray.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = gradientBG.bounds
        gradientBG.layer.insertSublayer(gradient, at: 0)
        
        view.addSubview(gradientBG)
        gradientBG.layer.zPosition = -20
        gradientBG.isUserInteractionEnabled = false
        
    }

    
    func singlePlayer() {
        currentMarchSisterArray = marchSistersAutoArray
        addToRandomSisterArray()
        
        if !levelStyle.rawValue.contains("CHEAT") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                for sister in self.marchSisters {
                    sister.shape.fillColor = UIColor.clear.cgColor
                    sister.shape.lineWidth = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                for sister in self.marchSisters {
                    sister.shape.fillColor = sister.originalColor.cgColor
                    sister.shape.lineWidth = 2.0
                }
                self.playSequence(self.currentMarchSisterArray)
            }
        }
    }
    
    func twoPlayer() {
        currentPlayerLabel.text = "PLAYER \(activePlayer == player.one ? "ONE" : "TWO")"
        
        // increasing two player array size if both are successful at recalling their respective patterns
        if levelStyle == .patternTap && playerOneMarchSisters.count == playerTwoMarchSisters.count && playerOneMarchSisters.count != 4 {
            twoPlayerArraySize += 1
        }
        
        switch activePlayer {
        case player.one:
            currentMarchSisterArray = playerOneMarchSisters
            view.backgroundColor = lightSkyBlue
            
            if playerOneMarchSisters.count > 0 {
                currentPlayerLabel.text = currentPlayerLabel.text! + "\nREPLAYING..."
                playSequence(currentMarchSisterArray)
                notListening = true
            } else if levelStyle != .patternTap {
                notListening = false
                currentPlayerLabel.text = """
                PLAYER ONE
                TAP A SLICE
                TO ADD TO
                PLAYER TWO
                SEQUENCE
                """
            } else {
                
                notListening = false
                currentPlayerLabel.text = """
                PLAYER ONE
                TAP A
                PATTERN
                FOR PLAYER TWO
                """
            }
            
        case player.two:
            currentMarchSisterArray = playerTwoMarchSisters
            view.backgroundColor = babyPink
            
            if playerTwoMarchSisters.count > 0 {
                currentPlayerLabel.text = currentPlayerLabel.text! + "\nREPLAYING..."
                playSequence(currentMarchSisterArray)
                notListening = true
            } else if levelStyle != .patternTap {
                notListening = false
                currentPlayerLabel.text = """
                PLAYER TWO
                TAP A SLICE
                TO ADD TO
                PLAYER ONE
                SEQUENCE
                """
            } else {
                notListening = false
                currentPlayerLabel.text = """
                PLAYER TWO
                DO SOMETHING GRAND
                """
            }
        }
    }
    
    func authenticateUser() {
        let player = GKLocalPlayer.local
        
        player.authenticateHandler = { vc, error in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            if let vc = vc {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func openAchievements() {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .achievements
        
        present(vc, animated: true, completion: nil)
    }
    
    func makeCheatLabel() {
        cheatLabel.font = fontFace
        cheatLabel.sizeToFit()
        
        cheatLabel.center.y = view.center.y - requiredHeight(labelText: "ANY")
        cheatLabel.center.x = view.frame.minX + cheatLabel.frame.width / 2 + 30
        cheatLabel.numberOfLines = 0
        view.addSubview(cheatLabel)
    }
    
    func setPlaybackControls() {
        playbackStack = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width/4, height: 80))
        playbackStack.center = CGPoint(x: view.frame.maxX - playbackStack.frame.width/2 - 40, y: view.frame.height -  multiButtonRectangle.height - playbackStack.frame.height)
        playbackStack.axis = .horizontal
        playbackStack.distribution = .fillProportionally
        
        let turtleHareButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .default)
        
        let turtle = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        turtle.setImage(UIImage(systemName: "tortoise.fill", withConfiguration: turtleHareButtonConfig)?.withHorizontallyFlippedOrientation(), for: .normal)
        turtle.tintColor = .black
        turtle.addTarget(self, action: #selector(changeTurtle), for: .touchUpInside)
        
        let hare = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        hare.setImage(UIImage(systemName: "hare.fill", withConfiguration: turtleHareButtonConfig), for: .normal)
        hare.tintColor = .black
        hare.addTarget(self, action: #selector(changeRabbit), for: .touchUpInside)
        
        speedButton.setTitle("REPLAY\n\(playbackSpeed)X", for: .normal)
        speedButton.titleLabel?.textAlignment = .center
        speedButton.titleLabel?.numberOfLines = 0
        speedButton.titleLabel!.font = fontFace?.withSize(15 * view.frame.height/450)
        speedButton.setTitleColor(.black, for: .normal)
        speedButton.addTarget(self, action: #selector(pressPlayStart), for: .touchUpInside)
        
        playbackStack.addArrangedSubview(turtle)
        playbackStack.addArrangedSubview(speedButton)
        playbackStack.addArrangedSubview(hare)
        
        view.addSubview(playbackStack)
        
        doNotPressThisButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        // SQUISH
//        doNotPressThisButton.setTitle("SQUISH", for: .normal)
        doNotPressThisButton.setImage(UIImage(systemName: "puzzlepiece.fill"), for: .normal)
        doNotPressThisButton.addTarget(self, action: #selector(youPressedTheButton), for: .touchUpInside)
        doNotPressThisButton.center = CGPoint(x: playbackStack.center.x, y: playbackStack.center.y - playbackStack.frame.height/2 - 20)
        doNotPressThisButton.tintColor = .yellow
        
        view.addSubview(doNotPressThisButton)
    }
    
    @objc func changeRabbit() {
        guard playbackSpeed < 5 else { return }
        playbackSpeed += 0.1
    }
    
    @objc func changeTurtle() {
        guard playbackSpeed > 0.2 else { return }
        playbackSpeed -= 0.1
    }
    
    @objc func changePlaySpeed(_ sender:UISlider) {
        playbackSpeed = Double(sender.value)
    }

    @objc func youPressedTheButton() {
        changeShape = manyWedges.randomElement()!
    }
    
    func setScore() {
        scoreLabel.font = fontFace!.withSize(view.frame.height/450 * 15)
        scoreLabel.textAlignment = .center
        let scoreHeight = requiredHeight(labelText: "\n\n\n\n\n")
        scoreLabel.frame = CGRect(x: playbackStack.frame.minX, y: view.frame.minY + 40, width: playbackStack.frame.width, height: scoreHeight)
        scoreLabel.attributedText = mutableLevelName()
        scoreLabel.numberOfLines = 0
        
        view.addSubview(scoreLabel)
    }
    
    func mutableLevelName() -> NSMutableAttributedString {
        let mutableLevelString = NSMutableAttributedString(string: "\(levelName)\n\nSCORE: \(currentScore)")
        mutableLevelString.setColor(color: .black, forText: "\(levelName)")
        let levelRange = (mutableLevelString.string as NSString).range(of: "\(levelName)")
        mutableLevelString.setAttributes([NSAttributedString.Key.font:UIFont(name: "KidGames", size: 25 * view.frame.height/450)!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: levelRange)
        mutableLevelString.setColor(color: .yellow, forText: "SCORE: \(currentScore)")
        return mutableLevelString
    }
    
    func setCurrentPlayerLabel() {
        currentPlayerLabel.font = fontFace
        currentPlayerLabel.lineBreakMode = .byWordWrapping
        currentPlayerLabel.numberOfLines = 0
        currentPlayerLabel.textColor = .white
        currentPlayerLabel.frame = CGRect(x: 40, y: 0, width: view.frame.width/3, height: view.frame.height-40)
        currentPlayerLabel.text = "HIDDEN"
        view.addSubview(currentPlayerLabel)
        
    }
    
    func setClock() {
        clockTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.currentTime += 0.1
        })
    }
    
    func setButtons() {
        setButtonImage(megButton, meg.shape, meg.defaultRotation, meg.originalColor)
        setButtonImage(joButton, jo.shape, jo.defaultRotation, jo.originalColor)
        setButtonImage(bethButton, beth.shape, beth.defaultRotation, beth.originalColor)
        setButtonImage(amyButton, amy.shape, amy.defaultRotation, amy.originalColor)
        
        }
    
    @objc func pressPlayStart() {
        playSequence(currentMarchSisterArray)
    }
    
    //MARK: - Set Level
    
    func setLevel() {
        switch levelStyle {

        case .patternTap:
            setStandardColors()
        
        case .multiPlayer:
            setStandardColors()
//            authenticateUser()

        case .color:
            setStandardColors()
            setMulligans()
            
        case .colorBlind:
            setColorBlind()
            setMulligans()
            
        case .blind:
            setNoColors()
            setMulligans()
            
        case .colorCheat:
            makeCheatLabel()
            setStandardColors()
            
        case .liarsCheat:
            makeCheatLabel()
            setLiarsColors()
            
        case .colorBlindCheat:
            makeCheatLabel()
            setColorBlind()
            
        case .spokenWord:
            setStandardColors()
            setMulligans()
            
        case .brainTwist:
            setStandardColors()
            setMulligans()
            
        case .colorTornado:
            setStandardColors()
            setMulligans()
            tornado = true
            
        case .colorBlindTornado:
            setColorBlind()
            setMulligans()
            tornado = true
            
        case .constantPattern:
            setStandardColors()
            setMulligans()
            
        default:
            setNoColors()
        }
        
        let slideTitle = UILabel()
        let slideTitleFontConstant = CGFloat(0.16)
        slideTitle.text = "CHALLENGE: \(levelStyle.rawValue.split(separator: "\n")[0])"
        slideTitle.numberOfLines = 0
        slideTitle.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        slideTitle.font = UIFont(name: "KidGames", size: 90)
        slideTitle.font = slideTitle.font.withSize(view.frame.height * slideTitleFontConstant)
//        slideTitle.sizeToFit()
        slideTitle.center = view.center
        slideTitle.textAlignment = .center
        slideTitle.backgroundColor = .black
        
        slideTitle.textColor = .white
        view.addSubview(slideTitle)
        slideTitle.layer.zPosition = 15
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1.0
        fade.toValue = 0.0
        fade.duration = 1.5
        slideTitle.layer.add(fade, forKey: "alpha")
        slideTitle.alpha = 0.0
        }
    }
    
    func setLiarsColors() {
        // red, blue, yellow, green
        meg = MarchSister(name: "meg", shape: CAShapeLayer(), originalColor: UIColor.blue, colorName: "RED", defaultRotation: -Double.pi/2, sound: instrument + "A1")
        jo = MarchSister(name: "jo", shape: CAShapeLayer(), originalColor: UIColor.yellow, colorName: "BLUE", defaultRotation: 0, sound: instrument + "C2")
        beth = MarchSister(name: "beth", shape: CAShapeLayer(), originalColor: UIColor.green, colorName: "YELLOW", defaultRotation: Double.pi, sound: instrument + "A2")
        amy = MarchSister(name: "amy", shape: CAShapeLayer(), originalColor: UIColor.red, colorName: "GREEN", defaultRotation: Double.pi/2, sound: instrument + "E2")
        flashColor = UIColor.white.cgColor
    }
    
    func setStandardColors() {
        meg = MarchSister(name: "meg", shape: CAShapeLayer(), originalColor: UIColor.red, colorName: "RED", defaultRotation: -Double.pi/2, sound: instrument + "A1")
        jo = MarchSister(name: "jo", shape: CAShapeLayer(), originalColor: UIColor.blue, colorName: "BLUE", defaultRotation: 0, sound: instrument + "C2")
        beth = MarchSister(name: "beth", shape: CAShapeLayer(), originalColor: UIColor.yellow, colorName: "YELLOW", defaultRotation: Double.pi, sound: instrument + "A2")
        amy = MarchSister(name: "amy", shape: CAShapeLayer(), originalColor: UIColor.green, colorName: "GREEN", defaultRotation: Double.pi/2, sound: instrument + "E2")
        flashColor = UIColor.white.cgColor
    }
    
    func setColorBlind() {
        meg = MarchSister(name: "meg", shape: CAShapeLayer(), originalColor: UIColor.black, colorName: "BLACK", defaultRotation: -Double.pi/2, sound: instrument + "A1")
        jo = MarchSister(name: "jo", shape: CAShapeLayer(), originalColor: UIColor.darkGray, colorName: "DARK GRAY", defaultRotation: 0, sound: instrument + "C2")
        beth = MarchSister(name: "beth", shape: CAShapeLayer(), originalColor: UIColor.lightGray, colorName: "LIGHT GRAY", defaultRotation: Double.pi, sound: instrument + "A2")
        amy = MarchSister(name: "amy", shape: CAShapeLayer(), originalColor: UIColor.white, colorName: "WHITE", defaultRotation: Double.pi/2, sound: instrument + "E2")

        flashColor = gold
    }
    
    func setNoColors() {
        meg = MarchSister(name: "meg", shape: CAShapeLayer(), originalColor: UIColor.black, colorName: "BLACK", defaultRotation: -Double.pi/2, sound: instrument + "A1")
        jo = MarchSister(name: "jo", shape: CAShapeLayer(), originalColor: UIColor.black, colorName: "BLACK", defaultRotation: 0, sound: instrument + "C2")
        beth = MarchSister(name: "beth", shape: CAShapeLayer(), originalColor: UIColor.black, colorName: "BLACK", defaultRotation: Double.pi, sound: instrument + "A2")
        amy = MarchSister(name: "amy", shape: CAShapeLayer(), originalColor: UIColor.black, colorName: "BLACK", defaultRotation: Double.pi/2, sound: instrument + "E2")

        flashColor = gold
    }
    
    
    // MARK: - Play Sequence
    
    func playSequence(_ marchSisterArray: [MarchSister]) {
        let playerOneOrTwo = self.currentPlayerLabel.text?.components(separatedBy: "\n")[0]
        self.currentPlayerLabel.text = """
        \(playerOneOrTwo ?? "")
        REPLAYING...
        """
        
        replaySequenceOnly(marchSisterArray)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(marchSisterArray.count + 1)/playbackSpeed*2) {
            self.currentPlayerLabel.text = """
            \(playerOneOrTwo ?? "")
            REPEAT THE SEQUENCE...
            """
        }
    }
    
    func replaySequenceOnly(_ marchSisterArray: [MarchSister]) {
        self.view.isUserInteractionEnabled = false
        var playbackNumber = 0
        playbackTimer = Timer.scheduledTimer(withTimeInterval: Double(marchSisterArray.count)/(playbackSpeed*8), repeats: true) { [self] timer in
            if playbackNumber < marchSisterArray.count {
                let sister = marchSisterArray[playbackNumber]
                
                if levelStyle == .spokenWord {
                    // SAY IT
                    synthesizer.stopSpeaking(at: .immediate)
                    let spokenString = AVSpeechUtterance(string: sister.colorName)
                    synthesizer.speak(spokenString)
                } else {
                    self.changeButtonColor(self.playbackSpeed*2, sister)
                }
                self.soundPlayer.pause()
                 
                playbackNumber += 1
            } else {
                self.view.isUserInteractionEnabled = true
                playbackTimer.invalidate()
            }
        }
    }
    
    func adaline() {
        //  Converted to Swift 5.4 by Swiftify v5.4.24202 - https://swiftify.com/
        let xBezier = UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.frame.size.height*2, height: 1))
        let yBezier = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: view.frame.size.width*2))

        //shape layer for the line
        let yLine = CAShapeLayer()
        yLine.path = yBezier.cgPath
        yLine.fillColor = UIColor.red.cgColor
        yLine.frame = CGRect(x: view.frame.midX, y: 0, width: 1, height: view.frame.size.height*2)

        let xLine = CAShapeLayer()
        xLine.path = xBezier.cgPath
        xLine.fillColor = UIColor.red.cgColor
        xLine.frame = CGRect(x: 0, y: view.frame.midY, width: view.frame.size.width*2, height: 1)

        
        view.layer.addSublayer(yLine)
        view.layer.addSublayer(xLine)
        yLine.zPosition = 10
        xLine.zPosition = 10
    }
    
    func setCircle() {
//        circle.frame.size = CGSize(width: view.frame.width, height: view.frame.width)
        
        circle.transform = CATransform3DMakeScale(6, 6, 1)
        circle.position = CGPoint(x: view.frame.midX-(circle.path?.boundingBox.width)!*3, y: view.frame.midY-(circle.path?.boundingBox.height)!*3)

        circle.zPosition = -1
        view.layer.addSublayer(circle)
        
        centerCircle.position = CGPoint(x: view.frame.midX-(centerCircle.path?.boundingBox.width)!/2, y: view.frame.midY-(centerCircle.path?.boundingBox.height)!/2)
        centerCircle.zPosition = 3
        view.layer.addSublayer(centerCircle)
    }
    
    func setMulligans() {
        mulliganStack.frame = CGRect(x: 0, y: view.frame.height/12, width: view.frame.width/6, height: view.frame.height*5/6)
        mulliganStack.center.x = (view.frame.midX - 200)/2 + 40
        mulliganStack.axis = .vertical
        mulliganStack.distribution = .fillProportionally
        mulliganStack.alignment = .center
        for _ in 1...totalMulligans {
            
            let eButton = UIButton()
            eButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            let mulliganImage = UIImage(named: "light_bulb_reverse")!.withRenderingMode(.alwaysTemplate)
            
            eButton.setImage(mulliganImage, for: .normal)
            eButton.tintColor = .yellow
            eButton.contentMode = .redraw
            eButton.addTarget(self, action: #selector(hitElephant), for: .touchUpInside)
            mulligans.append(eButton)
            
            mulliganStack.addArrangedSubview(eButton)
//            mulligans.append(eButton)
//            mulliganStack.addArrangedSubview(makeAnElephant(eButton))
        }
        
        view.addSubview(mulliganStack)
    }
    
    func makeAnElephant(_ eleButton: UIButton) -> UIButton {
        eleButton.frame = CGRect(x: 0, y: 0, width: eleph.path!.boundingBox.width/8, height: eleph.path!.boundingBox.height/8)
        eleButton.layer.addSublayer(eleph)
        eleButton.addTarget(self, action: #selector(hitElephant), for: .touchUpInside)
        eleButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        return eleButton
    }
        
    @objc func hitElephant() {
        print(mulligans.count)
        if mulligans.count != 0 {
            mulligans.removeFirst()
            for (index, view) in mulliganStack.subviews.enumerated() {
                if index == currentMulligan {
                    view.tintColor = .darkGray
                }
            }
            currentMulligan += 1
            currentMarchSisterArray = tempMulliganPattern
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.playSequence(self.currentMarchSisterArray)
            }
        }
        
        // earned a replay
    }
    
    func setButtonImage(_ button: UIButton, _ shapeLayer: CAShapeLayer, _ rotation: Double, _ color: UIColor) {
        
        button.backgroundColor = UIColor.clear
        shapeLayer.path = wedge.cgPath
        
        let insets = CGFloat(0)
        shapeLayer.frame = button.bounds.inset(by: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
            
        shapeLayer.fillColor = color.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        button.layer.addSublayer(shapeLayer)
        
        var t = CGAffineTransform.identity
        t = t.rotated(by: CGFloat(rotation))
        t = t.scaledBy(x: 0.9, y: 0.9)
        button.transform = t
    }
    
    func rotateWheel() -> CAAnimation {
        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotate.values = [0.0, Double.pi, Double.pi*2]
        rotate.keyTimes = [0.0, 0.5, 1.0]
        rotate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        rotate.duration = 10
        rotate.repeatCount = .infinity
        rotate.autoreverses = false
        
        return rotate
    }

    func rotateWheelView() {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.buttonView.transform = self.buttonView.transform.rotated(by: CGFloat(Double.pi/2))
        }) { finished in
//            self.buttonView.transform = self.buttonView.transform.rotated(by: CGFloat(Double.pi))
        }
        buttonView.transform.rotated(by: CGFloat(Double.pi/2))
    }
    
    //MARK: - Sister Buttons
    //MARK: -
    
    @IBAction func didPressAmy(_ sender: UIButton) {
        HapticsManager.shared.vibrateForType(for: .warning)
        if notListening {
            recallSequence(amy)
        } else {
            twoPlayerAppend(amy)
        }
    }
    
    @IBAction func didPressMeg(_ sender: UIButton) {
        HapticsManager.shared.vibrateForType(for: .warning)
        if notListening {
            recallSequence(meg)
        } else {
            twoPlayerAppend(meg)
        }
    }
    
    @IBAction func didPressJo(_ sender: UIButton) {
        HapticsManager.shared.vibrateForType(for: .warning)
        if notListening {
            recallSequence(jo)
        } else {
            twoPlayerAppend(jo)
        }
    }
    
    @IBAction func didPressBeth(_ sender: UIButton) {
        HapticsManager.shared.vibrateForType(for: .warning)
        if notListening {
            recallSequence(beth)
        } else {
            twoPlayerAppend(beth)
        }
    }
    
    // button helper function: recall sequence
    
    func recallSequence(_ marchSister: MarchSister) {
//        HapticsManager.shared.customVibration()
        soundPlayer.stop()
        let url = Bundle.main.url(forResource: marchSister.sound, withExtension: "wav")
        soundPlayer = try! AVAudioPlayer(contentsOf: url!)
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        checkFail(marchSister)
        changeButtonColor(4.0, marchSister)
    }
    
    func twoPlayerAppend(_ marchSister: MarchSister) {
        HapticsManager.shared.customVibration()
        changeButtonColor(4.0, marchSister)
        
        let url = Bundle.main.url(forResource: marchSister.sound, withExtension: "wav")
        soundPlayer = try! AVAudioPlayer(contentsOf: url!)
        soundPlayer.prepareToPlay()
        soundPlayer.play()
        
        opposingPlayer = activePlayer == player.one ? player.two : player.one
        
        if levelStyle != .patternTap {
            activePlayer == player.one ? playerTwoMarchSisters.append(marchSister) : playerOneMarchSisters.append(marchSister)
            activePlayer = opposingPlayer
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.twoPlayer()
            }
        } else {
            if activePlayer == player.one {
                if playerTwoMarchSisters.count < twoPlayerArraySize-1 {
                    playerTwoMarchSisters.append(marchSister)
                } else {
                    playerTwoMarchSisters.append(marchSister)
                    activePlayer = opposingPlayer
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.twoPlayer()
                    }
                }
                // test the opposite player's array: is it the right size?
                // if not, add to it
                // if it is, switch players and start two player again
                // what happens if the two arrays are different lengths? can we use that as a test?
            } else if activePlayer == player.two {
                if playerOneMarchSisters.count < twoPlayerArraySize-1 {
                    playerOneMarchSisters.append(marchSister)
                } else {
                    playerOneMarchSisters.append(marchSister)
                    activePlayer = opposingPlayer
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.twoPlayer()
                    }
                }
            }
        }
    }
    
    func fadeIn(_ button: UIButton) {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        fade.duration = 0.5
        button.layer.add(fade, forKey: "alpha")
    }
    
    func changeButtonColor(_ speed: Double, _ shape: MarchSister) {
//        shape.shape.removeAllAnimations()
        let animationGroup = CAAnimationGroup()
        
        let colorChange = CABasicAnimation(keyPath: "fillColor")
        colorChange.fromValue = shape.originalColor.cgColor
        colorChange.toValue = flashColor
        colorChange.fillMode = CAMediaTimingFillMode.forwards
        
        // NEW SHAPE
        
        let newShapePath = changeShape.cgPath
        let shapeChange = CABasicAnimation(keyPath: "path")
        shapeChange.toValue = newShapePath
//        shapeChange.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        animationGroup.animations = [colorChange, shapeChange]
        animationGroup.duration = 1/speed
        shape.shape.add(animationGroup, forKey: nil)
        
//        shape.shape.add(shapeChange, forKey: "path")
//        shape.shape.add(colorChange, forKey: "fillColor")
    }
    
    func changeButtonShape(_ shape: MarchSister) {
        
        //        shape.shape.path
    }
    
    func explode() {
        let reveal = SKView()
        reveal.frame = view.frame
        reveal.backgroundColor = .clear
        reveal.layer.zPosition = -5
        view.addSubview(reveal)
        if levelStyle.rawValue.contains("CHEAT") {
            reveal.isUserInteractionEnabled = false
        }
        
        let scene = SKScene(size: view.frame.size)
        
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFit
        
        let emitter = SKEmitterNode(fileNamed: "fire.sks")
        emitter?.position = view.center
//        emitter?.zPosition = -20
        
        scene.addChild(emitter!)
        reveal.presentScene(scene)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            reveal.removeFromSuperview()
        }
    }
    
    func addToRandomSisterArray() {
        let allCheatStrings = NSMutableAttributedString()
        if levelStyle != .constantPattern {
            let randomSister = marchSisters.randomElement()
            currentMarchSisterArray.append(randomSister!)
        } else {
            // get current place in arrays
            let sisters = [amy ,jo, beth, meg]
            currentMarchSisterArray.append(sisters[constantPatternNumber[currentMarchSisterArray.count]%4])
            
        }
        
        let invisibleText:NSMutableAttributedString = NSMutableAttributedString(string:"LIGHT GRAY\n")
        invisibleText.setColor(color: UIColor.clear, forText: "LIGHT GRAY") // maximum string length
        allCheatStrings.append(invisibleText)
        
//        allCheatStrings.append()
        for i in 0..<currentMarchSisterArray.count {
            cheatString = "\(currentMarchSisterArray[i].colorName)\n"
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: cheatString)
            
            // color and lying color
            if levelStyle == simone.says.liarsCheat {
                // lying color
                // red blue green yellow
                attributedString.setColor(color: UIColor.blue, forText: "RED")
                attributedString.setColor(color: UIColor.yellow, forText: "BLUE")
                attributedString.setColor(color: UIColor.red, forText: "GREEN")
                attributedString.setColor(color: UIColor.green, forText: "YELLOW")
            } else {
                // color
                attributedString.setColor(color: UIColor.red, forText: "RED")
                attributedString.setColor(color: UIColor.blue, forText: "BLUE")
                attributedString.setColor(color: UIColor.green, forText: "GREEN")
                attributedString.setColor(color: UIColor.yellow, forText: "YELLOW")
            }
            
            
            // black and white
            attributedString.setColor(color: UIColor.black, forText: "BLACK")
            attributedString.setColor(color: UIColor.darkGray, forText: "DARK GRAY")
            attributedString.setColor(color: UIColor.lightGray, forText: "LIGHT GRAY")
            attributedString.setColor(color: UIColor.white, forText: "WHITE")
            
            allCheatStrings.append(attributedString)
        }
        
        cheatLabel.layer.shadowColor = UIColor.red.cgColor
        cheatLabel.layer.shadowOpacity = 0.75
        cheatLabel.layer.shadowRadius = 3.0
        cheatLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        cheatLabel.layer.masksToBounds = false
        
        cheatLabel.attributedText = allCheatStrings
        
        cheatLabel.frame = CGRect(x: 40, y: view.center.y - requiredHeight(labelText: "ANY"), width: cheatLabel.frame.width, height: cheatLabel.frame.height)
        cheatLabel.sizeToFit()
        if currentMarchSisterArray.count > 1 && labelShift == nil { labelShift = cheatLabel.frame.height }
    }
    
    func checkFail(_ sister: MarchSister) {
        if userMarchSisters.count == 0 {
            let date = Date()
            startTime = date.timeIntervalSince1970
        }
        userMarchSisters.append(sister)
        
        for i in 0..<userMarchSisters.count {
            if levelStyle == .brainTwist {
                if userMarchSisters[i].name == currentMarchSisterArray[i].name {
                    failureFunc()
                }
            } else {
                if userMarchSisters[i].name != currentMarchSisterArray[i].name {
                    failureFunc()
                }
            }
        }
        
        // RAISE THE TEXT! (IF ANY)
        cheatLabel.center.y -= requiredHeight(labelText: "ANY")

        if userMarchSisters.count == currentMarchSisterArray.count {
            // MADE IT TO THE END OF THE ARRAY
            
            currentScore = currentMarchSisterArray.count
            userMarchSisters = []
            explode()
            
            if levelStyle == .multiPlayer || levelStyle == .patternTap {
                // TWO PLAYER
                notListening = false
                currentPlayerLabel.text = """
                GREAT JOB!
                """
                
                if levelStyle == .multiPlayer {
                    let oppositeSequence = activePlayer == player.one ? playerTwoMarchSisters : playerOneMarchSisters
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.currentPlayerLabel.text = """
                        REPLAYING
                        \(self.activePlayer == player.one ? "PLAYER TWO" : "PLAYER ONE")
                        SEQUENCE
                        """
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.replaySequenceOnly(oppositeSequence)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 + Double(oppositeSequence.count)) {
                        
                        self.currentPlayerLabel.text = """
                    \(self.activePlayer == player.one ? "PLAYER ONE" : "PLAYER TWO")
                    TAP A SLICE TO
                    ADD THE NEXT
                    SLICE TO
                    \(self.activePlayer == player.one ? "PLAYER TWO" : "PLAYER ONE")'S
                    SEQUENCE
                    """
                    }
                } else if levelStyle == .patternTap {
                    // need to increase the size of the array if successful
                    playerOneMarchSisters = []
                    playerTwoMarchSisters = []
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.currentPlayerLabel.text = """
                    \(self.activePlayer == player.one ? "PLAYER ONE" : "PLAYER TWO")
                    TAP A NEW
                    SEQUENCE
                    FOR
                    \(self.activePlayer == player.one ? "PLAYER TWO" : "PLAYER ONE")
                    """
                    }

                }
                
            } else {
                // ONE PLAYER
                addToRandomSisterArray()
                if tornado {
                    rotateWheelView()
                }
                // smooth view color change, fade back to normal
                if !levelStyle.rawValue.contains("CHEAT") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.playSequence(self.currentMarchSisterArray)
                    }
                }
            }
        }
    }
    
    func failureFunc() {
        // FAILURE!
        gradientBG.alpha = 0.0
        view.backgroundColor = .red
        clockTimer.invalidate()
        setClock()
        let date = Date()
        finishTime = date.timeIntervalSince1970  // get the end time of the array
        totalTime = finishTime - startTime
        finishTime = 0
        userMarchSisters = []
        
        if levelStyle == .multiPlayer || levelStyle == .patternTap {
            
            // TWO PLAYER
            currentPlayerLabel.text = activePlayer == player.one ? "PLAYER TWO WINS!" : "PLAYER ONE WINS!"
            playerOneMarchSisters = []
            playerTwoMarchSisters = []
            activePlayer = player.one
            twoPlayerArraySize = 4
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.twoPlayer()
            }
            
        } else {
            
            // ONE PLAYER
            tempMulliganPattern = currentMarchSisterArray
            currentMarchSisterArray = []
            addToRandomSisterArray()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.backgroundColor = .lightGray
                self.gradientBG.alpha = 1.0
                if !self.levelStyle.rawValue.contains("CHEAT") {
                    self.playSequence(self.currentMarchSisterArray)
                }
            }
        }
    }
    
    
    func requiredHeight(labelText:String) -> CGFloat {

        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: .max))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = fontFace
        label.text = labelText
        label.sizeToFit()
        return label.frame.height

    }
    
    func getInitialsAndDismiss() {
        var userString = "* * *"
        var textField = UITextField()
        let alert = UIAlertController(title: "New high score. \nCongratulations!", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let initials = UIAlertAction(title: "Done", style: .default) { (action) in
            if let text = textField.text {
                userString = text
            }
            
            self.deleteMeByYourName(self.levelName)
            
            
            // quitting early means finish time has no end; ending now
            if self.finishTime==0 {
                let date = Date()
                self.finishTime = date.timeIntervalSince1970
                self.totalTime = self.finishTime - self.startTime
            }
            
            
            self.saveHighScore(name: self.levelName, time: Float(self.totalTime), score: self.currentScore, date: Date().timeIntervalSince1970, initials: userString)

            self.playbackTimer.invalidate()
            self.clockTimer.invalidate()
            self.dismiss(animated: true)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter your name or initials"
            textField = alertTextField
        }
        
        alert.addAction(initials)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        }
    
    @IBAction func didTapSimoneSays(_ sender: UIButton) {
        
        // Adding logic to the dismissal!
        if currentScore > levelHighScore {
            getInitialsAndDismiss()
        } else {
            playbackTimer.invalidate()
            clockTimer.invalidate()
            dismiss(animated: true)
        }
    }
    
    //MARK: - DATA
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "GameScores", in: managedContext)!
        let list = NSManagedObject(entity: entity, insertInto: managedContext)
        
        list.setValue("testName", forKeyPath: "name")
        
        list.setValue(1234.5, forKeyPath: "date")
        list.setValue(10, forKeyPath: "score")
        list.setValue(100.2, forKeyPath: "time")
        
        do {
            listManagedObject.append(list)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteOld() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [GameScores]
        
        let mostRecentSortedResultDate = resultData.sorted(by: { $0.date > $1.date })[0]
        print(mostRecentSortedResultDate.name)
        
        for item in resultData {
            if item.date != mostRecentSortedResultDate.date {
                print("BENITO")
                managedContext.delete(item)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save due to error, \(error)")
        }
        
    }
    
    func deleteMeByYourName(_ yourName: String) {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [GameScores]
        
        for item in resultData {
            if item.name == yourName {
                managedContext.delete(item)
            }
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Error in saving, here: \(error)")
        }
    }
    
    func dataFunc() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        do {
            listManagedObject = try managedContext.fetch(fetchRequest)
            for i in listManagedObject {
                if let decodedName = i.value(forKey: "name"), let decodedDate = i.value(forKey: "date"), let decodedScore = i.value(forKey: "score"), let decodedTime = i.value(forKey: "time") {
                    print("""
                        \(decodedName)
                        \(decodedDate)
                        \(decodedScore)
                        \(decodedTime)
                        """)
                }
            }
        } catch let error as NSError {
            print("Could not fetch due to \(error), \(error.userInfo)")
        }
        
    }
    
    func saveHighScore(name: String, time: Float, score: Int, date: Double, initials: String) {
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "GameScores", in: managedContext)!
        let list = NSManagedObject(entity: entity, insertInto: managedContext)

        list.setValue(name, forKeyPath: "name")
        // TIME IS NOW
        list.setValue(time, forKeyPath: "time")
        list.setValue(score, forKeyPath: "score")
        list.setValue(date, forKeyPath: "date")
        list.setValue(initials, forKeyPath: "initials")
        
        do {
            listManagedObject.append(list)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch due to \(error), \(error.userInfo)")
        }
    }
    
    func getHighScore(name: String) {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [GameScores]
        
        for item in resultData {
            if item.name == name {
                levelHighScore = Int(item.score)
                levelDate = item.date
                levelTime = item.time
            }
        }
    }
        
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

extension ViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
