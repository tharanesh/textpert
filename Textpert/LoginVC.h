//
//  ViewController.h
//  TextPert
//
//  Created by elicit on 13/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

@interface LoginVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet FBLoginView *loginBtn;

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollviewConstraint;
@property (strong, nonatomic) NSData *deviceToken;
@end

