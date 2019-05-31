//
//  NetAesDataCommand.m
//  TimeHomeApp
//
//  Created by us on 16/2/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetAesDataCommand.h"
#import "NetWorks.h"

@implementation NetAesDataCommand
-(void)execute:(CommandModel *)param CompleteBlock:(CommandCompleteBlock)completeBlock
{
    NSString * paramstr=[self creatHeardparam:param.paramDict];
    NSMutableURLRequest * request=[self creadRequestForParam:paramstr url:param.commandUrl];
    [NetWorks NSURLSessionForRequst:request CompleteBlock:completeBlock];
}
///生成post参数
-(NSString *)creatHeardparam:(NSDictionary *)params
{
    NSMutableString * param=[[NSMutableString alloc]init];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [param appendFormat:@"%@",obj];
        if (!stop) {
            //            [param appendString:@"&"];
        }
    }];
    return param;
}

///生成网络请求
-(NSMutableURLRequest *) creadRequestForParam:(NSString *)param url:(NSString *)url
{
    
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    //    NSString *post = [self creatHeardparam:heard];
    
    NSLog(@"post:%@",param);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
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
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    return request;
    
}

@end
