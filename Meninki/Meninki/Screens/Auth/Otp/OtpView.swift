//
//  OtpView.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class OtpView: BaseView {
    
    var scrollView = ScrollView(spacing: 10,
                                edgeInsets: UIEdgeInsets(top: 150, left: 40, bottom: 40, right: 40),
                                keyboardDismissMode: .interactive)
    
    var desc = UILabel(font: .lil_14,
                       color: .contrast,
                       alignment: .left,
                       numOfLines: 0,
                       text: "enter_code_sent_to_number".localized())
    
    var phone = UILabel(font: .lil_14_b,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "+" + (AccUserDefaults.phone ?? ""))
    
    var otpField = OneTimeCodeTextField()
    
    var timerResendWrapper = UIStackView(axis: .vertical,
                                         alignment: .leading,
                                         spacing: 0)
    
    var resenBtn = TextBtn(title: "resend_otp".localized())
    
    var timerText = UILabel(font: .regular(size: 14),
                            color: .oldCaption,
                            alignment: .left,
                            numOfLines: 0,
                            text: "resend_after".localized()+"1:00")
        
    var privacy = UILabel(font: .lil_14,
                          color: .oldCaption,
                          alignment: .center,
                          numOfLines: 0,
                          text: "privacy_terms".localized())

    var timer: Timer?
    var remainingTime = 60
    var timerStopped = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContent()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])

        scrollView.contentStack.easy.layout(
            Height(DeviceDimensions.safeAreaHeight)
        )
    }
    
    func setupContent(){
        scrollView.contentStack.addArrangedSubviews([desc,
                                                     phone,
                                                     otpField,
                                                     timerResendWrapper,
                                                     UIView(),
                                                     privacy])
        
        scrollView.contentStack.setCustomSpacing(4, after: desc)
        scrollView.contentStack.setCustomSpacing(40, after: phone)
        scrollView.contentStack.setCustomSpacing(20, after: otpField)
        
        timerResendWrapper.addArrangedSubviews([resenBtn,
                                                timerText])
        
        otpField.configure()
        otpField.resignFirstResponder()
    }
    
    func startTimer() {
        resenBtn.isHidden = true
        timerText.isHidden = false
        remainingTime = 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timerStopped = true
    }
    
    func resumeTimer(){
        timerStopped = false
    }
    
    func timerFinished() {
        timer?.invalidate()
        resenBtn.isHidden = false
        timerText.isHidden = true
    }
    
    @objc func countDown() {
        self.remainingTime -= 1
        timerText.text = "resend_after".localized()
                            + " 00:\(remainingTime > 10 ? "\(remainingTime)" : "0\(remainingTime)")"
        
        if (self.remainingTime < 1) {
            timerFinished()
        }
    }
}
