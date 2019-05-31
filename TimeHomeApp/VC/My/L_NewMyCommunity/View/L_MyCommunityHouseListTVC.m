//
//  L_MyCommunityHouseListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyCommunityHouseListTVC.h"

@implementation L_MyCommunityHouseListTVC

- (void)setResidenceModel:(OwnerResidence *)residenceModel {
    _residenceModel = residenceModel;
    
    [self layoutIfNeeded];
    
    if (_type == 1) {
        CGFloat maxY = CGRectGetMaxY(_leftLabel1.frame);
        residenceModel.height = maxY + 15;
    }else if (_type == 2 || _type == 4 || _type == 5) {
        CGFloat maxY = CGRectGetMaxY(_houseAddressLabel.frame);
        residenceModel.height = maxY + 15;
    }else {
        CGFloat maxY = CGRectGetMaxY(_deleteButton.frame);
        residenceModel.height = maxY + 13;
    }
    
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    _leftLabel1.hidden = YES;
    _leftLabel2.hidden = YES;
    _leftLabel3.hidden = YES;
    _nickNameLabel.hidden = YES;
    _rentToDateLabel.hidden = YES;
    _phoneNumLabel.hidden = YES;
    _rentDateRangeLabel.hidden = YES;
    _bottomLineView.hidden = YES;
    _deleteButton.hidden = YES;
    _rentButton.hidden = YES;
    
    /** 1.租赁中 2.出租 3.已出租 4.认证中 5.认证失败 */
    
    switch (type) {
        case 1:
        {
            _leftLabel1.hidden = NO;
            _rentToDateLabel.hidden = NO;
            
            _rentToDateLabel.text = @"2017-05-23 12:12:12";
            _nickNameLabel.text = @"";
            _leftLabel1.text = @"租期至";
            _rentStateLabel.text = @"租赁中";
            _rentStateLabel.textColor = kNewRedColor;
        }
            break;
        case 2:
        {
            _rentToDateLabel.text = @"";
            _nickNameLabel.text = @"";
            _rentStateLabel.text = @"出    租";
            _rentStateLabel.textColor = GREEN_COLOR;
        }
            break;
        case 3:
        {
            _leftLabel1.hidden = NO;
            _leftLabel2.hidden = NO;
            _leftLabel3.hidden = NO;
            _nickNameLabel.hidden = NO;
            _phoneNumLabel.hidden = NO;
            _rentDateRangeLabel.hidden = NO;
            _bottomLineView.hidden = NO;
            _deleteButton.hidden = NO;
            _rentButton.hidden = NO;
            
            _nickNameLabel.text = @"小  小";
            _rentToDateLabel.text = @"";

            _leftLabel1.text = @"租赁人：";
            _rentStateLabel.text = @"已出租";
            _rentStateLabel.textColor = kNewRedColor;
        }
            break;
        case 4:
        {
            _nickNameLabel.text = @"";
            _rentToDateLabel.text = @"";

            _rentStateLabel.text = @"认证中";
            _rentStateLabel.textColor = kNewRedColor;
        }
            break;
        case 5:
        {
            _nickNameLabel.text = @"";
            _rentToDateLabel.text = @"";

            _rentStateLabel.text = @"认证失败";
            _rentStateLabel.textColor = kNewRedColor;
        }
            break;
        default:
        {
            
        }
            break;
    }
    
}
- (IBAction)twoButtonsDidTouch:(UIButton *)sender {
    //tag 1.移除 2.续租
    if (self.buttonTouchBlock) {
        self.buttonTouchBlock(sender.tag);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    _deleteButton.layer.borderColor = kNewRedColor.CGColor;
    _deleteButton.layer.borderWidth = 1;
    
    _rentButton.layer.borderWidth = 1;
    _rentButton.layer.borderColor = kNewRedColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
