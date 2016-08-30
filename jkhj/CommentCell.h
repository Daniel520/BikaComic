//
//  CommentCell.h
//  jkhj
//
//  Created by 辉仔 on 16/8/11.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *display_name;
@property (weak, nonatomic) IBOutlet UILabel *created_at;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *comment_index;
@property CGFloat Height;
@end
