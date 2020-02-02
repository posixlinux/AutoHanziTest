//
//  ViewController.swift
//  AutoHanziTest
//
//  Created by Ghost on 2020/02/02.
//  Copyright © 2020 autogroup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var hanziLabel: UILabel!
    @IBOutlet private weak var answerButton: UIButton!
    @IBOutlet private weak var meaningLabel: UILabel!
    @IBOutlet private weak var exampleLabel: UILabel!
    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet private weak var shuffleButton: UIButton!
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    private let interactor: HanziInteractor = HanziInteractor()
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.prevButton.isEnabled = false
        self.prevButton.isEnabled = false
        
        self.interactor.updateBlock = { [unowned self] in
            guard let hanzi: Hanzi = self.interactor.get(self.currentIndex) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.update(hanzi)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.interactor.fetchAll()
    }
    
    private func update(_ hanzi: Hanzi) {
        self.answerButton.isHidden = false
        
        self.hanziLabel.text = hanzi.word
        self.meaningLabel.text = hanzi.meanings.first?.desc
        self.exampleLabel.text = hanzi.meanings.first?.example
        self.explanationLabel.text = hanzi.meanings.first?.explanation
        
        self.prevButton.isEnabled = true
        self.nextButton.isEnabled = true
        
        if self.currentIndex == 0 {
            self.prevButton.isEnabled = false
        }
        
        if self.currentIndex == self.interactor.totalCount {
            self.nextButton.isEnabled = false
        }
    }
    
    @IBAction func tapPrevButton(_ sender: Any) {
        self.currentIndex = self.currentIndex - 1
        
        guard let hanzi: Hanzi = self.interactor.get(self.currentIndex) else {
            self.currentIndex = self.currentIndex + 1
            return
        }
        self.update(hanzi)
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        self.currentIndex = self.currentIndex + 1
        
        guard let hanzi: Hanzi = self.interactor.get(self.currentIndex) else {
            self.currentIndex = self.currentIndex - 1
            return
        }
        self.update(hanzi)
    }
    
    @IBAction func tapAnswerButton(_ sender: Any) {
        self.answerButton.isHidden = true
    }
    
    @IBAction func tapShuffleButton(_ sender: Any) {
        self.currentIndex = 0
        self.interactor.shuffle()
    }
}
