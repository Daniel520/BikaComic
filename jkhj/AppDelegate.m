//
//  AppDelegate.m
//  jkhj
//
//  Created by 辉仔 on 16/7/17.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "TableViewController.h"
#import "MJRefresh.h"
#import "TableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 
    if ([Defaults objectForKey:@"uuid"]==nil)
    {
        [Defaults setObject:[self uuid] forKey:@"uuid"];
        NSLog(@"%@",[Defaults objectForKey:@"uuid"]);
        [Defaults synchronize];
    }
    NSDictionary* dics=[[NSDictionary alloc]init];
    if ([Defaults objectForKey:@"collection"]==nil)
    {
        [Defaults setObject:dics forKey:@"collection"];
        [Defaults synchronize];
    }
    if ([Defaults objectForKey:@"gentleman"]==nil)
    {
        [Defaults setObject:@"绅士2333" forKey:@"GentlemanName"];
        [Defaults synchronize];
    }
    if (![Defaults boolForKey:@"NightMode"])
    {
        [Defaults setBool:NO forKey:@"NightMode"];
        [Defaults synchronize];
    }
    
    if ([Defaults boolForKey:@"NightMode"])
    {
        [[UINavigationBar appearance] setBarTintColor:NightModeNavigationColor];
        [[UINavigationBar appearance] setTintColor:NightModeTintColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:NightModeTintColor}];
    }

    return YES;
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

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    return result;
}


@end
