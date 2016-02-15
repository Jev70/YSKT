import UIKit
import AVFoundation
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var survivalHighscoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    @IBOutlet weak var survivalLabel: UIButton!
    
    @IBOutlet weak var fullTestLabel: UIButton!
    
    @IBOutlet weak var YSKT: UILabel!
    
    @IBOutlet weak var youShouldKnowThis: UILabel!
    
    var fullTestSelected: Bool!
    
    var audioPlayer = AVAudioPlayer()
    
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Stores the default leaderboardID

    @IBAction func fullTest(sender: UIButton) {
        playBop()
        fullTestSelected = true
        startGame()
    }

    @IBAction func survivalMode(sender: UIButton) {
        playBop()
        fullTestSelected = false
        startGame()
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    func startGame(){
        self.performSegueWithIdentifier("segue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let vc:MultipleChoiceViewController = segue.destinationViewController as! MultipleChoiceViewController
        vc.gameTypeIsFullTest = fullTestSelected
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateLocalPlayer()
        
        loadQuizData()
        
        animateButtons()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let highscorePercentage = NSUserDefaults.standardUserDefaults().doubleForKey("highscorePercentage")
        let survivalHighscore  = NSUserDefaults.standardUserDefaults().integerForKey("survivalHighscore")
        
        let str = NSString(format: "%.0f", highscorePercentage)
        highscoreLabel.text = "Highscore: \(str)%"
        
        survivalHighscoreLabel.text = "Highscore: \(survivalHighscore)"
        
    }
    
    func playBop(){
            do {
                self.audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pop", ofType: "wav")!))
                self.audioPlayer.volume = 1
                self.audioPlayer.play()
                
            } catch {
                print("Error")
        }
    }
    
    func positionEverythingOffScreen(){
        highscoreLabel.center.y = self.view.frame.height + 300
        fullTestLabel.center.y = self.view.frame.height + 300
        survivalHighscoreLabel.center.y = self.view.frame.height + 300
        survivalLabel.center.y = self.view.frame.height + 300
        YSKT.center.y =  -300
        youShouldKnowThis.center.y =  -300
    }
    
    func animateButtons(){
        
        positionEverythingOffScreen()
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 40, initialSpringVelocity: 2.0, options:  UIViewAnimationOptions.TransitionNone, animations: ({
            
            self.YSKT.center.y = self.view.frame.height / 2
            self.youShouldKnowThis.center.y = self.view.frame.height / 2
            
            
        }), completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.6, usingSpringWithDamping: 40, initialSpringVelocity: 2.0, options:  UIViewAnimationOptions.TransitionNone, animations: ({
            
            
            self.highscoreLabel.center.y = self.view.frame.height / 2
            self.survivalHighscoreLabel.center.y = self.view.frame.height / 2
            
            
        }), completion: nil)
        
        UIView.animateWithDuration(1, delay: 1.2, usingSpringWithDamping: 4, initialSpringVelocity: 4.0, options:  UIViewAnimationOptions.TransitionNone, animations: ({
            
            self.survivalLabel.center.y = self.view.frame.height / 2
            self.fullTestLabel.center.y = self.view.frame.height / 2
            
        }), completion: nil)
        
    }

    func loadQuizData() {
        //Multiple Choice Data
        let pathMC = NSBundle.mainBundle().pathForResource("MultipleChoice", ofType: "plist")
        let dictMC = NSDictionary(contentsOfFile: pathMC!)
        mcArray = dictMC!["Questions"]!.mutableCopy() as? Array
    }
    
    func check() {
        print(mcArray)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.presentViewController(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                // 2 Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
            
        }
        
    }
    
}

        

