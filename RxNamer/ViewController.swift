//
//  ViewController.swift
//  RxNamer
//
//  Created by Vartan Arzumanyan on 6/2/18.
//  Copyright © 2018 Vartan Arzumanyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var nameEntryTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var namesLbl: UILabel!
    @IBOutlet weak var addnameBtn: UIButton!
    
    // Instantiate disposeBag.
    let disposeBag = DisposeBag()
    
    //Create a names array that is an array of type String.
    var namesArray: Variable<[String]> = Variable([])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
        bindAddNameButton()
        
        // Casting out when in AddNameVC we add a name it should display in our main VC.
        namesArray.asObservable().subscribe(onNext: { names in
            // set up the namesLbl.
            self.namesLbl.text = names.joined(separator: ", ")
            
        })
            .addDisposableTo(disposeBag)
        
    }
    
    //binding our value to our substring.
    func bindTextField() {
        nameEntryTxtField.rx.text
            // .debounce - this is good for if I am using an api, this can prevent API spamming.
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map {
                if $0 == "" {
                    return "Type your name below."
                } else {
                    return "Hello, \($0!)."
                }
                
            }
            .bind(to: helloLbl.rx.text)
            .addDisposableTo(disposeBag)
        
    }
    
    //binding our submit button.
    // ** RXSwift is so cool that I don't need to add a submit button ibaction.
    // ** RXSwift handles my submit button as a action.
    
    func bindSubmitButton() {
        
        submitBtn.rx.tap.subscribe(onNext: {
            
            // when submit button is tapped, we want to add it to our
            // name array and then display it to the user.
            if self.nameEntryTxtField.text != "" {
                // *TIP*: We cant use append like we do it to an array,
                // *We cant use append on a variable type.
                self.namesArray.value.append(self.nameEntryTxtField.text!)
                //calling our onNext property to display the names.
                // update the namesLbl with a separator
                self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                //clear out text field - so a new one name can be added.
                self.nameEntryTxtField.rx.text.onNext("")
                // clear out our helloLbl.
                self.helloLbl.rx.text.onNext("Type your name below.")
            }
            // if we are subscribing then we want to add it to the disposable.
        })
            .addDisposableTo(disposeBag)
        
        
        
    }
    
    // Binding our add name button to our AddNameVC.
    func bindAddNameButton() {
        // .throttle will prevent from us from putting too many inputs.
        addnameBtn.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            // then call subscribe when the button is pressed.
            .subscribe(onNext: {
                // create a instance of AddNameVC.
                guard let addNameVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNameVC") as? AddNameVC else { fatalError("Could not create a AddNameVC")  }
                //Now, access our nameSubject over in AddNameVC
                addNameVC.nameSubject.subscribe(onNext: { name in
                    self.namesArray.value.append(name)
                    addNameVC.dismiss(animated: true, completion: nil)
                }).addDisposableTo(self.disposeBag)
                self.present(addNameVC, animated: true, completion: nil)
            })
        
        
        
        
    }
    
    
    
    
    
    
    
}

