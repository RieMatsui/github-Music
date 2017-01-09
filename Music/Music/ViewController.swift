//
//  ViewController.swift
//  Music
//
//  Created by 松井 里衣 on 2017/01/07.
//  Copyright © 2017年 松井　里衣. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ViewController: UIViewController, AVAudioPlayerDelegate{
	
	@IBOutlet weak var slSwichMusic: UISwitch!
	@IBOutlet weak var imgvMusic: UIImageView!
	@IBOutlet weak var slMusicSize: UISlider!
	@IBOutlet weak var lbTime: UILabel!
	
	@IBOutlet weak var lbStart: UILabel!
	@IBOutlet weak var lbRate: UILabel!

	//タイマーを追加
	var timer = Timer()

	//フィールドを作成、AVAudioPlayerオブジェクト
	var Music01:AVAudioPlayer!

	// MARK: - オーバーライドメソッド

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		//ファイルパスを指定
		/// Users/matsuirie/Documents/Xcode/Music/Music/YouAreTheUniverseBrandNewHeavies.mp3
		
//		//起動時に再生
//		let bnd = Bundle.main
//		let url01 = bnd.url(forResource: "YouAreTheUniverseBrandNewHeavies", withExtension: "mp3")!
//		
//		//AVAudioPlayerオブジェクト生成
//		Music01 = try? AVAudioPlayer(contentsOf:url01)
//		
//		//再生準備
//		Music01.prepareToPlay()
//		
//		//再生処理
//		Music01.play()
		
		initMusic()
		imgvMusic.layer.masksToBounds = true
		imgvMusic.layer.cornerRadius = 40.0
		
		lbStart.layer.masksToBounds = true
		lbStart.layer.cornerRadius = 10.0
		
		lbRate.layer.masksToBounds = true
		lbRate.layer.cornerRadius = 10.0
		
		lbTime.layer.masksToBounds = true
		lbTime.layer.cornerRadius = 10.0


	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - デリゲート・メソッド
	
	//音楽の再生完了
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		
		//スイッチをオフにする

		slSwichMusic.isOn = false
		animateEnd(target: imgvMusic, key: "Move")
		
	}
	
	// MARK: - アクション・メソッド
	
	//音楽を再生するスイッチを作成
	@IBAction func playSwitch(_ sender: UISwitch) {
		NSLog("\(sender.isOn)")
		
//		let bnd = Bundle.main
//		let url01 = bnd.url(forResource: "YouAreTheUniverseBrandNewHeavies", withExtension: "mp3")!
//		
//		//AVAudioPlayerオブジェクト生成
//		Music01 = try? AVAudioPlayer(contentsOf:url01)
//		
//		//再生準備
//		Music01.prepareToPlay()
		
		
		//
		//Music01.currentTime = Music01.duration - 0.5
		
		//再生
		if sender.isOn == true {
			Music01.play()
		
		//アニメーション開始の処理
		animateStart(target: imgvMusic, key: "Move")
		
		//タイマーを設定
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePlayingTime), userInfo: nil, repeats: true)
		}
		
	    //停止
		else{
			
			//タイマーをストップ
			timer.invalidate()
			
			Music01.stop()
			lbTime.text = "0:00"
			
			
			
		//アニメーション停止処理
			Music01.prepareToPlay()
			Music01.currentTime = 0.0
		    slMusicSize.value = 0.0
			animateEnd(target: imgvMusic, key: "Move")
		}
	}
	
	//再生速度の変化
	@IBAction func changeRate(_ sender: UISlider){
		
		NSLog("\(sender.value)")
		
		//再生速度の設定(0.0~2.0)
		
		Music01.rate = sender.value
	
	}
	
	//再生場所変更
	@IBAction func musicSizeChange(_ sender: UISlider) {
		
		//スライドするたびに再生場所を変更
		Music01.currentTime = TimeInterval(sender.value)
		
		//タイマーをsliderに設定
		self.updatePlayingTime()

		
	}
	
	// MARK: - オリジナル・メソッド
	
	//再生準備のメソッドを作成,初期化処理
	func initMusic() {
		
		let bnd = Bundle.main
		let url01 = bnd.url(forResource: "YouAreTheUniverseBrandNewHeavies", withExtension: "mp3")!
		
		//AVAudioPlayerオブジェクト生成
		Music01 = try? AVAudioPlayer(contentsOf:url01)
		
		//設定（再生速度の変更許可）
		Music01.enableRate = true
		
		//設定（デリゲート）
		Music01.delegate = self
		
		//再生準備
		Music01.prepareToPlay()
		
		//タイマーを割り当てる

		
	}
	
	// MARK: - オリジナルメソッド（アニメーション）
	
	// アニメーション開始
	func animateStart(target: UIView, key: String!) {
		
		// 設定（種類（Z軸回転））
		let ani = CABasicAnimation(keyPath: "transform.rotation.z")
		
		// 設定（変化値（ラジアン角））
		ani.fromValue = 0.0			// 0°
		ani.toValue   = 2.0 * M_PI	// 360°
		
		// 設定（アニメーション時間（秒））
		ani.duration = 2.0
		
		// 設定（繰返し回数）
		ani.repeatCount = HUGE		// 無限
		
		// アニメーション開始
		target.layer.add(ani, forKey: key)
	}
	
	// アニメーション停止
	func animateEnd(target: UIView, key: String!) {
		
		// アニメーション削除
		target.layer.removeAnimation(forKey: key)
	}
	
	func updatePlayingTime() {
		slMusicSize.value = Float(Music01.currentTime)
		
		let str = Music01.currentTime
		let str02 = floor(str)
		let str03 = Int(str02)
		let str04 = str03 % 60
		let str05 = str03 / 60
		
		if str04 < 10 {
			lbTime.text = String("\(str05)" + ":" +  "0\(str04)")
		}
			
		else{
			lbTime.text = String("\(str05)" + ":" +  "\(str04)")
		}
		
	}

	

}

