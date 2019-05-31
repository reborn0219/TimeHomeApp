//
//  L_BikeManagerListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/23.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeManagerListTVC.h"

@interface L_BikeManagerListTVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeftLabelWidthLayoutConstraint;


@end

@implementation L_BikeManagerListTVC

- (void)setBikeModel:(L_BikeListModel *)bikeModel {
    
    _bikeModel = bikeModel;
    
    _brandLabel.text = [XYString IsNotNull:bikeModel.brand];/** 品牌 */
    
    NSString *defaultImageUrl = [XYString IsNotNull:bikeModel.fileurl];
//    if (bikeModel.resource.count > 0) {
//        for (L_BikeImageResourceModel *imageModel in bikeModel.resource) {
//            if (imageModel.isdefault.integerValue == 1) {
//                defaultImageUrl = imageModel.resourceurl;
//                break;
//            }
//        }
//    }
    
    /** 自行车类型 0 自行车 1电动车  */
    if (bikeModel.devicetype.integerValue == 1) {
        [_bikeImageView sd_setImageWithURL:[NSURL URLWithString:defaultImageUrl] placeholderImage:[UIImage imageNamed:@"组-电动车"]];
    }
    if (bikeModel.devicetype.integerValue == 0) {
        [_bikeImageView sd_setImageWithURL:[NSURL URLWithString:defaultImageUrl] placeholderImage:[UIImage imageNamed:@"组-自行车"]];
    }
    
    _bottomLeftLabel.text = @"";
    _bottomLeftLabelWidthLayoutConstraint.constant = 0;

    /** 是否共享 0未共享 1共享中 2来自共享 */
    if (bikeModel.isshare.integerValue == 0) {
        _bottomLeftLabel.text = @"";
        _bottomLeftLabelWidthLayoutConstraint.constant = 0;

    }
    if (bikeModel.isshare.integerValue == 1) {
        _bottomLeftLabel.text = @"共享中";
        _bottomLeftLabelWidthLayoutConstraint.constant = 42;

    }
    if (bikeModel.isshare.integerValue == 2) {
        _bottomLeftLabel.text = @"来自共享";
        _bottomLeftLabelWidthLayoutConstraint.constant = 53.5;
    }
    
    if (bikeModel.device.count == 0) {
        
        _addBgView.hidden = NO;
        _motifyBgView.hidden = YES;
        _lockStateBgView.hidden = YES;

        _bottomRightLabel.text = @"";

    }else {
        
        _addBgView.hidden = YES;
        _motifyBgView.hidden = NO;
        _lockStateBgView.hidden = NO;

        _bottomRightLabel.text = @"";

        /** 自行车是否锁定：0否1是 */
        if (bikeModel.islock.integerValue == 0) {
            _lockStateImageView.image = [UIImage imageNamed:@"未锁定"];
            _lockStateLabel.text = @"未锁定";
            _lockStateLabel.textColor = UIColorFromRGB(0x0021D8);
            _bottomRightLabel.text = @"";
            
        }
        if (bikeModel.islock.integerValue == 1) {
            _lockStateImageView.image = [UIImage imageNamed:@"已锁定"];
            _lockStateLabel.text = @"已锁定";
            _lockStateLabel.textColor = kNewRedColor;
            _bottomRightLabel.text = [NSString stringWithFormat:@"%@",[XYString IsNotNull:bikeModel.communitynamelock]];

        }
//        _bottomRightLabel.text = @"金谈固小区";
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (SCREEN_WIDTH == 320) {
        _imageLeftLayoutConstraint.constant = 8;
        _brandLabelLeftLayout.constant = 8;
        _brandLabelRightlayout.constant = 8;
        _bottomLeftLabelLayout.constant = 8;
        _bottomRightLabelLayout.constant = 8;
    }else {
        _imageLeftLayoutConstraint.constant = 20;
        _brandLabelLeftLayout.constant = 15;
        _brandLabelRightlayout.constant = 15;
        _bottomLeftLabelLayout.constant = 15;
        _bottomRightLabelLayout.constant = 15;
    }
    
    _bikeImageView.layer.cornerRadius = 5.f;
    _bikeImageView.clipsToBounds = YES;
    _bikeImageView.backgroundColor = NEW_GRAY_COLOR;
    
    _bottomLeftLabel.text = @"";
    _bottomRightLabel.text = @"";
    _bottomLeftLabelWidthLayoutConstraint.constant = 0;
//    _bottomRightLabel.hidden = YES;
    
    _addBgView.hidden = YES;
    _motifyBgView.hidden = YES;
    _lockStateBgView.hidden = YES;
    
    _infoBgView.tag = 4;
    _addBgView.tag = 3;
    _lockStateBgView.tag = 2;
    _motifyBgView.tag = 1;
    
#warning 按钮加手势，防止侧滑冲突
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allButtonsDidTouchTap:)];
    [_infoBgView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allButtonsDidTouchTap:)];
    [_addBgView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allButtonsDidTouchTap:)];
    [_motifyBgView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allButtonsDidTouchTap:)];
    [_lockStateBgView addGestureRecognizer:tap4];
    
}

- (void)allButtonsDidTouchTap:(UITapGestureRecognizer *)recongnizer {
    
    NSLog(@"点击了===%ld",recongnizer.view.tag);
    
    //1.修改信息 2.锁定 3.添加感应条码 4.跳转详情
    if (self.allButtonDidTouchBlock) {
        self.allButtonDidTouchBlock(recongnizer.view.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
