//
//  Checkout.swift
//  OminiPay
//
//  Created by wdp mac on 24/02/22.
//

import AVFoundation
import UIKit
import WebKit
import CommonCrypto

protocol CheckoutDelegate {
    func errorWhileProcessingRequest(_ error:String,_ status_code:Int,vc:UIViewController)
    func paymentResult(_ isSuccess:Bool,result:[String:Any]?,vc:UIViewController)
}

class Checkout: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIindicator: UIActivityIndicatorView!
    @IBOutlet weak var paymentProcessingView: UIView!
    
    fileprivate let username = "psp_test.sgkvcacb.c2drdmNhY2I2YTc3MA=="
    fileprivate let password = "b3pFSnVJb3V3SW5QTnFneVRFSy9wQT09"
    var delegate:CheckoutDelegate?
    
    var key:String?
    var param:[String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard param != nil else{
            self.delegate?.errorWhileProcessingRequest("Invalid parameters.",400, vc: self)
            return
        }
        hideWebView()
        webView.navigationDelegate = self
        activityIindicator.startAnimating()
        startProcessing(param: param!)
    }
    
    //MARk:startProcessing
    fileprivate func startProcessing(param:[String:Any]){
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let jsonString = getJsonString() else {
            self.delegate?.errorWhileProcessingRequest("Invalid parameters formate.",406, vc: self)
            return
        }
       
        //encryption keys
        let key256   = key!   // 32 bytes for AES256
        let iv       = "AGNNMLDKYPKEZDNK"
        
        //encryption
        let aes256 = AES(key: key256, iv: iv)
        let encParam = aes256?.encrypt(string: jsonString)
        guard encParam != nil else {
            self.delegate?.errorWhileProcessingRequest("Invalid parameters formate.",406, vc: self)
            return
        }
        let strParam = encParam!.hexEncodedString()
        
        //final parameters
        let dic:[String:String] = ["trandata": strParam]
        callApiForPayment(dic: dic,base64LoginString: base64LoginString)
    }
    
    
    //CallApi for actual payment
    fileprivate func callApiForPayment(dic:[String:String],base64LoginString:String){
       
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://psp.digitalworld.com.sa/api/v1/test/payments/pay")!
        
        // Convert model to JSON data
        guard let finalJson = try? JSONEncoder().encode(dic) else {
           self.delegate?.errorWhileProcessingRequest("Invalid parameters formate.",406, vc: self)
           return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
       // let paramData = try? JSONSerialization.data(withJSONObject: dic)
        
        request.httpBody = finalJson
    
            
        request.httpMethod = "PUT"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with:request) { data, response, error in

            // ensure there is no error for this HTTP response
            guard error == nil else {
               self.delegate?.errorWhileProcessingRequest("\(error!.localizedDescription)",204, vc: self)
               return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                self.delegate?.errorWhileProcessingRequest("No content.",204, vc: self)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                self.delegate?.errorWhileProcessingRequest("Invalid json.",406, vc: self)
                return
            }
            let result = json["apiResponse"] as! [String:Any]
            self.loadWebViewWith(result["verifyUrl"] as! String)
        }
        // execute the HTTP request
        task.resume()
    }
    
    
    private func getJsonString() -> String?{
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param!, options: []) else { return nil }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    //MARK:hideWebView
    private func hideWebView(){
        self.webView.isHidden = true
        self.paymentProcessingView.isHidden = false
    }
    
    private func hideLoaderView() {
        self.webView.isHidden = false
        self.paymentProcessingView.isHidden = true
    }
    
    
    func processingFinishWiith(url: String?) {
        if let urlStr = url {
            loadWebViewWith(urlStr);
        }else{
            activityIindicator.stopAnimating()
            print("Opps something went wrong")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARKk:web part
extension Checkout : WKNavigationDelegate {
    private func loadWebViewWith(_ urlStr:String){
        DispatchQueue.main.async {
            let url = URL(string: urlStr)!
            self.webView.load(URLRequest(url: url))
            self.webView.pageZoom = 1.0
            self.webView.allowsBackForwardNavigationGestures = true
            self.webView.addObserver(self, forKeyPath: "URL", options: .initial, context: nil)
            
            let bodyStyleVertical = "document.getElementsByTagName('body')[0].style.verticalAlign = 'middle';";
            self.webView.evaluateJavaScript(bodyStyleVertical, completionHandler: nil)
            
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.hideLoaderView()
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("---------\(String(describing: webView.url))")
            if keyPath == "URL" {
                if let url = webView.url {
                    print("current url = ",url)
                    let requestURL = url.absoluteString
                    print("URL:  \(requestURL)")
                    if let dic = url.queryDictionary {
                        if dic["status"] != nil{
                            let isApproved = (dic["payment_status"]!) == "APPROVED" ? true : false
                            self.delegate?.paymentResult((isApproved) ? true : false, result: ["txtID":((dic["txn_id"]) != nil) ? dic["txn_id"]! : "-", "payment_status":(isApproved) ? "Approved" : "Declined"], vc: self)
                            
                        }
                         
                        
                    }
                }
            }
        }
    
}



struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data


    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }


        self.key = keyData
        self.iv  = ivData
    }


    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }

    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}


private extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

private extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}

        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {

            let key = pair.components(separatedBy: "=")[0]

            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""

            queryStrings[key] = value
        }
        return queryStrings
    }
}
