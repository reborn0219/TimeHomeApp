//
//  answerTableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "answerTableViewCell.h"

@implementation answerTableViewCell


- (IBAction)allButtonDidTouch:(UIButton *)sender {
    
    //1.头像 2.评论列表
    if (self.allButtonDidTouchBlock) {
        self.allButtonDidTouchBlock(sender.tag);
    }
}

- (void)setModel:(QuestionAnswerModel *)model {
   
    _model = model;
    
    NSString *contentString1 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.content]];
    self.infoLal.text = contentString1;
    
    NSString *contentString2 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.nickname]];
    self.nickName.text = contentString2;
    
    NSString *contentString3 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.systime]];
    self.timeLal.text = contentString3;

    NSString *contentString4 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.commentcount]];
    if ([XYString isBlankString:contentString4]) {
        
        self.commentcount.text = @"评论 0";
    }else{
        
        self.commentcount.text = [NSString stringWithFormat:@"评论 %@",contentString4];
    }
    
    NSString *contentString5 = [XYString IsNotNull:[NSString stringWithFormat:@"%@",model.praisecount]];
    
    if ([XYString isBlankString:contentString5]) {
        
        self.praisecount.text = @"点赞 0";
    }else{
        
        self.praisecount.text = [NSString stringWithFormat:@"点赞 %@",contentString5];
    }
    
    self.headerBt.contentMode = UIViewContentModeScaleToFill;
    
    [self.headerBt sd_setBackgroundImageWithURL:[NSURL URLWithString:model.userpicurl] forState:UIControlStateNormal placeholderImage:kHeaderPlaceHolder];
    
    self.headerBt.layer.cornerRadius = 50 / 2;
    self.headerBt.layer.masksToBounds = YES;
    
    if ([model.ispraise isEqualToString:@"1"]) {
        
        self.praiseImg.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
    }else{
        
        self.praiseImg.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
    }
    
    if ([model.isAccept isEqualToString:@"1"]) {
        
        if ([model.bestAnswer isEqualToString:@"1"]) {
            
            self.tagLal.backgroundColor = NEW_RED_COLOR;
            self.tagLal.text = @"最佳答案";
            self.tagImg.hidden = NO;
        }else{
            
            self.tagLal.backgroundColor = TEXT_COLOR;
            self.tagLal.text = @"其他答案";
            self.tagImg.hidden = YES;
        }
    }else{
        
        self.tagLal.backgroundColor = TEXT_COLOR;
        self.tagLal.text = @"回答";
        self.tagImg.hidden = YES;
    }
    
    if ([model.isMyPost isEqualToString:@"1"]) {
        
        if ([model.isAccept isEqualToString:@"1"]) {
            
            self.acceptBt.backgroundColor = [UIColor whiteColor];
            self.acceptBt.userInteractionEnabled = NO;
            
            if ([self.tagLal.text isEqualToString:@"最佳答案"]) {
                self.questionBt.backgroundColor = [UIColor clearColor];
                self.questionBt.userInteractionEnabled = YES;
            }else {
                self.questionBt.backgroundColor = [UIColor whiteColor];
                self.questionBt.userInteractionEnabled = NO;
            }
            
            self.line.hidden = YES;
            
        }else{
            
            self.acceptBt.backgroundColor = [UIColor clearColor];
            self.acceptBt.userInteractionEnabled = YES;
            
            self.questionBt.backgroundColor = [UIColor clearColor];
            self.questionBt.userInteractionEnabled = YES;
            
            self.line.hidden = NO;
        }
    }else{
        
        self.acceptBt.backgroundColor = [UIColor whiteColor];
        self.acceptBt.userInteractionEnabled = NO;
        
        self.questionBt.backgroundColor = [UIColor whiteColor];
        self.questionBt.userInteractionEnabled = NO;

        
        self.line.hidden = YES;
    }
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(self.timeLal.frame);
    float height = rectY;
    model.height = height + 10;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
