//
//  PAAuthorityManager.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAAuthorityModel.h"

@interface PAAuthorityManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(PAAuthorityManager)

//从服务端获取指定社区的权限
-(void)fetchAuthorityWithCommunityId:(NSString*)communityId;

//验证某社区的资源权限,返回BOOL判断事件是否需要拦截，如果不指定communityId则代表用户当前选择的社区
-(BOOL)verifyAuthorityWithCommunityId:(NSString*)communityId sourceId:(NSString*)sourceId;

//更新用户权限
-(void)updateAuthorityWithcommunityId:(NSString *)communityId andArray:(NSArray*)authorityArray;
@end
