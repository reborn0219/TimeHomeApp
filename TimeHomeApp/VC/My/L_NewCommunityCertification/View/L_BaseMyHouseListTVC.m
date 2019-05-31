//
//  L_BaseMyHouseListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BaseMyHouseListTVC.h"



@interface L_BaseMyHouseListTVC ()

@property (weak, nonatomic) IBOutlet UIButton *authoryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageViewWidthLayout;
@property (weak, nonatomic) IBOutlet UIImageView *locateImgView;
@property (weak, nonatomic) IBOutlet UILabel *certificationStatusLabel;
@end

@implementation L_BaseMyHouseListTVC

// 授权删除撤销
- (IBAction)authoryAction:(id)sender {
    
    if (self.certificationType == CertificationTypeThroughNotAuthorized) {
        
        //授权
        [self authoryAndCertificationAction];
        
    }else if(self.certificationType == CertificationTypeInReview){
        
        //撤销
        self.cellBtnDidClickBlock(nil, nil, 2);

    }else if (self.certificationType == CertificationTypeNotThrough)
    {
        //删除
        self.cellBtnDidClickBlock(nil, nil, 3);

    }
}
#pragma mark - 授权和去认证
-(void)authoryAndCertificationAction
{
    if (_model.certtype.intValue == 1) {
        
        if (_model.isowner.intValue == 1) {
            
            if (_model.state.intValue == 1) {
                
                if (_model.type.intValue == 1 || _model.type.intValue == 2) {
                    return;
                }
                
            }
            
        }
        
    }
    
    if (self.cellBtnDidClickBlock) {
        self.cellBtnDidClickBlock(nil, nil, 0);
    }
}
#pragma mark - 去授权
- (IBAction)gotoAuthoryBtnDidTouch:(UIButton *)sender {
    
    [self authoryAndCertificationAction];
    
}

