//
//  KnightRankTableViewCell.h
//  jkhj
//
//  Created by 辉仔 on 16/9/28.
//  Copyright © 2016年 辉仔sama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnightRankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Rank;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *Separator;
@property (weak, nonatomic) IBOutlet UILabel *count;
@end
