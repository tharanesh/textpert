//
//  ResponseView.h
//  Textpert
//
//  Created by elicit on 02/05/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *txtResponse;
@property (strong, nonatomic) IBOutlet UIButton *btnCopy;
@property (strong, nonatomic) IBOutlet UILabel *textpertname;
@property (strong, nonatomic) IBOutlet UIButton *star1;
@property (strong, nonatomic) IBOutlet UIButton *star2;
@property (strong, nonatomic) IBOutlet UIButton *star3;
@property (strong, nonatomic) IBOutlet UIButton *star4;
@property (strong, nonatomic) IBOutlet UIButton *star5;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property BOOL isRate;
@end

@interface ResponseView : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *responseCount;
@property (strong, nonatomic) IBOutlet UILabel *lblUser;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end
