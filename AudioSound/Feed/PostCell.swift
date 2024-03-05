//
//  PostCell.swift
//  AudioSound
//
//  Created by Olisemedua Onwuatogwu on 4/21/23.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation
import ParseSwift

class PostCell: UITableViewCell, AVAudioPlayerDelegate {

    @IBOutlet weak var audioArtwork: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var smallClipArt: UIImageView!
    
    @IBOutlet weak var audioClipName: UILabel!
    
    @IBOutlet weak var audiodescription: UILabel!
    
    @IBOutlet weak var userNameUI: UILabel!
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var touchAreaView: UIView!
    
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBOutlet weak var artWorkBackGround: UIView!
    
    @IBOutlet weak var contentViewUI: UIView!
    
    var audioData:Data?
    var audioPlayer: AVPlayer?
    var audioParseFile: ParseFile?
    var progressBarObserver: Any?
    var colorIndex: Int?
    let backGroundColors = [
        UIColor(red: 0.11, green: 0.17, blue: 0.23, alpha: 1.00),
        UIColor(red: 0.28, green: 0.09, blue: 0.10, alpha: 1.00),
        UIColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1.00),
        UIColor(red: 0.69, green: 0.53, blue: 0.53, alpha: 1.00)]
    private var imageDataRequest: DataRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // random numbber
        colorIndex = Int.random(in: 0..<4);
        // reset progress bar to 0.0
        progressBar.setProgress(0.0, animated: true);
    }
    

    func configureCell(with audioInfo: Audio){
        // Initialization code
        
        artWorkBackGround.layer.cornerRadius = 12;
        artWorkBackGround.layer.masksToBounds = true;
        
        smallClipArt.layer.cornerRadius = 12;
        smallClipArt.layer.masksToBounds = true;
        contentViewUI.layer.cornerRadius = 30;
        //smallClipArt.layer.masksToBounds = true;
        contentViewUI.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        profileIcon.layer.cornerRadius = 22;
        profileIcon.layer.masksToBounds = true;
        contentViewUI.backgroundColor = backGroundColors[colorIndex!];
        touchAreaView.backgroundColor = backGroundColors[colorIndex!];
        
        // Add gesture recognizer to the touch area view
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            touchAreaView.addGestureRecognizer(tapGestureRecognizer)
            
        // Add pan gesture recognizer to the touch area view
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            touchAreaView.addGestureRecognizer(panGestureRecognizer)
        
        let TGR_playPause = UITapGestureRecognizer(target: self, action: #selector(onClickBigImage))
        artWorkBackGround.addGestureRecognizer(TGR_playPause)
            
        
        
        
        // Image
        if let imageFile = audioInfo.clipArt,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            
            // Remeber Nuke packge we used some
            // labs ago was used to load up image
            // from URL. rember our imge file
            // is not an image but binary file
            
            
            imageDataRequest = AF.request(imageUrl).responseImage{
                [weak self] response in
                
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.audioArtwork.image = image
                    self?.smallClipArt.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
        if let profile = audioInfo.user?.profile,
           let imageUrl = profile.url{
            
            imageDataRequest = AF.request(imageUrl).responseImage{
                [weak self] response in
                
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.profileIcon.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        else{
            profileIcon.image = Image(named: "person.fill");
        }
        
        audioClipName.text = audioInfo.audioName
        audiodescription.text = audioInfo.description
        hashTag.text = audioInfo.hashTags
        userNameUI.text = audioInfo.user?.username
    }
    
    @IBAction func onClickBigImage(_ sender: Any) {
        
        if(audioPlayer?.rate != 0){ // means audio playinng
            audioPlayer?.pause();
            blur.alpha = 0.55;
        }
        else{
            audioPlayer?.play()
            blur.alpha = 0;
        }
    }
    
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: touchAreaView)
        let progress = point.x / touchAreaView.bounds.size.width
        progressBar.setProgress(Float(progress), animated: true)
    }

    func addProgressBarObserver(audioPlayer: AVPlayer ){
        // Add "periodic time observer" to update the progress bar
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        progressBarObserver = audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
            [weak self] time in
            
            // keep updating the progress bar
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(audioPlayer.currentItem?.duration ?? CMTime.zero)
            
            // this gives us a percentage of completeness
            let progress = Float(currentTime / duration)
                
            self?.progressBar.setProgress(progress, animated: true);
        }
        
        self.audioPlayer = audioPlayer
    }
    
    func removeProgressBarObserver(){
        guard let audioPlayer = self.audioPlayer
        else{ return}
            
        audioPlayer.removeTimeObserver(progressBarObserver as Any);
        self.audioPlayer = nil
    }
    
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: touchAreaView)
        let progress = progressBar.progress + Float(translation.x / touchAreaView.bounds.size.width)
        progressBar.setProgress(progress, animated: true)
        sender.setTranslation(CGPoint.zero, in: touchAreaView)
    }
    
    // resets the values in the post cell
    func reset(){
        progressBar.progress = 0;
        blur.alpha = 0;
    }
    func progressBarAnimation(){
        progressBar.setProgress(1.0, animated: true);
    }
    
    
}
