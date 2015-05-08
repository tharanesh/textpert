//
//  RequestFromUserVC.h
//  Textpert
//
//  Created by elicit on 02/05/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestFromUserCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblname;
@property (strong, nonatomic) IBOutlet UILabel *lblExpery;

@end

@interface RequestFromUserVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *requestsCount;

@end
