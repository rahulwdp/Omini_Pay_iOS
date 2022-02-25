//
//  OminiPay.swift
//  OminiPay
//
//  Created by wdp mac on 24/02/22.
//

import Foundation
import UIKit

public protocol OminiResponseDelegate {
    func paymentDoneWith(success:Bool, data:[String:Any]?)
}

public class OminiPay: NSObject {
        
    static var key:String?
    static let obj = OminiPay()
    
    public var delegate : OminiResponseDelegate?
    
    //MARK:Initialize
    public static func initWith(key:String) -> OminiPay {
        self.key = key
        return obj
    }
    
    public func checkOutRequestWith(_ param: [String:Any]){
        let bundle = Bundle(for: Checkout.self)
        let vc = Checkout(nibName: "Checkout", bundle: bundle)
        vc.key = OminiPay.key
        vc.param = param
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            
            rootVC.present(vc, animated: true, completion: nil)
        }
    }
}

extension OminiPay : CheckoutDelegate {
    func errorWhileProcessingRequest(_ error: String, _ status_code: Int, vc: UIViewController) {
        vc.dismiss(animated: true) {
            self.delegate?.paymentDoneWith(success: false, data: ["error":error,"status_code":status_code])
        }
    }
    
    func paymentResult(_ isSuccess: Bool, result: [String : Any]?, vc: UIViewController) {
        vc.dismiss(animated: true) {
            self.delegate?.paymentDoneWith(success: isSuccess, data: result)
        }
    }
}


