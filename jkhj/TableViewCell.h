//
//  TableViewCell.h
//  jkhj
//
//  Created by 辉仔 on 16/7/17.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *Star1;
@property (weak, nonatomic) IBOutlet UIImageView *Star2;
@property (weak, nonatomic) IBOutlet UIImageView *Star3;
@property (weak, nonatomic) IBOutlet UIImageView *Star4;
@property (weak, nonatomic) IBOutlet UIImageView *Star5;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *BLSign;
@property (weak, nonatomic) IBOutlet UILabel *BanBook;
@property (weak, nonatomic) IBOutlet UILabel *GameSign;
@property (weak, nonatomic) IBOutlet UILabel *RawMeatSign;
@property (weak, nonatomic) IBOutlet UILabel *PageCount;
@property (weak, nonatomic) IBOutlet UILabel *NTR;
@property (weak, nonatomic) IBOutlet UILabel *FuTaSign;
@property (weak, nonatomic) IBOutlet UILabel *HouGongSign;

@end
