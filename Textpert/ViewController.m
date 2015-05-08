//
//  ViewController.m
//  Textpert
//
//  Created by KAFOOR on 30/4/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *login;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _login.delegate=self;
    _login.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
