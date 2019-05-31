//
//  L_NewBikeImageTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeImageTVC.h"

@interface L_NewBikeImageTVC ()

@property (weak, nonatomic) IBOutlet UIView *firstRedView;
@property (weak, nonatomic) IBOutlet UIView *secondRedView;
@property (weak, nonatomic) IBOutlet UIView *thirdRedView;

@property (weak, nonatomic) IBOutlet UIView *firstSelectBgView;
@property (weak, nonatomic) IBOutlet UIView *secondSelectBgView;
@property (weak, nonatomic) IBOutlet UIView *thirdSelectBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

/**
 添加二轮车照片背景view
 */
@property (weak, nonatomic) IBOutlet UIView *addImageBgView;

/**
 个数
 */
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) UIButton *firstDeleteButton;
@property (nonatomic, strong) UIButton *secondDeleteButton;
@property (nonatomic, strong) UIButton *thirdDeleteButton;

@end

@implementation L_NewBikeImageTVC

/**
 所有按钮点击事件
 */
- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    
    //sender.tag == 1.右上角按钮 2.3.4 展示照片 5 添加图片 6.7.8删除按钮 9.10.11图片点击
    if (self.allButtonsDidTouchBlock) {
        self.allButtonsDidTouchBlock(sender.tag);
    }
    
}

