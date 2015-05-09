//
//  SideMenuVC.m
//  TextPert
//
//  Created by elicit on 13/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "SideMenuVC.h"
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SideMenuVC ()<UITableViewDelegate,FBLoginViewDelegate>
{
    NSArray *menuItems;
}
@property (strong, nonatomic) IBOutlet FBLoginView *loginBtn;

@end

@implementation SideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    _loginBtn.delegate=self;
    self.objtable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.objtable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage* logoImage = [UIImage imageNamed:@"logoWhite"];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,5,60,60)];
    imgView.image=logoImage;
    self.navigationItem.titleView =imgView;
     menuItems=[[NSArray alloc]initWithObjects:@"Upload A Photo",@"Profile",@"Texpert Mode"/*, @"",@"Responses (user mode)",@"Requests (textpert mode)"*/,nil];
    // Do any additional setup after loading the view.
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSString *valueToSave = @"LogOut";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"loginVc" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor=[UIColor clearColor];
    // Configure the cell...
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //    cell.backgroundColor=[UIColor colorWithRed:0/255.0 green:153/255.0 blue:204/255.0 alpha:1.0];
    // cell.textLabel.textColor=[UIColor whiteColor];
    UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 15.0 ];
    cell.textLabel.font  = myFont;
    UILabel*lbl=(UILabel*)[cell viewWithTag:7];
    lbl.text =  [menuItems objectAtIndex:indexPath.row];
    UIImageView *img=(UIImageView *)[cell viewWithTag:9];
  //  img.image=[UIImage imageNamed:[NSString stringWithFormat:@"icn%d.png",indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)
    {
        [self performSegueWithIdentifier:@"segueUploadImg" sender:self];
    }
    else if(indexPath.row==1)
    {
        
        [self performSegueWithIdentifier:@"Home" sender:self];
    }

        else if(indexPath.row==2)
    {
        
        [self performSegueWithIdentifier:@"textpertMode" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
    
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
