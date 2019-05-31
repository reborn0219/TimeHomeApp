//
//  LS_VistorDescribeCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_VistorDescribeCell.h"

@implementation LS_VistorDescribeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentLb.font = [UIFont systemFontOfSize:16.];
    _contentLb.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)assignmentWithModel:(UserVisitor *)UV
{
    [super assignmentWithModel:UV];
    self.contentLb.text = UV.leavemsg;
    _contentLb.font = [UIFont systemFontOfSize:16.];
    _contentLb.textAlignment = NSTextAlignmentCenter;
    
    [self layoutIfNeeded];
    
    [self contentSizeToFit];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if ([self.contentLb.text length] > 0) {
        
        CGSize size = [self.contentLb.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]} context:nil].size;
        
        CGSize contentSize = CGSizeMake(SCREEN_WIDTH - 100, size.height + 8);
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= 113) {
            
        }else {
            
            [_contentLb setContentOffset:CGPointZero animated:NO];
            
        }
        
    }
    
}

- (void)contentSizeToFit {
    
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if ([self.contentLb.text length] > 0) {

        CGSize size = [self.contentLb.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]} context:nil].size;
        
        CGSize contentSize = CGSizeMake(SCREEN_WIDTH - 100, size.height + 8);
        
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= 113) {
            
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (self.contentLb.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY-10, 0, 0, 0);
            [self.contentLb setContentSize:newSize];
            [self.contentLb setContentInset:offset];
            
        }
        
    }
    
}


@end
