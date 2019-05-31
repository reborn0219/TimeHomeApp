//
//  NetWorks.h
//  TimeHomeApp
//
//  Created by us on 16/2/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 网络请求，用于发送封装好的数据
 **/
#import <Foundation/Foundation.h>

@interface NetWorks : NSObject


///进行网络请求 NSURLSession
+(void)NSURLSessionForRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock;
///进行网络请求 NSURLConnection
+(void)NSURLConnectionForRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock;
///上传文件
+(void)NSURLSessionUpLoadFileForRequst:(NSMutableURLRequest *)request fileData:(NSData *)data CompleteBlock:(CommandCompleteBlock)completeBlock;

///版本升级进行网络请求 NSURLSession
+(void)NSURLSessionVersionForRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock;

//红包项目的errorcode特殊处理
+(void)NSURLSessionForRedBagRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock;

@end
