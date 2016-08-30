//
//  NavigationViewController.m
//  jkhj
//
//  Created by 辉仔 on 16/8/29.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNightMode:) name:@"ChangeNightMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeDefaultMode:) name:@"ChangeDefaultMode" object:nil];

}

-(void)ChangeDefaultMode:(id)sender
{
    [self.navigationBar setBarTintColor:DefaultModeNavigationColor];
    [self.navigationBar setTintColor:DefaultModeTintColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];

}

-(void)ChangeNightMode:(id)sender
{
    [self.navigationBar setBarTintColor:NightModeNavigationColor];
    [self.navigationBar setTintColor:NightModeTintColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NightModeTextColor}];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    if ([Defaults boolForKey:@"NightMode"])
        return UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
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
