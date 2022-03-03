# Omini_Pay_iOS

# OMINI PAY
Easy Safe and Secure Payment gatway 

This repository implements pod for OminiPay’s iOS Framework.

# Usage
To run the example project, clone the repo, and run pod install from the Example directory first. Or you can simply download the project and install pods and run project.

# Installation | Docs
Through  Cocoa pods

```sh
pod ‘OminiPay’
```
# Manual

Drag n Drop the  ‘**Framework**’  folder into your project.

**Note**: If you will face any error , you can simply go to  Build Settings set **Enable Bitcode** to **NO**


# How to Use

View controller where you want to set payment import OminiPay library like below:

```sh
import OminiPay
```

# Create OminiPay Object

```sh
let obj = OminiPay.initWith(key: “Your OminiPa’sy Account key”)
```

# Set Delegate to view controller

obj.delegate = self

# Call CheckoutMethod

```sh
 obj.checkOutRequestWith(param)
```

**Note:** param is the variable in which you set your card details:

## Parameter Sample Formate

```sh
let param = [
    "name" : "John",
    "email" : "johndoe@mailinator.com",
    "amount" : "100.0",
    "currency" : "SAR",
    "order_id" : "123",
    "card_number" : "5151515151515151",
    "exp_month" : "12",
    "exp_year" : "26",
    "cvv" : "123",
    "card_type" : "C"
]
```

# Add Delegate methods to ViewControlelr
```sh
 func paymentDoneWith(success: Bool, data: [String : Any]?)
 ```

# Example
```sh
extension ViewController : OminiResponseDelegate {
    func paymentDoneWith(success: Bool, data: [String : Any]?) {
        if success {
               //Success Block
        }else{
		//Failure
        }
    }
}
```