- (void)setModel:(L_MyHouseListModel *)model {
    
    _model = model;
    
    _authoryState_Label.hidden = NO;
    _authoryStateTitle_Label.hidden = NO;
    _community_Label.text = [XYString IsNotNull:model.communityname];
    _address_Label.text = [XYString IsNotNull:model.address];
    _house_Label.text = [XYString IsNotNull:model.resiname];
    AppDelegate * appdelget = GetAppDelegates;
    
    [self.locateImgView setHidden:![model.communityid isEqualToString:appdelget.userData.communityid]];
    
//    /**
//     是否业主 1 当前房产业主 0 被授权人
//     */
//    @property (nonatomic, strong) NSString *isowner;
//    /**
//     认证类型：1 房产 0 业主申请
//     */
//    @property (nonatomic, strong) NSString *certtype;
//    /**
//     授权类型 0 业主 1 共享 2 出租
//     */
//    @property (nonatomic, strong) NSString *type;
//    /**
//     0 未认证 1 认证成功 2 认证失败 90 审核中
//     */
//    @property (nonatomic, strong) NSString *state;
    
    if (model.certtype.intValue == 0) {
        
        if (model.state.intValue == 2) {
            
            _authoryState_Label.text = @"业主";

            [self.authoryButton setTitle:@"删除" forState:UIControlStateNormal];
            self.certificationType = CertificationTypeNotThrough;
            
        }
        
        if (model.state.intValue == 90) {
            
            _authoryState_Label.text = @"业主";

            [self.authoryButton setTitle:@"撤销" forState:UIControlStateNormal];
            self.certificationType = CertificationTypeInReview;

        }
        
    }else {
        
        //是否业主 1 当前房产业主 0 被授权人
        if (model.isowner.intValue == 1) {
            
            _authoryState_Label.text = @"业主";
            
            //0 未认证 1 认证成功 2 认证失败 90 审核中
            if (model.state.intValue == 0) {
                
                _rightImageViewWidthLayout.constant = 0;
                _rightState_ImageView.hidden = YES;
                _authoryState_Label.hidden = YES;
                _authoryStateTitle_Label.hidden = YES;
                [_gotoAuthory_Btn setTitle:@"马上认证" forState:UIControlStateNormal];
                self.certificationType = CertificationTypeHidden;
                
            }
            
            if (model.state.intValue == 1) {
                
                // 0 业主 1 共享 2 出租
                if (model.type.intValue == 0) {
                    
                    [self.authoryButton setTitle:@"去授权" forState:UIControlStateNormal];
                    self.certificationType = CertificationTypeThroughNotAuthorized;
                    
                }
                
                if (model.type.intValue == 1) {
                    
                  
                    self.certificationType = CertificationTypeThrough;
                    [self.authoryButton setTitle:@"已授权" forState:UIControlStateNormal];

                 
                }
                
                if (model.type.intValue == 2) {
                    
                    [self.authoryButton setTitle:@"已授权" forState:UIControlStateNormal];
                    self.certificationType = CertificationTypeThrough;
                 
                    
                }
                
            }
            
        }
        
        if (model.isowner.intValue == 0) {
            
          
            self.certificationType = CertificationTypeAuthorized;
            //授权类型 0 业主 1 共享 2 出租
            if (model.type.intValue == 1) {
                
                _authoryState_Label.text = @"共享";
                
            }
            
            if (model.type.intValue == 2) {
                
                _authoryState_Label.text = @"出租";
                
            }
            
        }
        
    }
    
    ///根据状态赋值
    [self assignmentCertificationStatus];
    
    if (model.isNew) {
        self.certificationStatusLabel.hidden = YES;
        self.gotoAuthory_Btn.hidden = YES;
        self.authoryButton.hidden = YES;
        self.authoryState_Label.text = @"业主";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.gotoAuthory_Btn.layer.borderWidth = 1;
    self.gotoAuthory_Btn.layer.cornerRadius = 15;
    self.gotoAuthory_Btn.layer.borderColor = PREPARE_MAIN_BLUE_COLOR.CGColor;
    [self.gotoAuthory_Btn setTitleColor:PREPARE_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    
    self.certificationStatusLabel.clipsToBounds = YES;
    self.certificationStatusLabel.layer.cornerRadius = 2.0f;
    self.certificationStatusLabel.textColor = [UIColor whiteColor];
    
    self.authoryButton.layer.cornerRadius = 14;
    self.authoryButton.layer.borderWidth = 1;
    
    _community_Label.text = @"";
    _address_Label.text = @"";
    _house_Label.text = @"";
    _authoryState_Label.text = @"";
    _rightState_ImageView.image = [UIImage imageNamed:@""];
    
}
#pragma mark - 认证状态显示
-(void)assignmentCertificationStatus
{
    [self.certificationStatusLabel setHidden:NO];
    [self.authoryButton setHidden:NO];
    [self.gotoAuthory_Btn setHidden:YES];

    switch (self.certificationType) {
            
        case CertificationTypeThrough:{
            
            self.certificationStatusLabel.text = @" 已通过 ";
            [self.certificationStatusLabel setBackgroundColor:UIColorFromRGB(0x01C598)];
            self.authoryButton.layer.borderColor = UIColorFromRGB(0x5E5C5D).CGColor;
            [self.authoryButton setTitleColor:UIColorFromRGB(0x5E5C5D) forState:UIControlStateNormal];
        }
            break;
        case CertificationTypeThroughNotAuthorized:{
            
            self.certificationStatusLabel.text = @" 已通过 ";
            [self.certificationStatusLabel setBackgroundColor:UIColorFromRGB(0x01C598)];
            
            self.authoryButton.layer.borderColor = PREPARE_MAIN_BLUE_COLOR.CGColor;
            [self.authoryButton setTitleColor:PREPARE_MAIN_BLUE_COLOR forState:UIControlStateNormal];
        }
            break;
        case CertificationTypeNotThrough:{
            //FC0320
            self.certificationStatusLabel.text = @" 未通过 ";
            [self.certificationStatusLabel setBackgroundColor:UIColorFromRGB(0xFC0320)];
            self.authoryButton.layer.borderColor = UIColorFromRGB(0xFC0320).CGColor;
            [self.authoryButton setTitleColor:UIColorFromRGB(0xFC0320) forState:UIControlStateNormal];
        }
            break;
        case CertificationTypeInReview:{
         
            // F5A623
            self.certificationStatusLabel.text = @" 审核中 ";
            [self.certificationStatusLabel setBackgroundColor:UIColorFromRGB(0xF5A623)];
            
            self.authoryButton.layer.borderColor = UIColorFromRGB(0xF5A623).CGColor;
            [self.authoryButton setTitleColor:UIColorFromRGB(0xF5A623) forState:UIControlStateNormal];
            
        }
            break;
        case CertificationTypeAuthorized:{
            
            
            self.certificationStatusLabel.text = @" 已被授权 ";
            [self.certificationStatusLabel setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
            [self.authoryButton setHidden:YES];
            
        }
            break;
        case CertificationTypeHidden:{
            
            [self.certificationStatusLabel setHidden:YES];
            [self.authoryButton setHidden:YES];
            [self.gotoAuthory_Btn setHidden:NO];

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
