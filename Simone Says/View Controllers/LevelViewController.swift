//
//  LevelViewController.swift
//  Simone Says
//
//  Created by Matt Larsen on 3/27/21.
//

import UIKit

class LevelViewController: UIViewController {
    @IBOutlet var levelOneButton: UIButton!
    
    
    
    var levelContentsView = UIView()
    var buttonView = UIView()
    var goToLevelButton = UIButton()
    var levelStyle = simone.says.nothing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLevelContentsView()
    }
    
    func setLevelContentsView() {
        levelContentsView.layer.cornerRadius = 40
        view.addSubview(levelContentsView)
        levelContentsView.backgroundColor = UIColor.systemBlue
        levelContentsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            levelContentsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            levelContentsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            levelContentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            levelContentsView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10)
        ])
        
        goToLevelButton.layer.backgroundColor = UIColor.yellow.cgColor
        goToLevelButton.setTitle("GO", for: .normal)
        goToLevelButton.setTitleColor(UIColor.black, for: .normal)
        goToLevelButton.titleLabel!.font = UIFont(name: "KidGames", size: 24)
        goToLevelButton.addTarget(self, action: #selector(didTapGo), for: .touchUpInside)
        goToLevelButton.layer.cornerRadius = 40
        print(view.bounds.width/2)
        
        goToLevelButton.frame = CGRect(x: 0, y: 0, width: (view.bounds.width/2)-40, height: 100)
        
        view.addSubview(goToLevelButton)
        
        goToLevelButton.center = CGPoint(x: view.frame.midX + view.bounds.width/4, y: view.frame.maxY - 70)
        
    }
    
    @IBAction func didTapOriginal(_ sender: UIButton) {
        levelStyle = simone.says.color
    }
    
    @IBAction func didTapCheater(_ sender: UIButton) {
        levelStyle = simone.says.colorCheat
    }
    
    @IBAction func didTapCheatTornado(_ sender: UIButton) {
        levelStyle = simone.says.colorTornado
    }
    
    @IBAction func didTapColorBlind(_ sender: UIButton) {
        levelStyle = simone.says.colorBlind
    }
    
    @IBAction func didTapColorBlindCheat(_ sender: UIButton) {
        levelStyle = simone.says.colorBlindCheat
    }
    
    @IBAction func didTapColorBlindCheatTornado(_ sender: UIButton) {
        levelStyle = simone.says.colorBlindTornado
    }
    
    @IBAction func didTapPi(_ sender: UIButton) {
        levelStyle = simone.says.pi
    }
    
    
    @objc func didTapGo(_ sender: UIButton) {
        if levelStyle == simone.says.pi {
            self.performSegue(withIdentifier: "pi", sender: self)
        } else {
            self.performSegue(withIdentifier: "play", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if levelStyle == simone.says.pi {
            let vc = segue.destination as! PiViewController
//            vc.levelStyle = levelStyle
        } else {
            let vc = segue.destination as! ViewController
        vc.levelStyle = levelStyle
        }
    }
    
}
