//
//  HDActivityPresenter.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserActivity.h"

@interface HDActivityPresenter : BasePresenters

///获得开展中的活动列表（/activity/gettopactivitinglist）请求参数：token 15021
+(void)getTopactivitingList:(UpDateViewsBlock)block;
///获得开展中的活动列表（/activity/getactivitinglist）请求参数：token 15021
+(void)getActivitingListFor:(NSString *)page  updataBlock:(UpDateViewsBlock)block;

///我参加的活动（/activity/getuseractivity）请求参数：token 15021 page  1
+(void)getActivitingListPage:(NSInteger)page WithBlock:(UpDateViewsBlock)block;
@end

