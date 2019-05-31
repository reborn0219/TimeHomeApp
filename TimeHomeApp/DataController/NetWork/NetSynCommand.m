//
//  NetSynCommand.m
//  TimeHomeApp
//
//  Created by us on 16/1/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetSynCommand.h"
#import "Reachability.h"

@implementation NetSynCommand

-(void)execute:(CommandModel *)param CompleteBlock:(CommandCompleteBlock)completeBlock
{
    if (![Reachability isNetAvailableStatus]) {
        completeBlock(@"无网络,请检查您的网络设置!",NONetWorkCode,nil);
        return ;
    }
    NSString * paramstr=[self creatHeardparam:param.paramDict];
    NSMutableURLRequest * request=[self creadRequestForParam:paramstr url:param.commandUrl];
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSInteger responseCode = [(NSHTTPURLResponse *)urlResponse statusCode];
    if (responseCode==200) {
        //将NSData类型的返回值转换成NSString类型
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        completeBlock(result,SucceedCode,error);
        return;
    }
    completeBlock(@"返回数据错误",FailureCode,error);
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
        [param appendFormat:@"%@=%@&",key,obj];
    }];
    [param appendFormat:@"%@=%@",@"softtype",@"1"];
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
    [request setTimeoutInterval:10];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    return request;
    
}
@end
