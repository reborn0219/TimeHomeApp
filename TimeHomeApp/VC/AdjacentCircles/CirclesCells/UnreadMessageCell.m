//
//  UnreadMessageCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UnreadMessageCell.h"
#import "DateTimeUtils.h"

@implementation UnreadMessageCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.unreadV.layer.cornerRadius = 10;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.cornerRadius = 20;
    [self.topImgV setHidden:YES];
    
}
#pragma mark - 给cell删除按钮添加图片
-(void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {

        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            UIView *deleteConfirmationView = subView.subviews[0];
            deleteConfirmationView.backgroundColor = kNewRedColor;
            for (UIView *deleteView in deleteConfirmationView.subviews){
                
                NSLog(@"%@",deleteConfirmationView.subviews);
                UIImageView *deleteImage = [[UIImageView alloc] init];
                deleteImage.contentMode = UIViewContentModeScaleAspectFit;
                deleteImage.image = [UIImage imageNamed:@"删除图标"];
                deleteImage.frame = CGRectMake(0, 0, deleteView.frame.size.width, deleteView.frame.size.height);
                deleteImage.tag = 1000;
                UIView * view = [deleteView viewWithTag:1000];
                if (view==nil) {
                    [deleteView addSubview:deleteImage];
                }
            }
            
        }
    }
    
}
#pragma mark - cell赋值
-(void)assignmentWithModel:(UserNoticeCountModel *)UNCML {
    
    //0 系统通知  2 个人消息 4帖子评论 5帖子赞 6活动通知
    [self.topImgV setHidden:!UNCML.istop.boolValue];
    NSString * imgNameStr;
    NSString * title;
    switch (UNCML.type.integerValue) {
        case 0:
        {
            imgNameStr = @"系统通知图标";
            title = @"系统通知";
            [_imgV setImage:[UIImage imageNamed:imgNameStr]];

        }
            break;
        case 2:
        {
            imgNameStr = @"个人通知图标";
            title = @"个人通知";
            [_imgV setImage:[UIImage imageNamed:imgNameStr]];

        }
            break;
        case 3:
        {
            imgNameStr = UNCML.picurl;
            title = UNCML.title;
            [_imgV sd_setImageWithURL:[NSURL URLWithString:imgNameStr] placeholderImage:kHeaderPlaceHolder];

        }
            break;
        case 4:
        {
            imgNameStr = @"评论图标";
            title = @"评论";
            [_imgV setImage:[UIImage imageNamed:imgNameStr]];


        }
            break;
        case 5:
        {
            imgNameStr = @"点赞图标_1";
            title = @"点赞";
            [_imgV setImage:[UIImage imageNamed:imgNameStr]];

        }
            break;
        case 6:
        {
            imgNameStr = @"活动通知图标";
            title = @"活动通知";
            [_imgV setImage:[UIImage imageNamed:imgNameStr]];

        }
            break;
        default:
            break;
    }
    [_nameLb setText:title];
    [_contentLb setText:UNCML.usernotice];
    
    if (UNCML.type.integerValue == 3) {
        _timeLb.text = [DateTimeUtils StringToDateTimeWithTime:UNCML.userlasttime];
    }else {
        _timeLb.text = @"";
    }

    if (UNCML.usercount.integerValue>0) {
        [_unreadV setHidden:NO];
        [_unreadLb setHidden:NO];
        [_unreadLb setText:UNCML.usercount];
        
        if(UNCML.usercount.integerValue>9)
        {
            _underView_layout.constant = 30;
            
        }else if(UNCML.usercount.integerValue>99)
        {
            [_unreadLb setText:@"99+"];
            _underView_layout.constant = 35;
        }
        
    }else
    {
//        [_timeLb setText:@""];
        [_unreadV setHidden:YES];
        [_unreadLb setHidden:YES];
    }
    
}
@end
