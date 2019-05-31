//
//  UnreadMessageCell.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNoticeCountModel.h"

@interface UnreadMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *unreadLb;
@property (weak, nonatomic) IBOutlet UIView *unreadV;
@property (weak, nonatomic) IBOutlet UIImageView *ImgLine;
@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underView_layout;

-(void)assignmentWithModel:(UserNoticeCountModel *)UNCML;
@end
