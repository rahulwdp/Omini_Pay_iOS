# Omini_Pay_iOS

# OMINI PAY
Easy Safe and Secure Payment gatway 

This repository implements pod for OminiPay’s iOS Framework.

# Usage
To run the example project, clone the repo, and run pod install from the Example directory first. Or you can simply download the project and install pods and run project.

# Installation | Docs
Through  Cocoa pods

pod ‘OminiPay’

# Manual

Drag n Drop the  ‘**Framework**’  folder into your project.

**Note**: If you will face any error , you can simply go to  Build Settings set **Enable Bitcode** to **NO**


# How to Use

View controller where you want to set payment import OminiPay library like below:

import OminiPay

# Create OminiPay Object

let obj = OminiPay.initWith(key: “Your OminiPa’sy Account key”)

# Set Delegate to view controller

obj.delegate = self

# Call CheckoutMethod

 obj.checkOutRequestWith(param)

**Note:** param is the variable in which you set your card details:

## Parameter Sample Formate

["customer":["name”:”XYZ”, ”email”:”xyz@mailinator.com"],
         "order":["amount":"10.00","currency":"SAR","id":"420"],
         "sourceOfFunds":["provided":
                            ["card":
                                ["number":"5105105105105100",
                                 "expiry":["month":"12","year":"23"],
                                 "cvv":"999"
                                ]
                            ],
                          "cardType":"C"
         ],
         "remark":["description":"This payment is done by card iOS”]
        ]

# Add Delegate methods to ViewControlelr

 func paymentDoneWith(success: Bool, data: [String : Any]?)

# Example

extension ViewController : OminiResponseDelegate {
    func paymentDoneWith(success: Bool, data: [String : Any]?) {
        if success {
               //Success Block
        }else{
		//Failure
        }
    }
}



