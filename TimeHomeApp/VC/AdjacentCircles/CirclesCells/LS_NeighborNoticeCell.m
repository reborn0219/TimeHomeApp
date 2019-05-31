//
//  LS _NeighborNoticeCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_NeighborNoticeCell.h"
#import "DateTimeUtils.h"

@implementation LS_NeighborNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.replyBtn.layer.borderWidth = 1;
    self.replyBtn.layer.borderColor = kNewRedColor.CGColor;
    _detailImgV.contentMode = UIViewContentModeScaleAspectFill;
    _detailImgV.clipsToBounds = YES;

}
-(void)wetherEditing:(BOOL)isEditing
{
    if (isEditing) {
        
        _topview_layout_left.constant = 50;
        _topview_layout_right.constant = -50;
        _bottom_layout_left.constant = 50;
        _bottom_layout_right.constant = -50;
        
    }else
    {
        _topview_layout_left.constant = 0;
        _topview_layout_right.constant = 0;
        _bottom_layout_left.constant = 0;
        _bottom_layout_right.constant = 0;
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
-(void)assignmentWithModel:(UserNoticeModel *)UNML withType:(NSString *)type
{
    
    _titleLb.text = UNML.jsondata[@"nickname"];
    
    if (UNML.isSelect) {
        
        [_ls_imgV setImage:[UIImage imageNamed:@"ls_duigou"]];
    }else
    {
        [_ls_imgV setImage:[UIImage imageNamed:@"ls_tuoyuan"]];
        
    }
    
    _timeLb.text = [UNML.systime substringWithRange:NSMakeRange(0,19)];
    _contentLb.text = UNML.jsondata[@"commentcontent"];
    _detailContentLb.text = UNML.jsondata[@"postcontent"];
    [_headerImgV sd_setImageWithURL:[NSURL URLWithString:UNML.jsondata[@"userpicurl"]] placeholderImage:kHeaderPlaceHolder];
    
    NSArray * piclist = [UNML.jsondata objectForKey:@"piclist"];
    if (piclist.count==0||piclist ==nil) {
        
        _detailImg_layout.constant = 0;
    }else
    {
        NSDictionary * picDic = [piclist firstObject];
        [_detailImgV sd_setImageWithURL:[NSURL URLWithString:[picDic objectForKey:@"picurl"]] placeholderImage:PLACEHOLDER_IMAGE];
        _detailImg_layout.constant = 84;

    }
    if ([type isEqualToString:@"4"]) {
        
        [self.zanImgV setHidden:YES];
        [self.replyBtn setHidden:NO];
        
    }else
    {
        [self.replyBtn setHidden:YES];
        [self.zanImgV setHidden:NO];
        _contentLb.text = @"";
    }
    
}

- (IBAction)replyAction:(id)sender {
    if (self.block) {
        self.block(nil,self,nil);
    }
}
@end
