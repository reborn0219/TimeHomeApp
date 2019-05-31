//
//  BMCityPresenter.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "LifeIDNameModel.h"

@interface BMCityPresenter : BasePresenters
///获得城市区域（/sysarea/getcitycounty）
+(void)getCityCounty:(UpDateViewsBlock)block withCityID:(NSString *)cityid;

@end
