//
//  SIWPViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2022/01/20.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit

final class SIWPViewController: UIViewController {

    @IBOutlet private weak var buttonView: UIView!

    @objc private func handleSignin() {
        appleAuthNonce = randomNonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        request.nonce = sha256!
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private lazy var signinButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(
            type: .default,
            style: UITraitCollection.isDarkMode ? .white : .black
        )
        button.addTarget(
            self,
            action: #selector(handleSignin),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 0, y: 0, width: 224, height: 40)
        return button
    }()

    var sha256: String? {
        guard let appleAuthNonce = appleAuthNonce else { return nil }
      let inputData = Data(appleAuthNonce.utf8)
      let hashedData = SHA256.hash(data: inputData)
      return hashedData
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }

    // nonce: AppleIDログインリクエストごとに生成するランダム数
    // Appleログイン処理によって取得したIDTokenが、認証リクエストへのResponseとして付与されたかどうか確認するために使用
    // リプレイ攻撃の防止
    var randomNonce: String {
      precondition(32 > 0)
      let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = 32
      while remainingLength > 0 {
        let randoms: [UInt8] = (0..<16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }
        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }
          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }
      return result
    }

    private var appleAuthNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView.addSubview(signinButton)
        signinButton.fitConstraintsContentView(view: buttonView)
    }
}

// MARK: ASAuthorizationControllerDelegate
extension SIWPViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let nonce = appleAuthNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idToken = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        // idTokenとnonceを用いてサーバにAuth情報を保存
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default)
        )
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding
extension SIWPViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
