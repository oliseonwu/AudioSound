//
//  ProfileViewController.swift
//  AudioSound
//
//  Created by Kevin Nguyen on 5/14/23.
//

import Foundation
import UIKit
import ParseSwift
import UniformTypeIdentifiers
import Photos
import PhotosUI
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UICollectionViewDataSource{
    
    

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileCover: UIView!
    
    @IBOutlet weak var usernameLabel: UINavigationItem!
    
    private var pickedImage: UIImage?
    private var newAudio: Audio?
    private var audioFile: ParseFile? // means it can be null
    private var parseFileImg: ParseFile?
    public static var refereshData = false;
    private var userObbject: User?
    @IBOutlet weak var profilePosts: UICollectionView!
    
    var audioLists = [Audio](){
            didSet{
                // Reload table view data any
                // time the posts variable gets updated.
                
                    profilePosts.reloadData()
                
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePosts.dataSource = self
//        profilePosts.delegate = self
        let layout = profilePosts.collectionViewLayout as!
        UICollectionViewFlowLayout
        
        // The minimum spacing between adjacent cells
        //(left / right, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumInteritemSpacing = 0;
        
        // The minimum spacing between adjacent cells (top / bottom, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumLineSpacing = 20;
        
        // Set this to however many columns you want to show in the collection.
        let numberOfColumns: CGFloat = 3
        
        // Calculate the width each cell need to be to fit the number of columns, taking into account the spacing between cells.
        let width = (profilePosts.bounds.width - layout.minimumInteritemSpacing * (numberOfColumns - 1)) / numberOfColumns

        // Set the size that each tem/cell should display at
        layout.itemSize = CGSize(width: width, height: width)
        
        if let profileImgUrl = User.current?.profile?.url{
            let imageDataRequest = AF.request(profileImgUrl).responseImage{
                [weak self] response in
                
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.profilePhoto.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        queryPosts()

        profileCover.layer.cornerRadius = 12;
        profileCover.layer.masksToBounds = true;
        // Do any additional setup after loading the view.
        usernameLabel.title = User.current?.username
        if let firstName = User.current?.firstName,
            let lastName = User.current?.lastName{
            fullNameLabel.text = "\(firstName) \(lastName)"
        }else{
            return
        }
                
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if(ProfileViewController.refereshData && audioLists.count != 0){
            queryPosts();
            ProfileViewController.refereshData = false;
        }
        
        loadUserDetails()
    }
    
    func loadUserDetails() {
        let constraint: QueryConstraint = "objectId" == User.current!.objectId!
        let query = User.query(constraint)
        
        query.find{
            [weak self] result in
            
            switch result {
            case .success(let user):
                // Update local audioPosts property with fetched
                // posts
                DispatchQueue.main.async {
                    if let bioText = user[0].bio {
                        self?.bio.text = bioText
                    }
                    
                    if let imageFile = user[0].profile,
                       let imageUrl = imageFile.url {

                        // Use AlamofireImage helper to fetch remote image from URL
                        let imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                            switch response.result {
                            case .success(let image):
                                // Set image view image with fetched image
                                self?.profilePhoto.image = image
                            case .failure(let error):
                                print("❌ Error fetching image: \(error.localizedDescription)")
                                break
                            }
                        }
                    }
                }
                

            case .failure(let error):
                self?.showAlert(description:error.localizedDescription)
                //.localizedDescription turns
                // type error to a string
            }
        }
        
        //load following
        do {
            let constraint2: QueryConstraint = try "user" == User.current!
            let query2 = Followers.query(constraint2)
            
            
            query2.find{
                [weak self] result in
                
                switch result {
                case .success(let followers):
                    
                    DispatchQueue.main.async {
                        self?.followingCountLabel.text = "\(followers.count)"
                    }
                    
                    
                case .failure(let error):
                    self?.showAlert(description:error.localizedDescription)
                    
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        //load followers
        do {
            let constraint2: QueryConstraint = try "followinguser" == User.current!
            let query2 = Followers.query(constraint2)
            
            
            query2.find{
                [weak self] result in
                
                switch result {
                case .success(let followers):
                    
                    DispatchQueue.main.async {
                        self?.followersCountLabel.text = "\(followers.count)"
                    }
                    
                    
                case .failure(let error):
                    self?.showAlert(description:error.localizedDescription)
                    
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        //load posts
        do {
            let constraint2: QueryConstraint = try "user" == User.current!
            let query2 = Audio.query(constraint2)
            
            
            query2.find{
                [weak self] result in
                
                switch result {
                case .success(let posts):
                    
                    DispatchQueue.main.async {
                        self?.postsCountLabel.text = "\(posts.count)"
                    }
                    
                    
                case .failure(let error):
                    self?.showAlert(description:error.localizedDescription)
                    
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return audioLists.count
    }
    
    @IBAction func bUpdateBioClicked(_ sender: Any) {
        if let bioText = bio.text {
            if bioText.count > 0 {
                if var currentUser = User.current {
                    currentUser.bio =  bioText
                    
                    currentUser.save { [weak self] result in
                        switch result {
                        case .success(let user):
                            print("✅ User Updated! \(user)")

                            // Switch to the main thread for any UI updates
                            DispatchQueue.main.async {
                                // Return to previous view controller
                                
                            }

                        case .failure(let error):
                            self?.showAlert(description: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                // fill it with info the return the cell back
                // to the collection
                
                let profileCell = profilePosts.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
                // the index of the collection view we
                // want to show
                let audio = audioLists[indexPath.item]
        
                profileCell.configure(audioInfo: audio)
        
                return profileCell;
    }
    

    
    private func queryPosts(){
        
            let query = Audio.query().include("user")
                            .where("user" == User.current?.objectId)
            query.find{
                [weak self] result in
                
                switch result {
                case .success(let audio):
                    // Update local audioPosts property with fetched
                    // posts
                    DispatchQueue.main.async {
                        self?.audioLists = audio
                        
                        self?.postsCountLabel.text = "\(audio.count)"
                        self?.profilePosts.reloadData()
                    }
                    
    
                case .failure(let error):
                    self?.showAlert(description:error.localizedDescription)
                    //.localizedDescription turns
                    // type error to a string
                }
            }
        }
    
    
    
    @IBAction func onClickSelectImage(_ sender: Any) {
        if(PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized) {
        // request for access to photo library
            
            // after function call there is a nameless func
            // (closure that takes in the return off the
            // function call as status in the nameless
            // ffunction.
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {
              [weak self] status in
                
                switch status {
                case .authorized:
                    // if user authorised show picker(on main thread)
                    DispatchQueue.main.async {
                        self?.presentImagePicker()
                    }
                default:
                    // show settings alert (on main thread)
                    DispatchQueue.main.async {
                        //Helper metod to sow setting alert
                        self?.presentGoToSettingsAlert()
                    }
                }
            }
        } else {
            // show photo picker
            presentImagePicker()
        }
        
    }
    
    private func presentImagePicker(){
        
        // Create a configuration object
        var config = PHPickerConfiguration();
        
        // set the filters to only show
        // images as option (i.e. no videos, etc.).
        config.filter = .images
        
        // Request the original file format.
        // Fastest method as it avoids transcoding
        config.preferredAssetRepresentationMode = .current
        
        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1
        
        // Instantiate a picker, passing in the
        // configuration.
        let picker = PHPickerViewController(configuration: config)
        
        // set the picker delegate so we can receive
        // whatever image the user picks.
        // (Means who is going to handel the picking
        // of images?)
        picker.delegate = self;
        
        
        
        // Present the picker
        present(picker, animated: true)
    }
    
    func presentGoToSettingsAlert() {
        let alertController = UIAlertController (
            title: "Photo Access Required",
            message: "In order to add photos to your audio posts, we need access to your photo library. You can allow access in Settings.",
            preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

//

// extention to help our view conntroller handel
// picking a picture.
extension ProfileViewController: PHPickerViewControllerDelegate{
    // what to do after picking a photo
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // Dismiss the picker
        picker.dismiss(animated: true)
        
        // Make sure we have a non-nil item
        // provider
        guard let provider = results.first?.itemProvider,
            // Make sure the provider can load the UIImage
              provider.canLoadObject(ofClass: UIImage.self)
        else {return}
        
        // load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) {
            [weak self] object, error in
            
            // Make sure we can cast the retured object to a
            // UIImage
            guard let image = object as? UIImage else {
                // ❌ Unable to cast to UIImag
                self?.showAlert()
                return
            }
            
            //check for and handle any errors
            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            }
            else {
                
                // UI update (like setting image on image view)
                // should be done on main thread
                DispatchQueue.main.async {
                    // set image on preview image view
                    self?.profilePhoto.image = image
                    
                    // set image to use when saving post
                    self?.pickedImage = image
                    
                    
                    // ========= Turning Image to parsefile
                    
                    //Unwrap optional pickedImage
                    guard let image = self?.pickedImage,
                          // Create and compress image data (jpeg) from UIImage
                          let imageData = image.jpegData(compressionQuality: 0.1)
                    else {
                        return
                    }
                    
                    // Create a Parse File by providing a name and
                    // passing in the image data('to binary data')
                    self?.parseFileImg = ParseFile(name:"profile.jpg", data: imageData)
                    
                    if var currentUser = User.current {
                        currentUser.profile =  self?.parseFileImg
                        
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Updated! \(user)")

                                // Switch to the main thread for any UI updates
                                DispatchQueue.main.async {
                                    // Return to previous view controller
                                    
                                }

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }
                    
                    //================================
                }
            }
        }
    }
    
    func restUIElements(){
        profilePhoto.image = UIImage(named: "emptyImage");
    }
    
    
}
