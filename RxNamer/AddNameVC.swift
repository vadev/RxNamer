//
//  AddNameVC.swift
//  RxNamer
//
//  Created by Vartan on 6/2/18.
//  Copyright © 2018 Vartan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var newNameTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    // Create a instance for publish subject
    let nameSubject = PublishSubject<String>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubmitBtn()
        
        
    }
    
    // Binding our SubmitBtn
    func bindSubmitBtn() {
        
        submitBtn.rx.tap.subscribe(onNext: {
            // preventing from passing in blank names.
            if self.newNameTxtField.text != "" {
                self.nameSubject.onNext(self.newNameTxtField.text!)
                
            }
            
        })
            .addDisposableTo(disposeBag)
    }
    
    
    
}
