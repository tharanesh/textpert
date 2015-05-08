//
//  RespondToUser.h
//  Textpert
//
//  Created by elicit on 02/05/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RespondToUser : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblname;
@property (strong, nonatomic) IBOutlet UIImageView *imgChat;
@property(nonatomic,strong) NSDictionary *datas;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
- (IBAction)didClickrespond:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSendResponse;
@property (strong, nonatomic) IBOutlet UITextView *txtResponse;
@end
