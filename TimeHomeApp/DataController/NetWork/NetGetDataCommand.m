//
//  NetGetDataCommand.m
//  TimeHomeApp
//
//  Created by us on 16/1/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetGetDataCommand.h"
#import "NetWorks.h"
#import "Reachability.h"
#import "EncryptUtils.h"

@implementation NetGetDataCommand

-(void)execute:(CommandModel *)param CompleteBlock:(CommandCompleteBlock)completeBlock
{
    NSString * paramstr;
    NSMutableURLRequest * request;
    if(param.HTTPMethod!=nil&&[param.HTTPMethod isEqualToString:@"get"])
    {
        request=[self creadGeRequestForUrl:param.commandUrl];
    }
    else
    {
        paramstr=[self creatHeardparam:param.paramDict];
        request=[self creadRequestForParam:paramstr url:param.commandUrl];
        NSLog(@"请求参数======%@",paramstr);
        NSLog(@"请求链接======%@",param.commandUrl);
        
        NSLog(@"网络请求拼接参数链接-wlqqurl-------%@?%@",param.commandUrl,paramstr);
        
    }
    [NetWorks NSURLSessionForRequst:request CompleteBlock:completeBlock];
}
///生成post参数
-(NSString *)creatHeardparam:(NSDictionary *)params
{
    if(params==nil)
    {
        return @"";
    }
    NSMutableString * param=[[NSMutableString alloc]init];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString * urlparam = [EncryptUtils urlEncoding:obj];//url编码参数
        [param appendFormat:@"%@=%@&",key,urlparam];
        
    }];

    [param appendFormat:@"%@=%@",@"softtype",@"1"];
    [param appendFormat:@"&%@=%@",@"internettype",[AppDelegate getNetWorkStates]];

    NSString *  tmpparam=param;
    return tmpparam;
}
///生成网络请求
-(NSMutableURLRequest *) creadRequestForParam:(NSString *)param url:(NSString *)url
{
    
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:url]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    return request;
    
}

///生成网络请求
-(NSMutableURLRequest *) creadGeRequestForUrl:(NSString *)url
{
    ///网络请求之前参数URL编码 edit by ls 2016.12.12
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"GET"];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
    
}

@end
