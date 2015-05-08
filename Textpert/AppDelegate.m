//
//  AppDelegate.m
//  Textpert
//
//  Created by KAFOOR on 30/4/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "AppDelegate.h"
#import <Pushbots/Pushbots.h>
#import <FacebookSDK/FacebookSDK.h>
//#import "RequestFromUserVC.h"

@interface AppDelegate ()
{
    NSString *value;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FBLoginView class];
    
    [Pushbots sharedInstanceWithAppId:@"554072c9177959404b8b457e"];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    //        NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(pushDict){
        
        value = [pushDict valueForKey:@"newsID"];
        
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    // This method will be called everytime you open the app
    // Register the deviceToken on Pushbots
    [[Pushbots sharedInstance] registerOnPushbots:deviceToken];
    NSString *devToken = [[[deviceToken description]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                          stringByReplacingOccurrencesOfString:@" "
                          withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject: devToken forKey:@"deviceID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Notification Registration Error %@", [error userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //Handle notification when the user click it while app is running in background or foreground.
    [[Pushbots sharedInstance] receivedPush:userInfo];
    
    value = [userInfo valueForKey:@"newsID"];
    
    //[[Pushbots sharedInstance] setBadge:10];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
    NSDictionary *dict=[userInfo valueForKey:@"aps"];
    long badgeno =[[dict valueForKey:@"badge"]integerValue];
    NSString *badge=[NSString stringWithFormat:@"%ld",badgeno];
    // objectForKey: @"badge"];
    
    [[NSUserDefaults standardUserDefaults] setObject: badge forKey:@"badge"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"test" message:@"Notification" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

+(void)clearbadgeCount
{
    [[Pushbots sharedInstance] clearBadgeCount];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"badge"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void) receivedPush:(NSDictionary *)userInfo {
    //Try to get Notification from [didReceiveRemoteNotification] dictionary
    NSDictionary *pushNotification = [userInfo objectForKey:@"aps"];
    
    if(!pushNotification) {
        //Try as launchOptions dictionary
        userInfo = [userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        pushNotification = [userInfo objectForKey:@"aps"];
    }
    
    if (!pushNotification)
        return;
    
    //Get notification payload data [Custom fields]
    
    //For example: get viewControllerIdentifer for deep linking
    NSString* notificationViewControllerIdentifer = [userInfo objectForKey:@"notification_identifier"];
    
    //Set the default viewController Identifer
    if(!notificationViewControllerIdentifer)
        notificationViewControllerIdentifer = @"home";
    
    UIAlertView *message =
    [[UIAlertView alloc] initWithTitle:@"Notification"
                               message:[pushNotification valueForKey:@"alert"]
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles: @"OK",
     nil];
    
    //[message show];
    return;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        [[Pushbots sharedInstance] OpenedNotification];
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
