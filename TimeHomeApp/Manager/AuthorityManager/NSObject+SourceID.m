//
//  NSObject+SourceID.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NSObject+SourceID.h"
#import <objc/message.h>

static const char *propertySourceIdKey = "SOURCE_ID";


@implementation NSObject (SourceID)

#pragma mark - sourceid

-(void)setSourceId:(NSString*)sourceid{
    objc_setAssociatedObject(self,propertySourceIdKey,sourceid,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)sourceId{
     return objc_getAssociatedObject(self,propertySourceIdKey);
}

@end
