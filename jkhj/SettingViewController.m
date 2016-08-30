//
//  SettingViewController.m
//  jkhj
//
//  Created by 辉仔 on 16/8/29.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "SettingViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *UserNameTips;
@property (weak, nonatomic) IBOutlet UILabel *NightModeTips;
@property (weak, nonatomic) IBOutlet UILabel *NightModeLable;
@property (weak, nonatomic) IBOutlet UISwitch *NightSwitch;
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@end

@implementation SettingViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.NameTextField.text=[NSString stringWithFormat:@"%@" ,[Defaults objectForKey:@"GentlemanName"]];
    [self.NightSwitch addTarget:self action:@selector(ChangeNightMode:) forControlEvents:UIControlEventValueChanged];
    [self.NightSwitch setOnTintColor:NightModeNavigationColor];
    
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.NameTextField setTextColor:[UIColor whiteColor]];
        [self.view setBackgroundColor:NightModeBackgroundColor];
        [self.NameTextField setBackgroundColor:NightModeNavigationColor];
        [self.UserNameTips setTextColor:NightModeTextColor];
        [self.NightModeTips setTextColor:NightModeTextColor];
        [self.NightModeLable setTextColor:NightModeTextColor];
        [self.NightSwitch setOn:YES];
    }
    else
    {
        [self.NightSwitch setOn:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [Defaults setObject:self.NameTextField.text forKey:@"GentlemanName"];
}

-(void)ChangeNightMode:(id)sender
{
    if ([self.NightSwitch isOn])
    {
        
         [self.NameTextField setTextColor:[UIColor whiteColor]];
        [self.view setBackgroundColor:NightModeBackgroundColor];
        [self.NameTextField setBackgroundColor:NightModeNavigationColor];
        [self.UserNameTips setTextColor:NightModeTextColor];
        [self.NightModeTips setTextColor:NightModeTextColor];
        [self.NightModeLable setTextColor:NightModeTextColor];
        [Defaults setBool:YES forKey:@"NightMode"];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNightMode" object:self userInfo:nil];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [self.NameTextField setTextColor:[UIColor redColor]];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.NameTextField setBackgroundColor:[UIColor whiteColor]];
        [self.UserNameTips setTextColor:[UIColor blackColor]];
        [self.NightModeTips setTextColor:[UIColor blackColor]];
        [self.NightModeLable setTextColor:[UIColor blackColor]];
         [Defaults setBool:NO forKey:@"NightMode"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeDefaultMode" object:self userInfo:nil];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [Defaults synchronize];
}


- (IBAction)EndEdit:(id)sender
{
    [self.view endEditing:YES];
}
@end
