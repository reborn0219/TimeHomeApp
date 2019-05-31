//
//  NSString+THExtension.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/12.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NSString+THExtension.h"

@implementation NSString (THExtension)

- (BOOL)containsString:(NSString *)aString
{
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}


@end