- (void)setModel:(L_BikeListModel *)model {
    
    _model = model;
    CGFloat width =  SCREEN_WIDTH - 16 - 30;
    CGFloat height = width / 16. * 9.;
    //13+18+20=51 37 height
    
    CGFloat imageHeight = height + 37;
    
    if (model.resource.count > 0) {
        
        _firstRedView.hidden = YES;
        _secondRedView.hidden = YES;
        _thirdRedView.hidden = YES;

        for (int i = 0; i < model.resource.count; i++) {
            
            L_BikeImageResourceModel *photoModel = model.resource[i];
            
            if (photoModel.isdefault.integerValue == 1) {
                if (i == 0) {
                    _firstRedView.hidden = NO;
                    _secondRedView.hidden = YES;
                    _thirdRedView.hidden = YES;
                    break;
                }
                if (i == 1) {
                    _firstRedView.hidden = YES;
                    _secondRedView.hidden = NO;
                    _thirdRedView.hidden = YES;
                    break;
                }
                if (i == 2) {
                    _firstRedView.hidden = YES;
                    _secondRedView.hidden = YES;
                    _thirdRedView.hidden = NO;
                    break;
                }
            }
        }
    }

    
    switch (model.resource.count) {
        case 0:
        {
            _countLabel.text = @"0/3";
            
            _firstImageButton.hidden = YES;
            _secondImageButton.hidden = YES;
            _thirdImageButton.hidden = YES;
            
            _firstSelectBgView.hidden = YES;
            _secondSelectBgView.hidden = YES;
            _thirdSelectBgView.hidden = YES;
            
            _addImageBgView.hidden = NO;

            _topLayoutConstraint.constant = 51;

            model.imageRowHeight = 51 + height + 10;

        }
            break;
        case 1:
        {
            _countLabel.text = @"1/3";

            _firstImageButton.hidden = NO;
            _secondImageButton.hidden = YES;
            _thirdImageButton.hidden = YES;
            
            _firstSelectBgView.hidden = NO;
            _secondSelectBgView.hidden = YES;
            _thirdSelectBgView.hidden = YES;
            
            _addImageBgView.hidden = NO;

            _topLayoutConstraint.constant = 51 + imageHeight;

            model.imageRowHeight = 51 + height + 10 + imageHeight;

            L_BikeImageResourceModel *photoModel = model.resource[0];
            if (photoModel.image) {
                [_firstImageButton setBackgroundImage:photoModel.image forState:UIControlStateNormal];
            }else {
                [_firstImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoModel.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            }
            
        }
            break;
        case 2:
        {
            _countLabel.text = @"2/3";

            _firstImageButton.hidden = NO;
            _secondImageButton.hidden = NO;
            _thirdImageButton.hidden = YES;
            
            _firstSelectBgView.hidden = NO;
            _secondSelectBgView.hidden = NO;
            _thirdSelectBgView.hidden = YES;
            
            _addImageBgView.hidden = NO;

            _topLayoutConstraint.constant = 51 + imageHeight * 2;

            model.imageRowHeight = 51 + height + 10 + imageHeight * 2;

            L_BikeImageResourceModel *photoModel0 = model.resource[0];
            if (photoModel0.image) {
                [_firstImageButton setBackgroundImage:photoModel0.image forState:UIControlStateNormal];
            }else {
                [_firstImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoModel0.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            }
            
            L_BikeImageResourceModel *photoModel1 = model.resource[1];
            if (photoModel1.image) {
                [_secondImageButton setBackgroundImage:photoModel1.image forState:UIControlStateNormal];
            }else {
                [_secondImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoModel1.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            }
            
        }
            break;
        case 3:
        {
            _countLabel.text = @"0/3";

            _firstImageButton.hidden = NO;
            _secondImageButton.hidden = NO;
            _thirdImageButton.hidden = NO;
            
            _firstSelectBgView.hidden = NO;
            _secondSelectBgView.hidden = NO;
            _thirdSelectBgView.hidden = NO;
            
            _addImageBgView.hidden = YES;
            
//            _topLayoutConstraint.constant = 51 + imageHeight * 3;
            model.imageRowHeight = 51 + height + 10;

            model.imageRowHeight = 51 + 10 + imageHeight * 3;

            L_BikeImageResourceModel *photoModel0 = model.resource[0];
            if (photoModel0.image) {
                [_firstImageButton setBackgroundImage:photoModel0.image forState:UIControlStateNormal];
            }else {
                [_firstImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoModel0.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            }
            
            L_BikeImageResourceModel *photoModel1 = model.resource[1];
            if (photoModel1.image) {
                [_secondImageButton setBackgroundImage:photoModel1.image forState:UIControlStateNormal];
            }else {
                [_secondImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoModel1.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            }
            
            L_BikeImageResourceModel *photoModel2 = model.resource[2];
            if (photoModel2.image) {
                [_thirdImageButton setBackgroundImage:photoModel2.image forState:UIControlStateNormal];
            }else {
                [_thirdImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photoModel2.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            }
            
        }
            break;
        default:
            break;
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat width =  SCREEN_WIDTH - 16 - 30;

    CGFloat buttonWidth = 30;
    
    _firstDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstDeleteButton.frame = CGRectMake(width - buttonWidth - 2, 2, buttonWidth, buttonWidth);
    [_firstDeleteButton setImage:[UIImage imageNamed:@"添加二轮车-关闭图片图标"] forState:UIControlStateNormal];
//    _firstDeleteButton.backgroundColor = [UIColor blueColor];
    _firstDeleteButton.tag = 6;
    [_firstDeleteButton addTarget:self action:@selector(allButtonsDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_firstImageButton addSubview:_firstDeleteButton];
    
    _secondDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondDeleteButton.frame = CGRectMake(width - buttonWidth - 2, 2, buttonWidth, buttonWidth);
    [_secondDeleteButton setImage:[UIImage imageNamed:@"添加二轮车-关闭图片图标"] forState:UIControlStateNormal];
//    _secondDeleteButton.backgroundColor = [UIColor blueColor];
    _secondDeleteButton.tag = 7;
    [_secondDeleteButton addTarget:self action:@selector(allButtonsDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_secondImageButton addSubview:_secondDeleteButton];
    
    _thirdDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdDeleteButton.frame = CGRectMake(width - buttonWidth - 2, 2, buttonWidth, buttonWidth);
    [_thirdDeleteButton setImage:[UIImage imageNamed:@"添加二轮车-关闭图片图标"] forState:UIControlStateNormal];
//    _thirdDeleteButton.backgroundColor = [UIColor blueColor];
    _thirdDeleteButton.tag = 8;
    [_thirdDeleteButton addTarget:self action:@selector(allButtonsDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdImageButton addSubview:_thirdDeleteButton];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
