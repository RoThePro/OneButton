import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var aboutView: UIView!
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBAction func aboutButtonClick(sender: AnyObject) {
        if(aboutView.hidden == true){
            aboutView.hidden = false
        }else{
            aboutView.hidden = true
        }
    }
    override func viewDidLoad() {
        aboutView.hidden = true
        view.backgroundColor = UIColor.grayColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPress.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPress)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tap(sender: UIGestureRecognizer){
        var dirPath: AnyObject = NSSearchPathForDirectoriesInDomains( .DocumentDirectory,  .UserDomainMask, true)[0]
        var soundFilePath = dirPath.stringByAppendingPathComponent("hello.wav")
        var url = NSURL(fileURLWithPath: soundFilePath)
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
        } catch var error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        audioPlayer.delegate = self
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
        } else {
            view.backgroundColor = UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        view.backgroundColor = UIColor.grayColor()
    }
    
    func longPress(sender: UIGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            view.backgroundColor = UIColor(red:1.00, green:0.30, blue:0.30, alpha:1.0)
            var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryRecord)
            } catch _ {
            }
            do {
                try audioSession.setActive(true)
            } catch _ {
            }
            
            var dirPath: AnyObject = NSSearchPathForDirectoriesInDomains( .DocumentDirectory,  .UserDomainMask, true)[0]
            var soundFilePath = dirPath.stringByAppendingPathComponent("hello.wav")
            var url = NSURL(fileURLWithPath: soundFilePath)
            
            print("url : \(url)")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000.0,
                AVNumberOfChannelsKey: 1 as NSNumber,
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            ]
            
            audioRecorder = try? AVAudioRecorder(URL:url, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }else if(sender.state == UIGestureRecognizerState.Ended){
            view.backgroundColor = UIColor.grayColor()
            audioRecorder.stop()
            var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {
            }
            do {
                try audioSession.setActive(true)
            } catch _ {
            }
        }
    }

}

