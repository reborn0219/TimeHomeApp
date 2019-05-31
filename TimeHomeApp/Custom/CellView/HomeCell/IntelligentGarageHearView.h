//
//  IntelligentGarageHearView.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  智能车库HeadView
 *
 */
#import <UIKit/UIKit.h>


@interface IntelligentGarageHearView : UICollectionReusableView
/**
 *  我管理车位
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_MyGarages;

@property (weak, nonatomic) IBOutlet UIButton *btn_userInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLayout;

@end
