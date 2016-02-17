import UIKit
import AVFoundation
import GoogleMobileAds

class MultipleChoiceViewController: UIViewController{
    
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet weak var imageQuestionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var quizProgress: UILabel!
    
    @IBOutlet var rowButtons: [UIButton]!
    
    @IBAction func rowButtonHandler(sender: UIButton) {
        sender.exclusiveTouch = true
        disableButtons()
        questionIdx++
        timer.invalidate()
        wasButtonTapped = true
        if sender.titleLabel!.text == correctAnswer {
            correctSelected(sender)
        } else {
            wrongSelected(sender)
            displayCorrectAnswer()
            if(gameTypeIsFullTest == false){
                gameIsOver = true
            }
        }
        nextQuestionOrGameOver()
    }

    @IBOutlet var answerButtons: [UIButton]!
    
    @IBAction func answerButtonHandler(sender: UIButton) {
        sender.exclusiveTouch = true
        disableButtons()
        questionIdx++
        timer.invalidate()
        wasButtonTapped = true
        if sender.titleLabel!.text == correctAnswer {
            correctSelected(sender)
        } else {
            wrongSelected(sender)
            displayCorrectAnswer()
            if(gameTypeIsFullTest == false){
                gameIsOver = true
            }
        }
        nextQuestionOrGameOver()
    }

    
    @IBAction func Home(sender: UIButton) {
        playBop(mute)
        homeButtonTapped = true
        gameIsOver = true
    }
    
