//
//  ViewController.m
//  TextPert
//
//  Created by elicit on 13/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "LoginVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "SCLAlertView.h"
//#import "HomeVc.h"

@interface LoginVC ()<FBLoginViewDelegate>
{
    CGFloat height;
    NSDictionary *data;
    NSString *userName;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    _loginBtn.delegate=self;
  
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if([userId isEqualToString:@"new"] || userId ==nil)
    {
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            // Handle error
        }
        
        else {
            data=FBuser;
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
  
            NSString *lastName = [FBuser last_name];
            NSString *firstLetter = [lastName substringToIndex:1];
            firstLetter =[firstLetter uppercaseString];
            userName=[NSString stringWithFormat:@"%@ %@",[FBuser first_name],firstLetter];
           
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
            [self getImageFromURL:userImageURL];
            [self registerUserDetails];
           
        }
    }];
    
    NSString *valueToSave = @"Registered";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
         [self performSegueWithIdentifier:@"initialVC" sender:self];
    }
        //    self.profilePictureView.profileID = user.id;
    //    self.nameLabel.text = user.name;
    
}


-(void) getImageFromURL:(NSString *)fileURL {
        
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
        [imageData writeToFile:savedImagePath atomically:NO];
  }

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // self.statusLabel.text = @"You're logged in as";
    }
// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
  
}
-(void)registerUserDetails
{
    
    NSString *devToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"];
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   // NSString *name=[data valueForKey:@"name"];
    NSString *email=[data valueForKey:@"email"];
    NSString *fbid=[data valueForKey:@"id"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"addUser",@"todo",userName,@"name",email,@"email_id",fbid,@"fb_id",devToken,@"token",nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager POST:@"http://businessofimagination.com/textpert/user.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@",responseObject);
            NSArray *dict=responseObject;
            int uniqueId=[[dict valueForKey:@"success"] intValue];
            if(uniqueId ==1)
            {
                
                NSString *valueToSave = @"Registered";
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"status"];
                [[NSUserDefaults standardUserDefaults] setObject:fbid forKey:@"uid"];
//                [[NSUserDefaults standardUserDefaults] setObject:_txtUserName.text forKey:@"uname"];
//                [[NSUserDefaults standardUserDefaults] setObject:_txtEmail.text forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] synchronize];

             [self performSegueWithIdentifier:@"initialVC" sender:self];
            }
            else
            {
              //  [self alertFunc:@"Alert" message:@"Please Enter User Name  And Email Id"];

            }
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  
              }];
        

  }

-(void)alertFunc:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
