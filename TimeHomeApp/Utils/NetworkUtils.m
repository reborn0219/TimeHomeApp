//
//  NetworkUtils.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/11/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetworkUtils.h"

@implementation NetworkUtils

/**
 判断url链接是否有效
 */
+ (void)validateUrl:(NSString *)str callBack:(void(^)(BOOL isOK))callback {
    
    NSURL *     candidate;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    if ([XYString isBlankString:str]) {
        callback(NO);
        return;
    }
    
    candidate = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![XYString isBlankString:trimmedStr]) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            candidate = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                candidate = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }else {
        callback(NO);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:candidate];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error %@",error);
        if (error) {
            NSLog(@"不可用");
            callback(NO);
        }else{
            NSLog(@"可用");
            callback(YES);
        }
    }];
    [task resume];
}

@end
