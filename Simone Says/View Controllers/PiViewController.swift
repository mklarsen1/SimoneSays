//
//  PiViewController.swift
//  Simone Says
//
//  Created by Matt Larsen on 5/6/21.
//

import UIKit
import CoreData

class PiViewController: UIViewController {

    @IBOutlet var simoneSaysButton: UIButton!
    
    @IBOutlet var readoutLabel: UILabel!
    
    @IBOutlet var oneButton: UIButton!
    @IBOutlet var twoButton: UIButton!
    @IBOutlet var threeButton: UIButton!
    @IBOutlet var fourButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    
    @IBOutlet var sixButton: UIButton!
    @IBOutlet var sevenButton: UIButton!
    @IBOutlet var eightButton: UIButton!
    @IBOutlet var nineButton: UIButton!
    @IBOutlet var zeroButton: UIButton!
    
    @IBOutlet weak var justGoButton: UIButton!
    @IBOutlet weak var rightNumbersView: UIStackView!
    
    @IBOutlet weak var scoreLabel: UILabel!

    
    var allButtons = [UIButton]()
    var goMode = false
    var piTimer = Timer()
    var labelRange: Int? = nil
    var cheatMode = false
    var currentPiString = "3.14"
    var userNumberString = ""
    var overflow = 0
    var maxScore = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(maxScore)"
        }
    }
    var listManagedObject : [NSManagedObject] = []
    var levelHighScore = 0
    var levelDate = Double(0)
    var levelTime = Float(0)

    //MARK:- View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHighScore()
        readoutLabel.adjustsFontSizeToFitWidth = false

        testDisplayLength()
        
        allButtons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton]
        
        addGestures()
        
        let slideTitle = UILabel()
        let slideTitleFontConstant = CGFloat(0.16)
        slideTitle.textAlignment = .center
        slideTitle.text = "CHALLENGE:\nDIGITS OF PI"
        slideTitle.numberOfLines = 0
        slideTitle.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        slideTitle.font = UIFont(name: "KidGames", size: 90)
        slideTitle.font = slideTitle.font.withSize(view.frame.height * slideTitleFontConstant)
        slideTitle.center = view.center
        slideTitle.backgroundColor = .black
        slideTitle.textColor = .white
        view.addSubview(slideTitle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.fromValue = 1.0
            fade.toValue = 0.0
            fade.duration = 1.5
            slideTitle.layer.add(fade, forKey: "alpha")
            slideTitle.alpha = 0.0
        }
        
    }
    
    func addGestures() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(cheatNoCheat))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        readoutLabel.isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(moveTenLeft))
        swipeLeft.direction = .left
        readoutLabel.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(moveTenRight))
        swipeRight.direction = .right
        readoutLabel.addGestureRecognizer(swipeRight)
    }
    
    @objc func moveTenLeft() {
        currentPiString = slicePi(0, currentPiString.count+10)
        if self.labelOverFlow() {
            overflow += 10
            self.readoutLabel.text = String(currentPiString.suffix(labelRange ?? 20))
        } else {
            self.readoutLabel.text = "\(self.slicePi(0,currentPiString.count))"
        }
    }
    
    @objc func moveTenRight() {
        currentPiString = slicePi(0, currentPiString.count-10)
        if self.labelOverFlow() {
            overflow -= 10
            self.readoutLabel.text = String(currentPiString.suffix(labelRange ?? 20))
        } else {
            self.readoutLabel.text = "\(self.slicePi(0,currentPiString.count))"
        }
    }
    
    @objc func cheatNoCheat() {
        cheatMode.toggle()
    }
    
    func testDisplayLength() {
        var piDigits = 1
        piTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            if !self.labelOverFlow() {
                self.view.isUserInteractionEnabled = false
                self.readoutLabel.text = "\(self.slicePi(0,piDigits))"
                piDigits += 1
            } else {
                self.setLabelRange(self.readoutLabel.text?.count ?? 20)
                self.view.isUserInteractionEnabled = true
                self.piTimer.invalidate()
                piDigits = 0
                self.cheatLight("3")
                self.animateNumber(4,0.25)
            }
        })
        
    }
    
    
    func animateNumber(_ num: Int, _ timeInterval: Double) {
        
        var piDigits = 1
        var subDigits = 0
        
        piTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            if piDigits <= num {
                // disable touches
                self.view.isUserInteractionEnabled = false
                // stop when the highest digit is reached
                // need another if statement here, determining if the size of the display can no longer hold the number
                if self.labelOverFlow() {
                    // how do I get the number of digits to subtract?
                    self.setLabelRange(self.readoutLabel.text?.count ?? 20)
                    print(self.labelRange)
                    subDigits += 1
                    self.readoutLabel.text = "\(self.slicePi(subDigits+1,piDigits))"
                } else {
                    self.readoutLabel.text = "\(self.slicePi(0,piDigits))"
                }
                piDigits += 1
            } else {
                self.view.isUserInteractionEnabled = true
                self.piTimer.invalidate()
                piDigits = 0
                self.cheatLight("3")
            }
        })
    }
    
    func labelOverFlow() -> Bool {
        let myText = readoutLabel.text! + "00"
        let fontAttributes = [NSAttributedString.Key.font: readoutLabel.font]
        let size = (myText as! NSString).size(withAttributes: fontAttributes).width
        let labelSize = readoutLabel.frame.size.width
        return size > labelSize
    }
    
    func slicePi(_ startingPoint: Int, _ finishPoint: Int) -> String {
        guard startingPoint < finishPoint else {
            print("Start is after finish, returning.")
            piTimer.invalidate()
            readoutLabel.text = "ERROR"
            userNumberString = ""
            currentPiString = "3.14"
            animateNumber(currentPiString.count, 0.25)
            return ""
        }
        
        let tenThousandPlacesOf = NumberWang()
        let pi = tenThousandPlacesOf.Pi
        
        print("start: \(startingPoint), end: \(finishPoint)")
        
        let start = pi.index(pi.startIndex, offsetBy: startingPoint)
        let end = pi.index(pi.startIndex, offsetBy: finishPoint)
        
        let range = start..<end
        let subPi = pi[range]
        return "\(subPi)"
    }
    
    //MARK:- Check number
    
    func checkNumber(_ numberString: String) {
        if userNumberString.count == 0 {
            // zero out display when the user starts guessing
            readoutLabel.text = " "
        }

        if numberString == "3" && userNumberString.count == 0 {
            userNumberString += numberString + "."
        } else {
            userNumberString += numberString
        }
        
        restoreNumberButtons()
        cheatLight(slicePi(userNumberString.count,userNumberString.count+1))

        // divide between goMode and standard
        if goMode {
            maxScore = currentPiString.count-1
            updateDisplay(currentPiString)                                    // print currentNumberString to display
            if currentPiString.suffix(1)==numberString {                      // does numberString match the end of currentPiString?
                if currentPiString.count == 1 {
                    currentPiString = slicePi(0, currentPiString.count+2)     // leapfrogging the decimal
                } else {
                    currentPiString = slicePi(0, currentPiString.count+1)
                }
            } else {
                // no
                readoutLabel.text = "RESETTING"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.readoutLabel.text = "START TYPING PI"
                    self.resetCurrentPiString()
                }
            }
            
            print(currentPiString)
        } else {
            if userNumberString.count < currentPiString.count {
                if userNumberString == slicePi(0, userNumberString.count) {
                    updateDisplay(userNumberString)
                    
                } else {
                    readoutLabel.text = "WRONG"
                    restoreNumberButtons()
                    userNumberString = ""
                    currentPiString = "3.14"
                    self.view.isUserInteractionEnabled = false
                    animateNumber(currentPiString.count, 0.25)
                }
            } else {
                if userNumberString == slicePi(0, userNumberString.count) {
                    readoutLabel.text = "CORRECT"
                    view.isUserInteractionEnabled = false
                    restoreNumberButtons()
                    userNumberString = ""
                    maxScore = currentPiString.count-1
                    currentPiString = slicePi(0, currentPiString.count+1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.animateNumber(self.currentPiString.count, 0.25)
                    }
                } else {
                    readoutLabel.text = "CLOSE BUT NO CIGAR"
                    userNumberString = ""
                    currentPiString = "3.14"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.animateNumber(4, 0.25)
                    }
                    
                }
            }
        }
    }
    
    fileprivate func updateDisplay(_ displayText: String) {
        if self.labelOverFlow() {
            self.setLabelRange(self.readoutLabel.text?.count ?? 20)
            
            let start = displayText.index(displayText.startIndex, offsetBy: displayText.count - labelRange!+1)
            let range = start..<displayText.endIndex
            self.readoutLabel.text = "\(displayText[range])" // only in the range of visible numbers
        } else {
            self.readoutLabel.text = "\(displayText)"
        }
    }
    
    
    func restoreNumberButtons() {
        for b in allButtons {
            b.setTitleColor(.white, for: .normal)
            b.backgroundColor = .black
        }
    }
    
    func cheatLight(_ digit: String) {
        guard cheatMode else { return }
        switch digit {
        case "0":
            zeroButton.setTitleColor(.black, for: .normal)
            zeroButton.backgroundColor = .white
        case "1":
            oneButton.setTitleColor(.black, for: .normal)
            oneButton.backgroundColor = .white
        case "2":
            twoButton.setTitleColor(.black, for: .normal)
            twoButton.backgroundColor = .white
        case "3":
            threeButton.setTitleColor(.black, for: .normal)
            threeButton.backgroundColor = .white
        case "4":
            fourButton.setTitleColor(.black, for: .normal)
            fourButton.backgroundColor = .white
        case "5":
            fiveButton.setTitleColor(.black, for: .normal)
            fiveButton.backgroundColor = .white
        case "6":
            sixButton.setTitleColor(.black, for: .normal)
            sixButton.backgroundColor = .white
        case "7":
            sevenButton.setTitleColor(.black, for: .normal)
            sevenButton.backgroundColor = .white
        case "8":
            eightButton.setTitleColor(.black, for: .normal)
            eightButton.backgroundColor = .white
        case "9":
            nineButton.setTitleColor(.black, for: .normal)
            nineButton.backgroundColor = .white
        default:
            print("default")
            
        }
        
    }
    
    func setLabelRange(_ stringCount: Int) {
        guard labelRange == nil else { return }
        labelRange = stringCount
    }
    
    @IBAction func didTapNumber(_ sender: UIButton) {
        HapticsManager.shared.vibrateForType(for: .success)
        checkNumber(sender.currentTitle!)
        
    }
    

    //MARK:- Buttons
    
    @IBAction func didTapSimoneSays(_ sender: UIButton) {
        if maxScore > levelHighScore {
            getInitialsAndDismiss()
        } else {
            piTimer.invalidate()
            dismiss(animated: true)
        }
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
            
            self.deleteMeByYourName()
            self.saveHighScore(time: 100.2, score: self.maxScore, date: Date().timeIntervalSince1970, initials: userString)

            self.piTimer.invalidate()
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
    
    @IBAction func didTapPlus(_ sender: UIButton) {
        currentPiString = slicePi(0, currentPiString.count+1)
        if self.labelOverFlow() {
            overflow += 1
            // how much is the label overflowing? Cut it off at that.
            self.readoutLabel.text = "\(self.slicePi(overflow+1,currentPiString.count))"
        } else {
            self.readoutLabel.text = "\(self.slicePi(0,currentPiString.count))"
        }
    }
    
    @IBAction func didTapMinus(_ sender: UIButton) {
        currentPiString = slicePi(0, currentPiString.count-1)
        if self.labelOverFlow() {
            overflow -= 1
            self.readoutLabel.text = "\(self.slicePi(overflow+1,currentPiString.count))"
        } else {
            self.readoutLabel.text = "\(self.slicePi(0,currentPiString.count))"
        }

    }
    
    fileprivate func resetCurrentPiString() {
        currentPiString = "3"
    }
    
    @IBAction func didTapJustGo(_ sender: UIButton) {
        goMode.toggle()
        if goMode {
            justGoButton.setTitle("LEARN PI", for: .normal)
            readoutLabel.text = "TEST YOUR PI"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.justGoButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                self.readoutLabel.text = "START TYPING ANY TIME"
                self.resetCurrentPiString()
            }
        } else {
            justGoButton.setTitle("GO MODE", for: .normal)
            justGoButton.setImage(UIImage(systemName: "playpause.fill"), for: .normal)
            userNumberString = ""
            readoutLabel.text = "3.14"
            currentPiString = "3.14"
        }
    }
    
    
    //MARK:- CORE DATA FUNCTIONS
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveHighScore(time: Float, score: Int, date: Double, initials: String) {
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "GameScores", in: managedContext)!
        let list = NSManagedObject(entity: entity, insertInto: managedContext)

        list.setValue("DIGITS OF PI", forKeyPath: "name")
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
    
    func getHighScore() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [GameScores]
        
        for item in resultData {
            if item.name == "DIGITS OF PI" {
                levelHighScore = Int(item.score)
                levelDate = item.date
                levelTime = item.time
            }
        }
        print("""
            high score: \(levelHighScore)
            date: \(levelDate)
            time: \(levelTime)
            """)
    }
    
    func deleteMeByYourName() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [GameScores]
        
        for item in resultData {
            if item.name == "DIGITS OF PI" {
                managedContext.delete(item)
            }
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Error in saving, here: \(error)")
        }
    }
    
}


class UILabelNonCompressible: UILabel
{
    private static let NonCompressibleInvisibleContent = " "

    override var intrinsicContentSize: CGSize
    {
        if /* zero-width */ text == nil ? true : text!.isEmpty
        {
            // prefer mirror-and-calculate over modify-calculate-restore due to KVO
            let doppelganger = createCopy()

            // calculate for any non-zero -height content
            doppelganger.text = UILabelNonCompressible.NonCompressibleInvisibleContent

            // override
            return doppelganger.intrinsicContentSize
        }
        else
        {
            return super.intrinsicContentSize
        }
    }
}

extension UILabel
{
    func createCopy() -> UILabel
    {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as! UILabel
    }
}
