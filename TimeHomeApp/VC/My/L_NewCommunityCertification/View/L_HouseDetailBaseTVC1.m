//
//  L_HouseDetailBaseTVC1.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailBaseTVC1.h"

@interface L_HouseDetailBaseTVC1 ()

@property (weak, nonatomic) IBOutlet UILabel *authorizationStateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleWidthLayout;

@end

@implementation L_HouseDetailBaseTVC1

- (void)setModel:(L_HouseInfoModel *)model {
    
    _model = model;

    _communityName_Label.text = [XYString IsNotNull:model.communityname];
    _address_Label.text = [XYString IsNotNull:model.address];
    _house_Label.text = [XYString IsNotNull:model.resiname];
    _state_Label.text = @"业主";
    
    //0 已通过认证 1 审核中 2 未通过审核 3 已通过认证 共享 4 已通过认证 出租
    if (model.infoType == 0 || model.infoType == 3 || model.infoType == 4) {

        _leftTitleWidthLayout.constant = 92.f;
        
        _bottomRightTitle_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 92.f - 38 - 30;
        
        _bottomLeftTitle_Label.text = @"认证通过时间";
        
        NSString *timeStr = @"";
        if (model.certtime.length > 16) {
            timeStr = [model.certtime substringToIndex:16];
        }else {
            timeStr = model.certtime;
        }
        NSDate *date = [XYString NSStringToDate:timeStr withFormat:@"YYYY-MM-dd HH:mm"];
        timeStr = [XYString NSDateToString:date withFormat:@"YYYY.MM.dd HH:mm"];
        
        _bottomRightTitle_Label.text = timeStr;
        _state_ImageView.image = [UIImage imageNamed:@"社区认证-已通过认证"];
        
    }
    
    if (model.infoType == 1) {
        
        _leftTitleWidthLayout.constant = 24.f;
        
        _bottomRightTitle_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 24 - 38 - 30;
        
        _bottomLeftTitle_Label.text = @"      ";
        _bottomRightTitle_Label.text = @"物业人员正快马加鞭为您审核中...";
        _state_ImageView.image = [UIImage imageNamed:@"社区认证-审核中"];
        
        
        
    }
    
    if (model.infoType == 2) {
        
        _leftTitleWidthLayout.constant = 77.f;
        
        _bottomRightTitle_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 77 - 38 - 30;
        
        _bottomLeftTitle_Label.text = @"未通过原因";
//        _bottomRightTitle_Label.text = @"业主填写信息与物业预留信息不符，请重新填写";
        _bottomRightTitle_Label.text = [XYString IsNotNull:model.remark];
        _state_ImageView.image = [UIImage imageNamed:@"社区认证-未通过"];
        
    }

    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_bottomRightTitle_Label.frame);
    
    model.height = rectY + 15;
    [self assignmentCertificationStatus];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _address_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 38 - 62 - 30;
    _house_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 38 - 62 - 20 - 74 - 12;

    _bottomRightTitle_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 24 - 38 - 30;
    self.authorizationStateLabel.clipsToBounds = YES;
    self.authorizationStateLabel.layer.cornerRadius = 2.0f;
    self.authorizationStateLabel.textColor = [UIColor whiteColor];
    
}
#pragma mark - 认证状态显示


-(void)assignmentCertificationStatus
{
    
    [self.authorizationStateLabel setHidden:NO];
  
    switch (self.certificationType) {
            
        case CertificationTypeThrough:{
            
            self.authorizationStateLabel.text = @" 已通过 ";
            [self.authorizationStateLabel setBackgroundColor:UIColorFromRGB(0x01C598)];
          
        }
            break;
        case CertificationTypeThroughNotAuthorized:{
            
            self.authorizationStateLabel.text = @" 已通过 ";
            [self.authorizationStateLabel setBackgroundColor:UIColorFromRGB(0x01C598)];
            
         
        }
            break;
        case CertificationTypeNotThrough:{
            //FC0320
            self.authorizationStateLabel.text = @" 未通过 ";
            [self.authorizationStateLabel setBackgroundColor:UIColorFromRGB(0xFC0320)];
            
        
        }
            break;
        case CertificationTypeInReview:{
            
            // F5A623
            self.authorizationStateLabel.text = @" 审核中 ";
            [self.authorizationStateLabel setBackgroundColor:UIColorFromRGB(0xF5A623)];
            
         
        }
            break;
        case CertificationTypeAuthorized:{
            
            
            self.authorizationStateLabel.text = @" 已被授权 ";
            [self.authorizationStateLabel setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
            
        }
            break;
        case CertificationTypeHidden:{
            
            [self.authorizationStateLabel setHidden:YES];
        
            
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
