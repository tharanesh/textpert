//
//  HomeVc.m
//  TextPert
//
//  Created by elicit on 13/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "HomeVc.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "RequestFromUserVC.h"
//#import <Pushbots/Pushbots.h>

@interface HomeVc ()<UIImagePickerControllerDelegate>
{
    UIView *view;
    IBOutlet UILabel *lbl_response;
    NSString *userMode;
}
@end

@implementation HomeVc
- (IBAction)didClickresponse:(id)sender {
    
    if([userMode isEqualToString:@"1"])
    {
        [view removeFromSuperview];
        [AppDelegate clearbadgeCount];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RequestFromUserVC *myVC = (RequestFromUserVC*)[storyboard instantiateViewControllerWithIdentifier:@"UserRequest"];
       
        [self.navigationController pushViewController:myVC animated:YES];
       // [self performSegueWithIdentifier:@"RequestSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ResponseSegue" sender:self];
    }
    
     //[[Pushbots sharedInstance] clearBadgeCount];
    
    // [self.btnResponse removeFromSuperview:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textPertChecking];
    
    [self.navigationController setNavigationBarHidden:YES];
 
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
        
    {
        [_sidebtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    NSString *username = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userName"];
    _lblUsername.text = username;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.layer.cornerRadius=65.0;
    self.profilePic.layer.borderWidth=2;
    self.profilePic.layer.borderColor=[UIColor blackColor].CGColor;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    if (img != nil) {
        [_profilePic setBackgroundImage:img  forState:UIControlStateNormal];
    }
}

-(void)textPertChecking
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"uid"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"textpertStatus",@"todo",uid,@"fb_id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:@"http://businessofimagination.com/textpert/user.php"  parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dict=responseObject;
        NSArray *arr=[dict valueForKey:@"0"];
         userMode=[arr valueForKey:@"textpert_mode"];
        if([userMode isEqualToString:@"1"])
        {
            [_btnResponse setBackgroundImage:[UIImage imageNamed:@"RequestsIcon.png"] forState:UIControlStateNormal];
            lbl_response.text=@"REQUEST";
            NSString *badgeCount=[[NSUserDefaults standardUserDefaults] objectForKey:@"badge"];
            if([badgeCount isEqualToString:@"0"]||badgeCount==nil)
            {
                NSLog(@"No badge");
            }
            else
            {
                CustomBadge *badge = [CustomBadge customBadgeWithString:badgeCount];
                view=[[UIView alloc] initWithFrame:CGRectMake(self.btnResponse.frame.size.width - badge.frame.size.width,2,badge.frame.size.width, badge.frame.size.height)];
                // position the UIImageView at the top right hand side of the button
                
                [view addSubview:badge];
                [self.btnResponse addSubview:view];
            }
        }
        else
        {
            [_btnResponse setBackgroundImage:[UIImage imageNamed:@"respondButton.png"] forState:UIControlStateNormal];
            lbl_response.text=@"RESPONSE";
        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
