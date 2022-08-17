//
//  LinkShortyViewController.swift
//  linkShorty
//
//  Created by Amin  Bagheri  on 2022-08-13.
//

import UIKit

class LinkShortyViewController: UIViewController, UITextFieldDelegate {
    
    let realmManager = RealmManager.shared
    
    var shortenedLink: String? = ""
    var webService = WebService.shared
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loading: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = .gray
        loader.layer.masksToBounds = false
        loader.layer.shadowColor = UIColor.black.cgColor
        loader.layer.shadowOpacity = 0.2
        loader.layer.shadowOffset = .zero
        loader.layer.shadowRadius = 1
        loader.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loader.style = .whiteLarge
        loader.layer.cornerRadius = 20
        return loader
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    private let enterUrlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter your URL:"
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private let yourShortenedLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Shortened Link"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "text")
        return label
    }()
    
    private let tapToCopy: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "(Tap your link to copy)"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        
        return label
    }()
    
    private let linkButton: UIButton = {
        let link = UIButton()
        link.translatesAutoresizingMaskIntoConstraints = false
        link.setTitle("", for: .normal)
        link.setTitleColor(UIColor.blue, for: .normal)
        link.contentHorizontalAlignment = .center
        link.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        return link
    }()
    
    @objc func copyLink(sender: UIButton!) {
        print("Link tapped")
        
            UIPasteboard.general.string = shortenedLink
        let alertController = UIAlertController(title: "Copied Link!", message: "You can now paste it anywhere as needed.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Great!", style: .cancel)
        alertController.addAction(ok)
        present(alertController, animated: true)
        loading.stopAnimating()
        
    }
    
    private let enterUrlTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .systemBackground
        tf.layer.cornerRadius = 8
        tf.placeholder = "Enter URL here..."
        tf.setLeftPaddingPoints(10)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let submitUrlButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = 10
        button.setTitle("Shorten", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func buttonAction(sender: UIButton!) {
        loading.startAnimating()

        if let text = enterUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            Task {
                do {
                    let url = try await webService.getURL(userUrl: text)
                    if url == nil {
                        showFailureAlert()
                        loading.stopAnimating()
                    } else {
                        if url?.url?.shortLink != nil {
                            print(url!.url!.shortLink!)
                            linkButton.setTitle(url!.url!.shortLink!, for: .normal)
                            shortenedLink = url!.url!.shortLink!
                            //Add task to realm
                            realmManager.addLink(longLink: url!.url!.fullLink!, shortLink: url!.url!.shortLink!)
                        }
                        loading.stopAnimating()
                    }
                } catch {
                    print("Failed to get url")
                    showFailureAlert()
                    loading.stopAnimating()
                }
            }
        } else {
            print("Please enter a url")
            let alertController = UIAlertController(title: "Please enter a valid url", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(ok)
            present(alertController, animated: true)
            loading.stopAnimating()


        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(scrollStackViewContainer)
        view.addSubview(loading)
        view.bringSubviewToFront(topView)
        self.title = "Link Shorty"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupScrollView()
        configureContainerView()
        setupTopViewSubviews()
        setupBottomViews()
        self.enterUrlTextField.delegate = self
        view.bringSubviewToFront(loading)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showFailureAlert() {
        let alertController = UIAlertController(title: "Failed to create link", message: "Please check that your link is valid, and that you have a wifi connecion", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    private func setupScrollView() {
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        //dont do these two, because this tells the stack view to stretch the views to leading and trailing.
        //stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollStackViewContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
        configureContainerView()
    }
    private func configureContainerView() {
        // MARK: Add subviews to the scroll stack container!
        scrollStackViewContainer.addArrangedSubview(topView)
        topView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        topView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        
        scrollStackViewContainer.addArrangedSubview(bottomView)
        
        bottomView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.45).isActive = true
        
    }
    
    private func setupTopViewSubviews() {
        topView.addSubview(enterUrlLabel)
        topView.addSubview(submitUrlButton)
        topView.addSubview(enterUrlTextField)
        
        enterUrlLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        
        enterUrlTextField.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        enterUrlTextField.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        enterUrlTextField.topAnchor.constraint(equalTo: enterUrlLabel.bottomAnchor, constant: 30).isActive = true
        enterUrlTextField.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.8).isActive = true
        enterUrlTextField.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.13).isActive = true
        
        submitUrlButton.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        submitUrlButton.topAnchor.constraint(equalTo: enterUrlTextField.bottomAnchor, constant: 30).isActive = true
        submitUrlButton.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.5).isActive = true
        submitUrlButton.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.1).isActive = true
        
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    private func setupBottomViews() {
        bottomView.addSubview(yourShortenedLinkLabel)
        bottomView.addSubview(linkButton)
        bottomView.addSubview(tapToCopy)
        
        yourShortenedLinkLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        yourShortenedLinkLabel.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.8).isActive = true
        yourShortenedLinkLabel.textAlignment = .center
        
        tapToCopy.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        tapToCopy.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        tapToCopy.topAnchor.constraint(equalTo: yourShortenedLinkLabel.topAnchor, constant: 25).isActive = true
        tapToCopy.widthAnchor.constraint(equalTo: bottomView.widthAnchor).isActive = true
        tapToCopy.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        linkButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        linkButton.topAnchor.constraint(equalTo: tapToCopy.bottomAnchor, constant: 0).isActive = true
        linkButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor).isActive = true
        linkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}



