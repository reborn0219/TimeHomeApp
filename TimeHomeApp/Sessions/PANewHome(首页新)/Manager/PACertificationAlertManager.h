//
//  PACertificationAlertManager.h
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACertificationAlertManager : NSObject

-(instancetype)initWithVC:(BaseViewController *)VC;

-(void)certificationPopupType:(NSInteger)type;

- (void)goToCertification;

@end
