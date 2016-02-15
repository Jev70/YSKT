import UIKit
import GameKit
import AVFoundation
import Social

class ScoreViewController: UIViewController, GKGameCenterControllerDelegate  {


    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBAction func backToHome(sender: UIButton) {
        playBop(false)
    }
    
    @IBAction func leaderBoard(sender: UIButton) {
    }
    
    @IBAction func shareToFacebook(sender: UIButton) {
        if gameTypeIsFullTest{
            var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            shareToFacebook.addImage(UIImage(named: "YSKT.png"))
            shareToFacebook.setInitialText("I Scored \(finalPercentage)% in the 'You Should Know This' Test")
            self.presentViewController(shareToFacebook, animated: true, completion: nil)
        }else{
            var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            shareToFacebook.setInitialText("I scored \(finalScore) in 'You Should Know This' Survival Mode")
            shareToFacebook.addImage(UIImage(named: "YSKT.png"))
            self.presentViewController(shareToFacebook, animated: true, completion: nil)
        }
    }

    @IBAction func shareToTwitter(sender: UIButton) {
        if gameTypeIsFullTest{
            var shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            shareToTwitter.setInitialText("I scored \(finalPercentage)% in the 'You Should Know This' test")
            shareToTwitter.addImage(UIImage(named: "YSKT.png"))
            self.presentViewController(shareToTwitter, animated: true, completion: nil)
        }else{
            var shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            shareToTwitter.setInitialText("I scored \(finalScore) in 'You Should Know This' Survival Mode")
            shareToTwitter.addImage(UIImage(named: "YSKT.png"))
            self.presentViewController(shareToTwitter, animated: true, completion: nil)
        }
    }
    
    var highscorePercentage = NSUserDefaults.standardUserDefaults().doubleForKey("highscorePercentage")
    
    var survivalHighscore = NSUserDefaults.standardUserDefaults().integerForKey("survivalHighscore")
    
    var audioPlayer = AVAudioPlayer()
    
    var finalPercentage: Double = 0.0
    
    var finalScore: Int = 0
    
    var gameTypeIsFullTest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundPercentage()
        
        setFeedbackMessages()

        setScoreLabels()
        
        animateButtons()
        
        saveScore()
        
    }
    
    func roundPercentage(){
        finalPercentage = round(finalPercentage)
    }
    
    func saveScore(){
        if gameTypeIsFullTest{
            if finalPercentage > highscorePercentage{
                highscorePercentage = finalPercentage
                //check if score is better than before
                //submit score
                let leaderboardID = "ysktleaderboard_01"
                let sScore = GKScore(leaderboardIdentifier: leaderboardID)
                sScore.value = Int64(finalPercentage)
                //check the final percentage and highscore is actually the same
                let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
                
                GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Score submitted")
                        
                    }
                })
            }
        } else{
            if finalScore > survivalHighscore{
                survivalHighscore = finalScore
                //check if score is better than before
                //submit score
                let leaderboardID = "ysktleaderboard_02"
                let sScore = GKScore(leaderboardIdentifier: leaderboardID)
                sScore.value = Int64(survivalHighscore)
                //check the final percentage and highscore is actually the same
                let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
                
                GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Score submitted")
                        
                    }
                })
            }
        }
    }
    
    func playBop(mute: Bool){
        if mute == false{
            do {
                self.audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pop", ofType: "wav")!))
                self.audioPlayer.volume = 1
                self.audioPlayer.play()
                
            } catch {
                print("Error")
            }
        }
    }
    
    func positionEverythingOffScreen(){
        percentageLabel.center.y = -100
        feedbackLabel.center.y = -100
    }
    
    func animateButtons(){
        
        positionEverythingOffScreen()
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 40, initialSpringVelocity: 2.0, options:  UIViewAnimationOptions.TransitionNone, animations: ({
            
            self.percentageLabel.center.y = self.view.frame.height / 2
            self.feedbackLabel.center.y = self.view.frame.height / 2
            
        }), completion: nil)
    }
    
    func setFeedbackMessages(){
        
        if gameTypeIsFullTest{
            switch finalPercentage{
                case _ where finalPercentage < 10:
                    feedbackLabel.text = "That was a joke right?"
                case _ where finalPercentage < 30:
                    feedbackLabel.text = "Hahhaha"
                case _ where finalPercentage < 50:
                    feedbackLabel.text = "Sigh... get studying"
                case _ where finalPercentage < 60:
                    feedbackLabel.text = "Even Donald Trump could probably do better"
                case _ where finalPercentage < 70:
                    feedbackLabel.text = "LOL... did you go to school?"
                case _ where finalPercentage < 80:
                    feedbackLabel.text = "Just about acceptable"
                case _ where finalPercentage < 90:
                    feedbackLabel.text = "You've done better than most"
                case _ where finalPercentage < 100:
                    feedbackLabel.text = "Congrats Genius, not 100% though"
            case _ where finalPercentage == 100:
                feedbackLabel.text = "WOW"
                default:
                    feedbackLabel.text = "Could Be Better Still"
            }
        }else{
            switch finalScore{
            case _ where finalScore == mcArray?.count:
                feedbackLabel.text = "You are clever aren't you"
            default:
                let randomNumber = arc4random_uniform(10)
                switch randomNumber{
                case _ where randomNumber < 2:
                    feedbackLabel.text = "Don't worry, it's only common knowledge"
                case _ where randomNumber < 4:
                    feedbackLabel.text = "Keep practising..."
                case _ where randomNumber < 6:
                    feedbackLabel.text = "You NEED to know this stuff"
                case _ where randomNumber < 10:
                    feedbackLabel.text = "Yeah..."
                default:
                    feedbackLabel.text = "Unlucky fella..."
                }
                
            }
        }
    }
    
    func setScoreLabels(){
        if gameTypeIsFullTest{
            let str = NSString(format: "%.0f", finalPercentage)
            percentageLabel.text = "\(str)%"
        }else{
            percentageLabel.text = "\(finalScore)"
        }
    }

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showLeaderboard(sender: UIButton) {
        
        if gameTypeIsFullTest{
            //show leaderboard
            let gcVC: GKGameCenterViewController = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
            gcVC.leaderboardIdentifier = "ysktleaderboard_01"
            self.presentViewController(gcVC, animated: true, completion: nil)
        }else{
            let gcVC: GKGameCenterViewController = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
            gcVC.leaderboardIdentifier = "ysktleaderboard_02"
            self.presentViewController(gcVC, animated: true, completion: nil)
        }

    }//end of function

}
