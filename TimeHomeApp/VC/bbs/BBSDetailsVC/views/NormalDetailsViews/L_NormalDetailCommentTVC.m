//
//  L_NormalDetailCommentTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NormalDetailCommentTVC.h"

@implementation L_NormalDetailCommentTVC

- (IBAction)allButtonDidTouch:(UIButton *)sender {
    //1.头像 2.评论列表
    if (self.allButtonDidTouchBlock) {
        self.allButtonDidTouchBlock(sender.tag);
    }
}

- (void)setModel:(L_TieziCommentModel *)model {
    
    _model = model;
    
    _nickNameLabel.text = [XYString IsNotNull:model.nickname];
    [_headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.userpicurl] forState:UIControlStateNormal placeholderImage:kHeaderPlaceHolder];
    
    _timeLabel.text = [XYString IsNotNull:model.systime];
    
    if (_type != 0) {
        _commentCountsLabel.hidden = YES;
        _commentImageView.hidden = YES;
        
        if (_type == 1) {
            _contentLabel.text = [XYString IsNotNull:model.content];

            self.contentView.backgroundColor = [UIColor whiteColor];
        }else {
            self.contentView.backgroundColor = BLACKGROUND_COLOR;
            _contentLabel.text = @"";
            
            NSString *string = [NSString stringWithFormat:@"回复%@:%@",model.tonickname,[XYString IsNotNull:model.content]];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:DEFAULT_FONT(15)}];
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x159BD1) range:NSMakeRange(0,model.tonickname.length+3)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:TITLE_TEXT_COLOR range:NSMakeRange(model.tonickname.length+3,string.length - (model.tonickname.length+3))];
            _contentLabel.attributedText = attributeString;
            _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        }
        
    }else {
        
        _contentLabel.text = [XYString IsNotNull:model.content];

        if ([XYString isBlankString:model.commentcount]) {
            _commentCountsLabel.text = @"评论 0";
        }else {
            _commentCountsLabel.text = [NSString stringWithFormat:@"评论 %@",model.commentcount];
        }
        
        _commentCountsLabel.hidden = NO;
        _commentImageView.hidden = NO;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_contentLabel.frame);
    
    model.height = rectY + 15;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _headerButton.clipsToBounds = YES;
    _headerButton.layer.cornerRadius = 25;
    
    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - (50+8+8+5);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
