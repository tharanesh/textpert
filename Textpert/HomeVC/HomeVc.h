//
//  HomeVc.h
//  TextPert
//
//  Created by elicit on 13/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface HomeVc : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *profilePic;
 @property(nonatomic,strong) IBOutlet UIBarButtonItem *barBtnItem;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UIButton *sidebtn;
@property (strong, nonatomic) IBOutlet UIButton *btnResponse;
@property (strong, nonatomic) NSString *userName;
@end
