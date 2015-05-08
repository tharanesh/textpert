//
//  TextPertModeVC.m
//  TextPert
//
//  Created by elicit on 21/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "TextPertModeVC.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface TextPertModeVC ()
{
    BOOL displayingFirstButton;
       NSString *textpert_mode;
}
@end

@implementation TextPertModeVC

- (void)viewDidLoad {
    [self textPertChecking];
//    NSString *tmode=[[NSUserDefaults standardUserDefaults] valueForKey:@"tmode"];
//    if(!displayingFirstButton)
//    {
//        [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OnButton.png"] forState:UIControlStateNormal];
//        _lblTextPertMode.text=@"Textpert Mode";
//    }
//    else
//    {
//        [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OffButton.png"] forState:UIControlStateNormal];
//        _lblTextPertMode.text=@"User Mode";
//    }

    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
        
    {
        [_sidebtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    
     [self textPertChecking];
//    NSString *tmode=[[NSUserDefaults standardUserDefaults] valueForKey:@"tmode"];
//    if(!displayingFirstButton)
//    {
//         [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OnButton.png"] forState:UIControlStateNormal];
//        _lblTextPertMode.text=@"Textpert Mode";
//    }
//    else
//    {
//         [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OffButton.png"] forState:UIControlStateNormal];
//        _lblTextPertMode.text=@"User Mode";
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickTextpertMode:(id)sender {
       [UIView transitionWithView:_btntextPertmode
                      duration:0.8
                       options:displayingFirstButton ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        //change image for button
                        
                        if(displayingFirstButton)
                        {
                            
                           displayingFirstButton=NO;
//                            
//                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tmode"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            
                            textpert_mode=@"1";
                            [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OnButton.png"] forState:UIControlStateNormal];
                             _lblTextPertMode.text=@"Textpert Mode";
                        }
                        else
                        {
                          
                            textpert_mode=@"0";
                            displayingFirstButton=YES;
//                            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tmode"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OffButton.png"] forState:UIControlStateNormal];
                            _lblTextPertMode.text=@"User Mode";

                        }
                    }
                    completion:^(BOOL finished) {
    
                    }];
//    if(_btntextPertmode.tag==10)
//    {
//        _btntextPertmode.tag=11;
//        [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OffButton.png"] forState:UIControlStateNormal];
//        userId=@"1";
//        _lblTextPertMode.text=@"IN ACTIVE";
//    }
//    else
//    {
//        _btntextPertmode.tag=10;
//        [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OffButton.png"] forState:UIControlStateNormal];
//        userId=@"0";
//        _lblTextPertMode.text=@"ACTIVE";
//    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"uid"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"updateTextpert",@"todo",textpert_mode,@" textpert_mode",uid,@"fb_id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:@"http://businessofimagination.com/textpert/user.php"  parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        /*  NSArray *dict=responseObject;
         int uniqueId=[[dict valueForKey:@"success"] intValue];
         if(uniqueId ==1)
         {
         NSString *valueToSave = @"Registered";
         [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"status"];
         [[NSUserDefaults standardUserDefaults] setObject:[dict valueForKey:@"id"] forKey:@"uid"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         //                NSString *savedValue = [[NSUserDefaults standardUserDefaults]
         //                                        stringForKey:@"preferenceName"];
         }*/
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
    
    
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
        NSString *str=[arr valueForKey:@"textpert_mode"];
        if([str isEqualToString:@"1"])
        {
            displayingFirstButton=NO;
            [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OnButton.png"] forState:UIControlStateNormal];
            _lblTextPertMode.text=@"Textpert Mode";
        }
        else
        {
            displayingFirstButton=YES;
            [_btntextPertmode setBackgroundImage:[UIImage imageNamed:@"OffButton.png"] forState:UIControlStateNormal];
            _lblTextPertMode.text=@"User Mode";
        }
           }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
          }];
    

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
