//
//  HomeFeedViewController.swift
//  AudioSound
//
//  Created by Olisemedua Onwuatogwu on 4/21/23.
//

import UIKit
import ParseSwift
import AVFoundation

class HomeFeedViewController: UIViewController {
    var audioBox = AudioBox() // new sound player
    var activeCellIndex: Int?
    var activeCell: PostCell?
    private let refreshControl = UIRefreshControl() // instance of UIRefreshControl

    @IBOutlet weak var tableView: UITableView!
    
    private var audioPosts = [Audio](){
        didSet{
            // Reload table view data any
            // time the posts variable gets updated.
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quaryPosts()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = tableView.frame.height;
        
        tableView.refreshControl = refreshControl; // help with updown to refresh
        // Set the target and action for the refresh control
            refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioBox.audioPlayer?.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioBox.audioPlayer?.play()
        activeCell?.blur.alpha = 0 ; // reset the blure
    }
    
    
    private func quaryPosts(){
        let query = Audio.query().include("user")
        
        query.find{
            [weak self] result in
            
            switch result {
            case .success(let audio):
                // Update local audioPosts property with fetched
                // posts
                
                self?.audioPosts = audio.shuffled()
            case .failure(let error):
                self?.showAlert(description:error.localizedDescription)
                //.localizedDescription turns
                // type error to a string
            }
        }
    }
    
    @objc private func refreshPosts(){
        quaryPosts()
        
        // this is done automatically
        // if post list changes
        //tableView.reloadData();
        refereshAudioPlayer();
        
        // Call endRefreshing() when the refreshing operation is complete
            refreshControl.endRefreshing()
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension HomeFeedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioPosts.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: audioPosts[indexPath.row])
        
        return cell
    }

  
    // set the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height;
        // return tableView.bounds.height;
        
        }
}

extension HomeFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this just plays the first cell
        
        let cellFrame :CGRect
        let isCellFullyVisible : Bool
        
        
        
        // this will play the first cell
        if( indexPath.item == 0){
            
            cellFrame = tableView.rectForRow(at: indexPath )
            isCellFullyVisible = tableView.bounds.contains(cellFrame)
            
            if(isCellFullyVisible && activeCell == nil){
                
                if let audioUrl = (audioPosts[indexPath.item].audioFile?.url){
                    audioBox.play(fileurl:audioUrl);
                    activeCellIndex = indexPath.row;
                    
                    
                    guard let audioPlayer = audioBox.audioPlayer
                    else{
                        return
                    }
                    
                    
                    guard let cell = cell as? PostCell
                    else{
                        return
                    }
                    
                    cell.addProgressBarObserver(audioPlayer: audioPlayer)
                    activeCell = cell;
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Get the visible cells in the table view
        var cellFrame :CGRect
        var isCellFullyVisible : Bool
        
        // get cells we can currently see
        if let visibleCells = tableView.visibleCells as? [PostCell] {
            
            for cell in visibleCells {
                
                if let indexPath = tableView.indexPath(for: cell) {
                    
                    // we make sure its not the cell we are
                    // currently viewing
                    if(indexPath.row != activeCellIndex){
                        
                        // get the cell rectangle
                        cellFrame = tableView.rectForRow(at: indexPath )
                        
                        // we check if our table frame bounds contain
                        // the cell
                        isCellFullyVisible = isTbCellVisible(yOrginTableFrame: tableView.bounds.origin.y, yOriginnCellFrame: cellFrame.origin.y);
                        
                        if(isCellFullyVisible){
                            
                            guard let previousActiveCell = activeCell
                            else{
                                return
                            }
                            
                            guard let audioPlayer = audioBox.audioPlayer
                            else{
                                return
                            }
                            
                            // remove obsever from the previous active
                            // cell of type post cell
                            previousActiveCell.removeProgressBarObserver()
                            
                            // set the cell for future use
                            previousActiveCell.reset();
                            
                            if var audioUrl = (audioPosts[indexPath.item].audioFile?.url){
                                
                                audioBox.play(fileurl:audioUrl);
                                activeCellIndex = indexPath.row;
                                
                                // refresh the audio player
                                guard let audioPlayer = audioBox.audioPlayer
                                else{
                                    return
                                }
                                
                                // add observer to current cell
                                cell.addProgressBarObserver(audioPlayer: audioPlayer)
                                cell.progressBarAnimation();
                                // update the active cell
                                self.activeCell = cell;
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isTbCellVisible(yOrginTableFrame:CGFloat, yOriginnCellFrame:CGFloat)-> Bool{
        var tempFloat = yOrginTableFrame - yOriginnCellFrame;
        
        if(tempFloat < 0){
            tempFloat *= -1; // absolute value
        }
        
        if(tempFloat < 2){
            return true;
        }
        else{
            return false;
        }
    }
    
    func refereshAudioPlayer(){
        audioBox.audioPlayer?.pause()
        
        // This will allow the scrollViewDidScroll
        // function replay what ever audio we are
        // listening to
        activeCellIndex = -1;
    }
}



