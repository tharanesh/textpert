//
//  ProfileEditVC.h
//  TextPert
//
//  Created by elicit on 21/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileEditVC : UIViewController

- (IBAction)didClickSave:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@end
