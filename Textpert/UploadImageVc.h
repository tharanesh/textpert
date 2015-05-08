//
//  UploadImageVc.h
//  TextPert
//
//  Created by elicit on 18/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadImageVc : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtExpirydateAndtime;
@property (strong, nonatomic) IBOutlet UIButton *sidebtn;
- (IBAction)didClickUpload:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtDuration;
@property (strong, nonatomic) IBOutlet UIButton *btnUpload;
@end
