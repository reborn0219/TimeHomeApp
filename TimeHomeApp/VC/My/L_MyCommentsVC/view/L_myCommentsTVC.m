//
//  L_myCommentsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_myCommentsTVC.h"

@interface L_myCommentsTVC ()

/**
 最下面的view
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation L_myCommentsTVC

/**
 删除按钮点击
 */
- (IBAction)deleteButtonDidTouch:(UIButton *)sender {
    
    if (self.deleteButtonTouchBlock) {
        self.deleteButtonTouchBlock();
    }
}

/**
 显示全部
 */
- (IBAction)showAllButtonDidTouch:(UIButton *)sender {
    NSLog(@"显示全部");
    
    _model.hideShowButton = YES;
    
    if (self.reloadIndexPathBlock) {
        self.reloadIndexPathBlock();
    }
    
}


- (void)setModel:(L_UserCommentModel *)model {
    _model = model;
    
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 36, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:15]} context:nil].size;
    //41-----2行的高度
    NSLog(@"====%.2f",size.height);
    
    if (!model.hideShowButton) {
        if (size.height <= 41) {
            
            if (size.height <= 20.5) {
                _titleLabel.numberOfLines = 1;
            }else {
                _titleLabel.numberOfLines = 2;
            }
            _showAllButton.hidden = YES;

        }else {
            _showAllButton.hidden = NO;
            _titleLabel.numberOfLines = 2;
        }
    }else {
        _showAllButton.hidden = YES;
        _titleLabel.numberOfLines = 0;
    }
    
    NSString *postContent = @"";
    if ([model.posttype isEqualToString:@"3"]) {
        /** 评论 */
        postContent = [XYString IsNotNull:model.posttitle];
    }else {
        /** 评论 */
        postContent = [XYString isBlankString:model.postcontent] ? model.posttitle : model.postcontent;
    }
    _detailTitle.text = [XYString IsNotNull:postContent];

    /** 标题 */
    _titleLabel.text = model.content;
    
//    /** 评论 */
//    NSString *postContent = [XYString isBlankString:model.postcontent] ? model.posttitle : model.postcontent;
    

    
    /** 是否有图片 */
    if ([XYString isBlankString:model.postpicurl]) {
        _leftImageWidthConstraint.constant = 0;
        _detailLabelLeftConstraint.constant = 0;
        
        if (_showAllButton.hidden) {
            _leftImageTopConstraint.constant = 5;

        }else {
            _leftImageTopConstraint.constant = 25;

        }
        
        if ([XYString isBlankString:postContent]) {
            _leftImageHeightConstraint.constant = 0;
        }else {
            _leftImageHeightConstraint.constant = 38.5;
        }
        
    }else {
        _leftImageWidthConstraint.constant = 60;
        _leftImageHeightConstraint.constant = 60;
        _detailLabelLeftConstraint.constant = 10;
        _leftImageTopConstraint.constant = 25;

        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.postpicurl] placeholderImage:PLACEHOLDER_IMAGE];
    }
    
    /** 时间 */
    NSString *time = @"";
    if (model.systime.length >= 19) {
        time = [model.systime substringToIndex:19];
    }else {
        time = model.systime;
    }
    _timeLabel.text = [XYString NSDateToString:[XYString NSStringToDate:time] withFormat:@"yyyy-MM-dd/HH:mm:ss"];
    
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    [self layoutIfNeeded];
    
    CGFloat height = CGRectGetMaxY(_bottomView.frame);
    
    model.height = height;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _deleteButton.layer.borderWidth = 1.f;
    _deleteButton.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    
    // 注意：如果在XIB中有动态计算高度的Label 要写一下代码：（以确保正确计算label 的高度）
    _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 36;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