    var swoosh = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("swoosh", ofType: "wav")!)
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    var correctAnswer: String?
    
    var question: String?
    
    var image: String?

    
    enum questionType: String{
        case Multiple, Row, Image
    }
    
    var typeOfQ = questionType.Multiple
    
    var answers = [String]()
    
    var gameIsOver: Bool = false
    
    var questionIdx = 0
    
    var timer = NSTimer()
    
    var currentScore = 0
    
    var survivalScore = 0
    
    var percentage:Double = 0
    
    var gameTypeIsFullTest: Bool = false
    
    var wasButtonTapped: Bool = false
    
    var areWeOutOfTime: Bool = false
    
    var mute: Bool = false
    
    var homeButtonTapped:Bool = false
    
    var highscorePercentage = NSUserDefaults.standardUserDefaults().doubleForKey("highscorePercentage")

    var survivalHighscore = NSUserDefaults.standardUserDefaults().integerForKey("survivalHighscore")
    
    var num = -1
    
    struct colorPalette {
        static let darkGreen = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
        static let darkBlue = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
        static let midnightBlue = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        static let salem = UIColor(red: 30/255, green: 130/255, blue: 76/255, alpha: 1)
        static let eucalyptus = UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1)
        static let gossip = UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1)
        static let emerald = UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1)
        static let grey = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1)
        static let flatRed = UIColor(red: 254/255, green: 0/255, blue: 0/255, alpha: 1)
        static let sprout = UIColor(red: 122/255, green: 148/255, blue: 46/255, alpha: 1)
        static let freshOnion = UIColor(red: 91/255, green: 137/255, blue: 48/255, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in navigationController!.navigationBar.subviews {
            view.exclusiveTouch = true
        }
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-7187599761378654/1096329927"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        gameIsOver = false
        mcArray!.shuffle()
        setUpProgressBar()
        whichQuestionType()

    }

    func nextQuestionOrGameOver(){
        delay(1){
            if(self.gameIsOver){
                self.toScoreMenu()
            }else if self.gameTypeIsFullTest == false && self.questionIdx + 1  == mcArray?.count{
                self.toScoreMenu()
            }
            else{
                self.whichQuestionType()
            }
        }
    }

    func wrongSelected(sender: UIButton){
        playWrong(mute)
        sender.backgroundColor = UIColor.redColor()
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

    func correctSelected(sender: UIButton){
        playCorrect(mute)
        currentScore++
        survivalScore++
        delay(0.05){
            sender.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }

    func displayCorrectAnswer(){
        switch typeOfQ{
        case .Multiple:
            for button in answerButtons {
                if button.titleLabel!.text == correctAnswer {
                    delay(0.15){
                        button.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
                        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    }
                }
            }
        case .Row:
            for button in rowButtons {
                if button.titleLabel!.text == correctAnswer {
                    delay(0.15){
                        button.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
                        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    }
                }
            }
        case .Image:
            for button in answerButtons {
                if button.titleLabel!.text == correctAnswer {
                    delay(0.15){
                        button.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
                        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    }
                }
            }
        }
    }
    
    func whichColorPaletteToUse() -> [UIColor]{
        if(gameTypeIsFullTest){
            return [colorPalette.eucalyptus]
        }else{
            return [colorPalette.salem, colorPalette.sprout, colorPalette.freshOnion]
        }
    }
    
    func setUpProgressBar(){
        progressView.layer.cornerRadius = 40
        progressView.transform = CGAffineTransformScale(progressView.transform, 1, 5)
    }
    
    func resetBooleans(){
        wasButtonTapped = false
        areWeOutOfTime = false
    }
    
    func setThemeColour(){
        var colorArray = whichColorPaletteToUse()
        num++
        var indexOfView3 = num - 1
        if num >= colorArray.count{
            num = 0
        }
        let colour = colorArray[num]
        view2.backgroundColor = colour
        switch typeOfQ{
        case .Multiple:
            for (_,button) in answerButtons.enumerate(){
                button.setTitleColor(colour, forState: .Normal)
            }
        case .Row:
            for (_,button) in rowButtons.enumerate(){
                button.setTitleColor(colour, forState: .Normal)
            }
        case .Image:
            for (_,button) in answerButtons.enumerate(){
                button.setTitleColor(colour, forState: .Normal)
            }
        }
        if indexOfView3 == -1{
            indexOfView3 = num
        }
        view3.backgroundColor = colorArray[indexOfView3]
    }
    
    func playSwoosh(mute: Bool){
        if mute == false{
            do {
                self.audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("swoosh", ofType: "wav")!))
                self.audioPlayer.volume = 0.4
                self.audioPlayer.play()
                
            } catch {
                print("Error")
            }
        }
    }
    
    func playCorrect(mute: Bool){
        if mute == false{
            do {
                self.audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("correct", ofType: "wav")!))
                self.audioPlayer.volume = 0.1
                self.audioPlayer.play()
                
            } catch {
                print("Error")
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
    
    func playWrong(mute: Bool){
        if mute == false{
            do {
                self.audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrong", ofType: "mp3")!))
                self.audioPlayer.volume = 1
                self.audioPlayer.play()
                
            } catch {
                print("Error")
            }
        }
    }

    func whichQuestionType(){
        resetBooleans()
        if(isItEndOfQuiz()==false){
            let currentQuestion = mcArray![questionIdx]
            let questionTypeUsed = currentQuestion["Type"] as! String
            switch questionTypeUsed{
                case "Multiple":
                    typeOfQ = .Multiple
                case "Row":
                    typeOfQ = .Row
                case "Image":
                    typeOfQ = .Image
                default:
                    break;
            }
            loadQuestion()
        }
    }
    
    func loadQuestion(){
        let currentQuestion = mcArray![questionIdx]
        switch typeOfQ{
            case .Multiple:
                answers = currentQuestion["Answers"] as! [String]
                correctAnswer = currentQuestion["CorrectAnswer"] as? String
                question = currentQuestion["Question"] as? String
            case .Row:
                answers = currentQuestion["Answers"] as! [String]
                correctAnswer = currentQuestion["CorrectAnswer"] as? String
                question = currentQuestion["Question"] as? String
            case .Image:
                image = currentQuestion["Image"] as? String
                answers = currentQuestion["Answers"] as! [String]
                correctAnswer = currentQuestion["CorrectAnswer"] as? String
                question = currentQuestion["Question"] as? String
        }
        buttonsVisibile()
        titlesForButtons()
    }
    
    func titlesForButtons() {
        switch typeOfQ{
        case .Multiple:
            for (idx,button) in answerButtons.enumerate() {
                button.titleLabel!.lineBreakMode = .ByWordWrapping
                button.setTitle(answers[idx], forState: .Normal)
                button.backgroundColor = UIColor.whiteColor()
            }
            imageView.hidden = true
            imageQuestionLabel.hidden = true
            questionLabel.text = question
            questionLabel.hidden = false
        case .Row:
            for (idx,button) in rowButtons.enumerate() {
                button.titleLabel!.lineBreakMode = .ByWordWrapping
                button.setTitle(answers[idx], forState: .Normal)
                button.backgroundColor = UIColor.whiteColor()
            }
            imageView.hidden = true
            imageQuestionLabel.hidden = true
            questionLabel.text = question
            questionLabel.hidden = false
        case .Image:
            imageView.image = UIImage(named: image!)
            imageView.hidden = false
            for (idx,button) in answerButtons.enumerate() {
                button.titleLabel!.lineBreakMode = .ByWordWrapping
                button.setTitle(answers[idx], forState: .Normal)
                button.backgroundColor = UIColor.whiteColor()
            }
            imageQuestionLabel.hidden = false
            imageQuestionLabel.text = question
            questionLabel.hidden = true
        }
        
        if gameTypeIsFullTest{
            quizProgress.text = "Quiz Progress: \(questionIdx + 1)/\((mcArray!.count))"
        } else{
            quizProgress.text = "Quiz Progress: \(questionIdx + 1)/\((mcArray!.count))"
        }
        animateViews()
        setThemeColour()
        startTimer()
    }
    
    func startTimer() {
        timer.invalidate()
        progressView.progress = 1.0
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateProgressView", userInfo: "timer", repeats: true)
    }
    
    func updateProgressView() {
        progressView.progress -= 0.01/14
        if progressView.progress == 0 {
            disableButtons()
            outOfTime()
        }
    }
    
    func outOfTime() {
        timer.invalidate()
        areWeOutOfTime = true
        if(gameIsOver==false){
            questionIdx++
            playWrong(mute)
            disableButtons()
            switch typeOfQ{
                case .Multiple:
                    for button in answerButtons {
                        if button.titleLabel!.text == correctAnswer {
                            delay(0.15){
                                button.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
                                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            }
                        }
                    }//end of for
                    delay(1.2){
                        if(self.gameTypeIsFullTest == true){
                            if(self.gameIsOver == false){
                                self.whichQuestionType()
                            }
                        } else{
                            self.toScoreMenu()  //change this to a segue
                        }
                    }
                    
                case .Row:
                    for button in rowButtons {
                        if button.titleLabel!.text == correctAnswer {
                            delay(0.15){
                                button.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
                                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            }
                            //make a small if statement in case answer is wrong so user can see the correct answer
                            delay(1.2){
                                if(self.gameTypeIsFullTest == true){
                                    self.whichQuestionType()
                                } else{
                                    self.toScoreMenu()  //change this to a segue
                                }
                            }
                        }//end of if
                    }//end of for
                case .Image:
                    for button in answerButtons {
                        if button.titleLabel!.text == correctAnswer {
                            delay(0.15){
                                button.backgroundColor = UIColor(red: 86/255, green: 216/255, blue: 43/255, alpha: 1)
                                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            }
                        }
                    }//end of for
                    delay(1.2){
                        if(self.gameTypeIsFullTest == true){
                            if(self.gameIsOver == false){
                                self.whichQuestionType()
                            }
                        } else{
                            self.toScoreMenu()  //change this to a segue
                        }
                }
            }//end of switch
        }// end of if game is over
    }
    
    func disableButtons() {
        for button in answerButtons {
            button.enabled = false
        }
        for button in rowButtons {
            button.enabled = false
        }
    }
    
    func setScores() {
        scoreToPercentage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(homeButtonTapped){
             let vcMultiple:ViewController = segue.destinationViewController as! ViewController
        } else{
            if(gameTypeIsFullTest == true){
                let vcMultiple:ScoreViewController = segue.destinationViewController as! ScoreViewController
                vcMultiple.finalPercentage = percentage
                vcMultiple.gameTypeIsFullTest = true
            } else{
                 let vcMultiple:ScoreViewController = segue.destinationViewController as! ScoreViewController
                 vcMultiple.finalScore = survivalScore
                 vcMultiple.gameTypeIsFullTest = false
            }
        }
    }
    
    func toScoreMenu(){
        setScores()
        self.performSegueWithIdentifier("segue", sender: nil)
    }
    
    func isItEndOfQuiz() -> Bool{
        if(questionIdx == mcArray!.count){
            scoreToPercentage()
            setScores()
            toScoreMenu()
            return true
        }else{
            return false
        }
    }
    
   func buttonsVisibile(){
        switch typeOfQ{
          case .Multiple:
                for (_,button) in self.rowButtons.enumerate() {
                    button.hidden = true
                }
                for (_,button) in self.answerButtons.enumerate() {
                    button.backgroundColor = UIColor(red: 37.0/255.0, green: 174.0/255.0, blue: 95.0/255.0, alpha: 1.0)
                    button.hidden = false
                    button.enabled = true
                }
            
            case .Row:
                //if row then make answer buttons invisible (multiple choice)
                for (_,button) in self.answerButtons.enumerate() {
                    button.hidden = true
            }
                for (_,button) in self.rowButtons.enumerate() {
                    button.backgroundColor = UIColor(red: 37.0/255.0, green: 174.0/255.0, blue: 95.0/255.0, alpha: 1.0)
                    button.hidden = false
                    button.enabled = true
            }
            
            case .Image:
                for (_,button) in self.rowButtons.enumerate() {
                    button.hidden = true
                }
                for (_,button) in self.answerButtons.enumerate() {
                    button.backgroundColor = UIColor(red: 37.0/255.0, green: 174.0/255.0, blue: 95.0/255.0, alpha: 1.0)
                    button.hidden = false
                    button.enabled = true
                }

            }
    }
    
    func positionViewsOffScreen(){
        view2.center.x = self.view.frame.width + 300
        questionLabel.center.x = self.view.frame.width + 300
        progressView.center.x = self.view.frame.width + 300
        imageView.center.x = self.view.frame.width + 300
        imageQuestionLabel.center.x = self.view.frame.width + 300
        
    }
    
    func positionButtonsOffScreen(){
        for (idx,button) in answerButtons.enumerate() {
            button.center.x = self.view.frame.width + 200
        }
        
        for (idx,button) in rowButtons.enumerate() {
            button.center.x = self.view.frame.width + 200
        }
    }
    
    func animateViews(){
        
        positionViewsOffScreen()
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 12.0, options:  UIViewAnimationOptions.TransitionNone, animations: ({
            
            self.view2.center.x = self.view.frame.width / 2
            self.questionLabel.center.x = self.view.frame.width / 2
            self.progressView.center.x = self.view.frame.width / 2
            self.imageView.center.x = self.view.frame.width / 2
            self.imageQuestionLabel.center.x = self.view.frame.width / 2
            
        }), completion: nil)
        
      animateButtons()
        
    }
    
    func animateButtons(){
        
        positionButtonsOffScreen()
        
        var buttonDelay:Double = 0.18
        let delayBetweenButtons:Double = 0.1
        let animationDuration = 0.7
        
        delay(0.06){
            self.playSwoosh(self.mute)
        }
        
    
        for (idx,button) in self.answerButtons.enumerate(){
            
            UIView.animateWithDuration(animationDuration, delay: buttonDelay, usingSpringWithDamping: 0.7, initialSpringVelocity: 7.0, options: UIViewAnimationOptions.TransitionNone, animations: ({
                self.answerButtons[idx].center.x = self.view.frame.width / 2
            }), completion: nil)
            buttonDelay += delayBetweenButtons
        }
        
        for (idx,button) in self.rowButtons.enumerate(){
            
            UIView.animateWithDuration(animationDuration, delay: buttonDelay-0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 8.0, options: UIViewAnimationOptions.TransitionNone, animations: ({
                self.rowButtons[idx].center.x = self.view.frame.width / 2
            }), completion: nil)
            buttonDelay += delayBetweenButtons


        }
    }
    
    func delay(delay:Double, closure:()->()) {
            dispatch_after(
                dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    func scoreToPercentage(){
        percentage = (Double(currentScore)/Double(mcArray!.count)) * 100
    }
    
}
