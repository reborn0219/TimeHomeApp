//
//  LS_ PersonalNoticeCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_PersonalNoticeCell.h"
#import "DateTimeUtils.h"
#import "PARedBagModel.h"

@implementation LS_PersonalNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _redpacketBtn.hidden = YES;

    
}
-(void)wetherEditing:(BOOL)isEditing
{
    if (isEditing) {
        
        _contentLeading.constant = 50;
        _contenttrailing.constant = -50;
        
    }else
    {
        _contentLeading.constant = 0;
        _contenttrailing.constant = 0;
    }
}
#pragma mark - 给cell删除按钮添加图片
-(void)layoutSubviews
{
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
#pragma mark - 隐藏或显示查看详情
-(void)hiddenDetail:(BOOL)hidden
{
    [self.DetailLb setHidden:hidden];
    [self.DetailBtn setHidden:hidden];
    [self.RightImgV setHidden:hidden];
}
-(void)assignmentWithModel:(UserNoticeModel *)UNML
{
    
    if (UNML.isSelect) {
        
        [_ls_selectImgV setImage:[UIImage imageNamed:@"ls_duigou"]];
    }else
    {
        [_ls_selectImgV setImage:[UIImage imageNamed:@"ls_tuoyuan"]];

    }
    _titleLb.text = UNML.title;
    _timeLb.text = [UNML.systime substringWithRange:NSMakeRange(0,19)];
    _contentLb.text = UNML.content;
    NSDictionary * jsonData = UNML.jsondata;
    
    [self hiddenDetail:YES];
    _redpacketBtn.hidden = YES;
    
    if ([UNML.type isEqualToString:@"0"]) {//系统通知
        
        if (jsonData) {
            [self hiddenDetail:NO];
        }
        
    }else{
        
        if (jsonData) {//有jsondata情况 需要判断显示[红包]还是[查看详情]
            //
            PARedBagModel *redBag = [PARedBagModel mj_objectWithKeyValues:jsonData];
            if (redBag && redBag.logo && redBag.state == 0) {//有jsondata，有红包，未领取
                _redpacketBtn.hidden = NO;
            }else if(!redBag.logo){//有jsondata，非红包，显示[查看详情]
                [self hiddenDetail:NO];
            }
            
        }
    }
    
}
@end
