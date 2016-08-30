//
//  CommentModel.h
//  jkhj
//
//  Created by 辉仔 on 16/8/12.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentModel : NSObject
@property (strong, nonatomic)NSString *display_name;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *comment_index;
@property CGFloat Height;
@end
