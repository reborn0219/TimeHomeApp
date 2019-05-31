//
//  L_NewBikeInfoImageTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/23.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeInfoImageTVC.h"
#import "L_BikeImageResourceModel.h"

@interface L_NewBikeInfoImageTVC ()

@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;

@end

@implementation L_NewBikeInfoImageTVC

- (void)setBikeModel:(L_BikeListModel *)bikeModel {
    
    _bikeModel = bikeModel;
    
    CGFloat imageHeight = (SCREEN_WIDTH - 30) / 16 * 9;
    
    switch (bikeModel.resource.count) {
        case 0:
        {
            _firstImageButton.hidden = YES;
            _secondImageButton.hidden = YES;
            _thirdImageButton.hidden = YES;
            bikeModel.infoSecondRowHeight = 0;
        }
            break;
        case 1:
        {
            _firstImageButton.hidden = NO;
            _secondImageButton.hidden = YES;
            _thirdImageButton.hidden = YES;
            
            L_BikeImageResourceModel *resoucreModel = bikeModel.resource[0];
            
            [_firstImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:resoucreModel.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            
            bikeModel.infoSecondRowHeight = imageHeight + 36;

        }
            break;
        case 2:
        {
            _firstImageButton.hidden = NO;
            _secondImageButton.hidden = NO;
            _thirdImageButton.hidden = YES;
            
            L_BikeImageResourceModel *resoucreModel = bikeModel.resource[0];
            
            [_firstImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:resoucreModel.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            
            L_BikeImageResourceModel *resoucreModel1 = bikeModel.resource[1];
            
            [_secondImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:resoucreModel1.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            
            bikeModel.infoSecondRowHeight = imageHeight * 2 + 36;

        }
            break;
        case 3:
        {
            _firstImageButton.hidden = NO;
            _secondImageButton.hidden = NO;
            _thirdImageButton.hidden = NO;
            
            L_BikeImageResourceModel *resoucreModel = bikeModel.resource[0];
            
            [_firstImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:resoucreModel.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            
            L_BikeImageResourceModel *resoucreModel1 = bikeModel.resource[1];
            
            [_secondImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:resoucreModel1.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            
            L_BikeImageResourceModel *resoucreModel2 = bikeModel.resource[2];
            
            [_thirdImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:resoucreModel2.resourceurl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER_IMAGE];
            
            bikeModel.infoSecondRowHeight = imageHeight * 3 + 36;

        }
            break;
        default:
        {
            _firstImageButton.hidden = YES;
            _secondImageButton.hidden = YES;
            _thirdImageButton.hidden = YES;
            bikeModel.infoSecondRowHeight = 0;

        }
            break;
    }
    
}
- (IBAction)allButtonDidTouch:(UIButton *)sender {
    
    if (_bikeModel.resource.count == 0) {
        return;
    }
    
    if (self.imageButtonDidTouchBlock) {
        self.imageButtonDidTouchBlock(sender.tag);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
