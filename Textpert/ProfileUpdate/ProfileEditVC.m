//
//  ProfileEditVC.m
//  TextPert
//
//  Created by elicit on 21/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "ProfileEditVC.h"

@interface ProfileEditVC ()<UITextFieldDelegate>

@end

@implementation ProfileEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblUsername.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"uname"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickSave:(id)sender {
    //[[NSUserDefaults standardUserDefaults] setObject:_tx.text forKey:@"uname"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
