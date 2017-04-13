//
//  TestViewController.swift
//  RxSwiftTrial
//
//  Link your storyboard to this viewController
//
//  Created by Julien Saito on 3/20/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//


import UIKit

class TestViewController: UIViewController, TestView
{
    
    let testComponent = TestComponent()
    // MARK: - Injected
    var testPresenter: TestPresenter?

    // MARK: - View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        testComponent.inject(testView: self)
        
        titleLabel.text = "Test"
        loadButton.setTitle("Navigate to Login", for: .normal)
    }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    
    // MARK: - @IBOutlet @IBAction
    @IBAction func LoadClicked(_ sender: Any) {
        if let testPresenter = testPresenter {
            testPresenter.load()
        }

    }
    
    // MARK: - Display logic
    func displayMessage(Message : String) {
        print("Display \(Message)")
    }
    
    func showErrorDialog(ErrorMessage : String) {
        print("Display errort dialog : \(ErrorMessage)")
    }
    
    func showErrorMessage(ErrorMessage : String) {
        print("Show errort message : \(ErrorMessage)")
    }
    
    func navigateToLogin() {
        print("Navigating to Login")
        //performSegue(withIdentifier: "Login", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    func showLoading() {
        print("Something is loading, show the spinner")
    }

    func hideLoading() {
        print("Something finished loading, hide the spinner")
    }
}
