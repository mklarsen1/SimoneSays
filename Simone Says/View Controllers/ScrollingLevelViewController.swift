//
//  ScrollingLevelViewController.swift
//  Simone Says
//
//  Created by Matt Larsen on 5/11/21.
//

import UIKit
import AVFoundation
import CoreData
import WebKit


class ScrollingLevelViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    var levelStyle = simone.says.nothing
    var slide = UIView()
    var multiButtonRectangle = CGRect()
    var soundButtonRectangle = CGRect()
    @IBOutlet var soundButton: UIButton!
    var instrument = "Harp"
    var soundPlayer = AVAudioPlayer()
    
    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    let titles: [String] = simone.says.allCases.map { $0.rawValue }
    var highScores = [String:[Any]]()
    var container: NSPersistentContainer!
    var colorGameImageCollection = [UIImage]()
    var animatedImage = UIImage()
    
    var colorStaticGameImageCollection = [UIImage]()
    var colorAnimatedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoFade()
        setHighScores()
        loadStaticSimone()
        
//        print(highScores)

        self.scrollView.delegate = self
        setScrollView()
        
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count-1), height: scrollHeight)
        scrollView.contentSize.height = 1.0
        
        pageControl.numberOfPages = titles.count-1
        pageControl.currentPage = 0
        
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(changeSound))
//        swipeUp.direction = .up
//        view.addGestureRecognizer(swipeUp)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        setHighScores()
        setScrollView()
    }
    
    func setScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width*0.9, height: view.frame.height*0.9)
        scrollView.center = view.center
        pageControl.frame.size.width = view.frame.width/2
        pageControl.center.x = view.center.x
        
        // call viewDidLayoutSubviews to get dynamic width and height of scroll view
        self.view.layoutIfNeeded()
                
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        view.backgroundColor = .systemGray5
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for i in 0..<titles.count-1 {
            frame.origin.x = scrollWidth * CGFloat(i)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            slide = UIView(frame: frame)
            slide.layer.cornerRadius = 25
            slide.applyGradient()
            
            if i==titles.count-2 {
//            if i==0 {
                
                slide.layer.cornerRadius = 0
                slide.applyGradient(UIColor.white.cgColor, UIColor.white.cgColor)
                
                
                // let logoImageURL = NSURL(fileURLWithPath: "\(Bundle.main.bundlePath)/PDF_HeaderImage.png")
                // webView.loadHTMLString("<img src=\"myImg.jpg\">", baseURL: Bundle.main.bundleURL)
                
                let webView = WKWebView()
                webView.frame = CGRect(x: 0, y: 0, width: slide.frame.width, height: slide.frame.height)
                webView.navigationDelegate = self
                
                let url = URL(string: "https://www.hackingwithswift.com")!
//                let url2 = Bundle.main.url(forResource: "index", withExtension: "html")!
                
                //  Converted to Swift 5.5 by Swiftify v5.5.22923 - https://swiftify.com/
                let mainBundle = Bundle.main
                let homeIndexUrl = mainBundle.url(forResource: "info_folder/index", withExtension: "html")

                // The magic is loading a request, *not* using loadHTMLString:baseURL:
                var urlReq: URLRequest? = nil
                if let homeIndexUrl = homeIndexUrl {
                    print("creating URL Request")
                    urlReq = URLRequest(url: homeIndexUrl)
                }
                if let urlReq = urlReq {
                    print("loading webView")
                    webView.load(urlReq)
                }
                
//                webView.loadHTMLString(html as! String, baseURL: Bundle.main.bundleURL)
                
//                webView.load(URLRequest(url: url2))
                webView.allowsBackForwardNavigationGestures = true
                /*
                // LITTLE WOMEN
                let infoTextView = UITextView()
                infoTextView.isEditable = false
                
                infoTextView.frame = CGRect(x: 0, y: 0, width: slide.frame.width, height: slide.frame.height)
                infoTextView.textContainer.lineBreakMode = .byWordWrapping
                infoTextView.layer.cornerRadius = 25
                                
                let filepath = Bundle.main.path(forResource: "info", ofType: "txt")!
                do {
                    let contents = try String(contentsOfFile: filepath)
                    
                    let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.center
                    
                    let attributedString = NSMutableAttributedString(string: contents, attributes:  [NSAttributedString.Key.paragraphStyle : paragraphStyle])
                    
                    let lightbulbTextAttachment = NSTextAttachment()
                    lightbulbTextAttachment.image = UIImage(named: "light_bulb_reverse")
                    let attributedStringWithImage = NSAttributedString(attachment: lightbulbTextAttachment)
                    
                    let rabbitTextAttachment = NSTextAttachment()
                    rabbitTextAttachment.image = UIImage(systemName: "hare.fill")
                    let rabbitStringWithImage = NSAttributedString(attachment: rabbitTextAttachment)
                    
                    if let nsRange = contents.range(of: "<<LIGHTBULB>>")?.nsRange(in: contents), let nsRange1 = contents.range(of: "<<RABBIT>>")?.nsRange(in: contents) {
                        
                        (contents as NSString).substring(with: nsRange)
                        attributedString.replaceCharacters(in: nsRange, with: attributedStringWithImage)
                        
                        (contents as NSString).substring(with: nsRange1)
                        attributedString.replaceCharacters(in: nsRange1, with: rabbitStringWithImage)

                    }
                    
                    infoTextView.attributedText = attributedString
                    
                } catch {
                    print("smaller women")
                }

                infoTextView.textColor = .black
                slide.addSubview(infoTextView)
                */
                slide.addSubview(webView)
                scrollView.addSubview(slide)
                
                
            } else {
                let frameTitle = titles[i].components(separatedBy: "\n\n")[0]
                
                let slideTitle = UILabel()
                slideTitle.text = frameTitle
                slideTitle.numberOfLines = 0
                slideTitle.frame = CGRect(x: view.frame.minX, y: 0, width: slide.frame.width, height: 50)
                slideTitle.font = UIFont(name: "KidGames", size: 30)
                slideTitle.textAlignment = .center
                
                slideTitle.textColor = .white
                
                let slideSub = UILabel()
                slideSub.text = "CHALLENGE \(i+1) OF \(titles.count-1)"
                slideSub.frame = CGRect(x: view.frame.minX, y: slideTitle.frame.maxY+5, width: slide.frame.width, height: 30)
                slideSub.font = UIFont(name: "KidGames", size: 24)
                slideSub.textAlignment = .center
                slideSub.backgroundColor = .red
                
                let slideMainText = UILabel()
                slideMainText.text = titles[i].components(separatedBy: "\n\n")[1]
                
                slideMainText.numberOfLines = 0
                slideMainText.frame = CGRect(x: view.frame.minX+20, y: slideSub.frame.maxY + 20, width: (slide.frame.width*2/3)-40, height: slide.frame.height/2)
                slideMainText.textAlignment = .left
                slideMainText.font = UIFont(name: "GillSans", size: 20)
                slideMainText.sizeToFit()
                slideMainText.textColor = .white
                
                let slideButtonWidth = scrollView.frame.width/4
                let slideButtonHeight = scrollView.frame.height/6
                multiButtonRectangle = CGRect(x: 0, y: 0, width: slideButtonWidth, height: slideButtonHeight)
                
                let slideButton = UIButton(frame: multiButtonRectangle)
                slideButton.titleLabel?.font = UIFont(name: "KidGames", size: 30)
                slideButton.center = CGPoint(x: (7*scrollView.frame.width/8)-10, y: (11*scrollView.frame.height/12)-10)
                slideButton.setTitle("GO", for: .normal)
                slideButton.accessibilityIdentifier = titles[i].components(separatedBy: "\n\n")[0]
                slideButton.layer.cornerRadius = 20
                slideButton.backgroundColor = .yellow
                slideButton.setTitleColor(.black, for: .normal)
                slideButton.addTarget(self, action: #selector(goToView(sender:)), for: .touchUpInside)
                
                let slideHighScore = UILabel()
                slideHighScore.numberOfLines = 0
                slideHighScore.frame = CGRect(x: view.frame.maxX, y: view.frame.midY, width: 200, height: slide.frame.height/2)
                slideHighScore.font = UIFont(name: "GillSans", size: 20)
                slideHighScore.textAlignment = .right
                slideHighScore.textColor = .white
                
                // get high scores and dates for each data type if they exist; otherwise, zero
                let dateFromArray = highScores[frameTitle]?[2]
                let date = Date(timeIntervalSince1970: dateFromArray as! TimeInterval)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy"
                var strDate = dateFormatter.string(from: date)
                if strDate == "31 Dec 1969" {
                    strDate = "  -  "
                }
                
                let t = highScores[frameTitle]?[1]
                let time = t as! Float
                let timeText = time > 0 ? "\nin \(round(time)*100/100) seconds" : ""
                let timeOptional = slideTitle.text!.contains("CHEAT") ? "\(timeText)" : ""
                
                let initials = highScores[frameTitle]?[3]
                // still need to mark start and end of sequence
                
                slideHighScore.text = """
                High Score: \(highScores[frameTitle]![0])\(timeOptional)
                \(strDate)
                \(initials!)
                """
                
                slideHighScore.sizeToFit()
                //
                slideHighScore.frame = CGRect(x: 0, y: slideSub.frame.maxY + 20, width: slide.frame.width/3-40, height: slideHighScore.frame.height)
                //            slideHighScore.backgroundColor = .red
                
                slideHighScore.center = CGPoint(x: slide.frame.width*5/6, y: slideHighScore.frame.midY)
                
                soundButtonRectangle = CGRect(x: 0, y: 0, width: slideButtonWidth, height: slideButtonHeight)
                soundButton = UIButton(frame: soundButtonRectangle)
                soundButton.setImage(UIImage(systemName: "music.note")?.withRenderingMode(.alwaysTemplate), for: .normal)
                soundButton.tintColor = .black
                soundButton.titleLabel?.font = UIFont(name: "KidGames", size: 20)
                soundButton.setTitle(" HARP", for: .normal)
                soundButton.layer.cornerRadius = 20
                soundButton.center = CGPoint(x: scrollView.frame.width/8+10, y: slideButton.center.y)
                soundButton.addTarget(self, action: #selector(changeSound), for: .touchUpInside)
                soundButton.backgroundColor = .green
                soundButton.setTitleColor(.black, for: .normal)
                soundButton.tag = 42
                
                
                let animatedImageView = UIImageView(image: getAnimatedSlideBG(frameTitle))
//                UIImageView(image: colorAnimatedImage)
                animatedImageView.center = CGPoint(x: view.center.x-20, y: view.center.y)
                animatedImageView.alpha = 0.3
                
                let infoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                infoButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
                infoButton.imageView?.contentMode = .scaleAspectFit
                infoButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
                infoButton.tintColor = .black
                infoButton.layer.cornerRadius = 20
                infoButton.center = CGPoint(x: scrollView.layer.frame.maxX - 80, y: scrollView.layer.frame.maxY - slideButton.layer.frame.height - 60)
                infoButton.addAction {
                    //  let bottomOffset = CGPoint(x: 0, y: infoTextView.contentSize.height - infoTextView.bounds.size.height)
                    print("ACTION!")
                    self.scrollView.setContentOffset(CGPoint(x: frame.maxX - self.scrollView.layer.frame.width, y: 0), animated: true)
                }
                infoButton.backgroundColor = .white
                infoButton.alpha = 0.5
                infoButton.setTitleColor(.black, for: .normal)
                
                slide.addSubview(infoButton)
                slide.addSubview(animatedImageView)
                slide.addSubview(slideButton)
                slide.addSubview(slideMainText)
                slide.addSubview(slideHighScore)
                slide.addSubview(slideSub)
                slide.addSubview(slideTitle)
                if slideTitle.text! != "DIGITS OF PI" {
                    slide.addSubview(soundButton)
                }
                scrollView.addSubview(slide)
            }
        }
        
        // create webView
        
    }
    
    func getAnimatedSlideBG(_ title: String) -> UIImage {
        switch title {
        case "ORIGINAL":
            var colorImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "color1-\(i)")!
                colorImageCollection.append(newImage)
            }
            let colorStaticAnimatedImage = UIImage.animatedImage(with: colorImageCollection, duration: 5)!
            return colorStaticAnimatedImage
            
        case "COLORBLIND":

            var colorblindImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = monochromeImage(UIImage(named: "color1-\(i)")!)
                
                colorblindImageCollection.append(newImage)
            }
            let colorblindStaticAnimatedImage = UIImage.animatedImage(with: colorblindImageCollection, duration: 5)!
            return colorblindStaticAnimatedImage

        case "BLIND":
            var blindImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "blind-\(i)")!
                blindImageCollection.append(newImage)
            }
            let blindStaticAnimatedImage = UIImage.animatedImage(with: blindImageCollection, duration: 5)!
            return blindStaticAnimatedImage
            
        case "COLOR FOR CHEATERS":
            var cheatImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "cheat-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                cheatImageCollection.append(newImage!)
            }
            let cheatStaticAnimatedImage = UIImage.animatedImage(with: cheatImageCollection, duration: 5)!
            return cheatStaticAnimatedImage

        case "LIAR'S CHEAT":
            
            var liarCheatImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "liar-cheat-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                liarCheatImageCollection.append(newImage!)
            }
            let liarCheatStaticAnimatedImage = UIImage.animatedImage(with: liarCheatImageCollection, duration: 5)!
            return liarCheatStaticAnimatedImage
            
        case "BRAIN TWIST":
            
            var twistImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "twist-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                twistImageCollection.append(newImage!)
            }
            let twistStaticAnimatedImage = UIImage.animatedImage(with: twistImageCollection, duration: 5)!
            return twistStaticAnimatedImage
            
        case "SPOKEN WORD":
            
            var spokenImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "spoken-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                spokenImageCollection.append(newImage!)
            }
            let spokenStaticAnimatedImage = UIImage.animatedImage(with: spokenImageCollection, duration: 5)!
            return spokenStaticAnimatedImage
            
            
        case "COLORBLIND FOR CHEATERS":
            
            var greyCheatImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "grey-cheat-\(i)")//.scaleImage(toSize: CGSize(width: 160, height: 90))
                greyCheatImageCollection.append(newImage!)
            }
            let greyCheatStaticAnimatedImage = UIImage.animatedImage(with: greyCheatImageCollection, duration: 5)!
            return greyCheatStaticAnimatedImage
            
            
        case "COLOR TORNADO":
            var colorTornadoImageCollection = [UIImage]()
            for i in 1...9 {
                let newImage = UIImage(named: "gm000\(i)")!
                colorTornadoImageCollection.append(newImage)
            }
            for i in 10...46 {
                let newImage = UIImage(named: "gm00\(i)")!
                colorTornadoImageCollection.append(newImage)
            }
            let colorTornadoAnimatedImage = UIImage.animatedImage(with: colorTornadoImageCollection, duration: 2)!
            return colorTornadoAnimatedImage
            
        case "COLORBLIND TORNADO":
            
            var colorTornadoImageCollection = [UIImage]()
            for i in 1...9 {
                let newImage = monochromeImage(UIImage(named: "gm000\(i)")!)
                colorTornadoImageCollection.append(newImage)
            }
            for i in 10...46 {
                let newImage = monochromeImage(UIImage(named: "gm00\(i)")!)
                colorTornadoImageCollection.append(newImage)
            }
            let colorTornadoAnimatedImage = UIImage.animatedImage(with: colorTornadoImageCollection, duration: 2)!
            return colorTornadoAnimatedImage
            
        case "CONSTANT PATTERN":
            
            var colorImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "color1-\(i)")!
                colorImageCollection.append(newImage)
            }
            let colorStaticAnimatedImage = UIImage.animatedImage(with: colorImageCollection, duration: 5)!
            return colorStaticAnimatedImage
            
        case "MULTIPLAYER":

            var multiImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "multi-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                multiImageCollection.append(newImage!)
            }
            let multiStaticAnimatedImage = UIImage.animatedImage(with: multiImageCollection, duration: 5)!
            return multiStaticAnimatedImage
            
        case "MULTIPLAYER":
            
            var multiImageCollection = [UIImage]()
            for i in 10...50 {
                let newImage = UIImage(named: "multi-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                multiImageCollection.append(newImage!)
            }
            let multiStaticAnimatedImage = UIImage.animatedImage(with: multiImageCollection, duration: 5)!
            return multiStaticAnimatedImage
            
        case "DIGITS OF PI":
            
            var piImageCollection = [UIImage]()
            for i in 10...71 {
                let newImage = UIImage(named: "pi-\(i)")
//                let newImage = UIImage(named: "pi-\(i)")?.scaleImage(toSize: CGSize(width: 160, height: 90))
                piImageCollection.append(newImage!)
            }
            let piStaticAnimatedImage = UIImage.animatedImage(with: piImageCollection, duration: 5)!
            return piStaticAnimatedImage
            
        default:
            print("default")
        }
        
        let tempImage = UIImage(systemName: "bandage.fill")
        return tempImage!
        
    }
    
    func monochromeImage(_ image: UIImage) -> UIImage {
        let brokenImage = UIImage(systemName: "wrench.and.screwdriver.fill")
        guard let currentCGImage = image.cgImage else { return brokenImage! }
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        guard let outputImage = filter?.outputImage else { return brokenImage! }
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        
        return brokenImage!
    }
    
    func loadStaticSimone() {
        for i in 10...50 {
            let newImage = UIImage(named: "color1-\(i)")!
            colorStaticGameImageCollection.append(newImage)
        }
        colorAnimatedImage = UIImage.animatedImage(with: colorStaticGameImageCollection, duration: 5)!
        
    }
    
    func loadImages() {
        for i in 1...9 {
            let newImage = UIImage(named: "gm000\(i)")!
            colorGameImageCollection.append(newImage)
        }
        for i in 10...46 {
            let newImage = UIImage(named: "gm00\(i)")!
            colorGameImageCollection.append(newImage)
        }
        animatedImage = UIImage.animatedImage(with: colorGameImageCollection, duration: 2)!
        
    }
    
    func setHighScores() {
        for gameName in simone.says.allCases.map({ String($0.rawValue.split(separator: "\n")[0]) }) {
            // name (string), score (int), time(float), date(double)
            highScores[gameName] = [Int(0), Float(0), Double(0), String()]
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameScores")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [GameScores]
        
        for item in resultData {
            if let itemName = item.name {
                highScores[itemName] = [item.score, item.time, item.date, item.initials ?? " * * * "]
            }
        }
    }
    
    func logoFade() {
        let logoImage = UIImageView(image: UIImage(named: "LKWD_CAST-logo1-sm"))
        
        logoImage.layer.zPosition = 3
        logoImage.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        logoImage.center = view.center
        logoImage.isUserInteractionEnabled = false
        view.addSubview(logoImage)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
            logoImage.alpha = 0
        })
    }
    
    @objc func changeSound() {
        playSound(instrument)

        var buttonTitle = " "
        switch instrument {
        case "Harp":
            buttonTitle = " T-BONE"
            instrument = "Trombone"
        case "Trombone":
            buttonTitle = " EDM"
            instrument = "EDM"
        case "EDM":
            buttonTitle = " BIGPULSE"
            instrument = "BigPulse"
        case "BigPulse":
            buttonTitle = " NONE"
            instrument = "Silence"
        case "Silence":
            buttonTitle = " HARP"
            instrument = "Harp"
        default:
            buttonTitle = " ?"
        }
            
        for slideSubView in scrollView.subviews {
            for sub in slideSubView.subviews {
                if sub is UIButton && sub.tag == 42 {
                    let button = sub as! UIButton
                    button.setTitle(buttonTitle, for: .normal)
                    }
                }
            }
    }
    
    func playSound(_ soundName: String) {
        print(soundName)
        let url = Bundle.main.url(forResource: soundName+"A1", withExtension: "wav")
        self.soundPlayer = try! AVAudioPlayer(contentsOf: url!)
        self.soundPlayer.prepareToPlay()
        self.soundPlayer.play()

    }
    
    @objc func goToView(sender: UIButton) {
        switch sender.accessibilityIdentifier {
        case "ORIGINAL":
            levelStyle = simone.says.color
            
        case "COLORBLIND":
            levelStyle = simone.says.colorBlind
            
        case "BLIND":
            levelStyle = simone.says.blind
            
        case "COLOR FOR CHEATERS":
            levelStyle = simone.says.colorCheat
            
        case "LIAR'S CHEAT":
            levelStyle = simone.says.liarsCheat
            
        case "COLORBLIND FOR CHEATERS":
            levelStyle = simone.says.colorBlindCheat
            
        case "COLOR TORNADO":
            levelStyle = simone.says.colorTornado
            
        case "COLORBLIND TORNADO":
            levelStyle = simone.says.colorBlindTornado
            
        case "DIGITS OF PI":
            levelStyle = simone.says.pi
            
        case "CONSTANT PATTERN":
            levelStyle = simone.says.constantPattern
            
        case "MULTIPLAYER":
            levelStyle = simone.says.multiPlayer
            
        case "MULTIPLAYER 2":
            levelStyle = simone.says.patternTap
            
        case "BRAIN TWIST":
            levelStyle = simone.says.brainTwist
        
        case "SPOKEN WORD":
            levelStyle = simone.says.spokenWord
            
        default:
            print("Nothing detected. Start again.")
        
        }
        
        if levelStyle == simone.says.pi {
            self.performSegue(withIdentifier: "scrollingPi", sender: self)
        } else {
            self.performSegue(withIdentifier: "scrollingPlay", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if levelStyle == simone.says.pi {
            let vc = segue.destination as! PiViewController
//            vc.levelStyle = levelStyle
        } else {
            let vc = segue.destination as! ViewController
            vc.multiButtonRectangle = multiButtonRectangle
            vc.levelStyle = levelStyle
            vc.instrument = instrument
        }
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth*CGFloat(pageControl!.currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }
    
    func setIndicatorForCurrentPage() {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
    
}


extension UIView {
    var allSubviews : [UIView] {
        
        var array = [self.subviews].flatMap { $0 }
        array.forEach { array.append(contentsOf: $0.allSubviews) }
        return array
        
    }
    
    func applyGradient(_ color1: CGColor=UIColor.blue.cgColor, _ color2: CGColor=UIColor.black.cgColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [
            color1,
            color2
        ]
//        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        gradient.cornerRadius = 25
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension NSAttributedString {
    func rangeOf(string: String) -> Range<String.Index>? {
        return self.string.range(of: string)
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
