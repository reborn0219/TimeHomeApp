//
//  NetSoapCommand.m
//  TimeHomeApp
//
//  Created by us on 16/1/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetSoapCommand.h"
#import "NetWorks.h"
#import "Reachability.h"

//webservice命名空间
const NSString * const WEB_NAMESPACE = @"http://webs.cmp.com";

//webservice 消息头1.1
const NSString * const SOAPMSGXML11 = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n<soap:Header>%@</soap:Header>\n<soap:Body>%@</soap:Body>\n</soap:Envelope>";

//webservice 消息头1.2
const NSString * const SOAPMSGXML12 = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope/\">\n<soap12:Header>\n%@</soap12:Header>\n<soap12:Body>\n%@</soap12:Body>\n</soap12:Envelope>";

@implementation NetSoapCommand

-(void)execute:(CommandModel *)param CompleteBlock:(CommandCompleteBlock)completeBlock
{
    
    NSMutableURLRequest  *request=[self asynSoapInvoke:param.command soapurl:param.commandUrl params:param.paramArray];
    if (![Reachability isNetAvailableStatus]) {
        completeBlock(@"无网络,请检查您的网络设置!",NONetWorkCode,nil);
        return ;
    }
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completeBlock(error.localizedDescription,FailureCode,error);
            return;
        }
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (responseCode==200) {
            NSDictionary * jsonDic=[self parserXml:data];
            completeBlock(jsonDic,SucceedCode,error);
        }
        else
        {
            completeBlock([NSString stringWithFormat:@"服务器内部错误,错误码:%ld",responseCode],FailureCode,nil);
        }

        
    }];
    [task resume];
}

//异步请求soap 带url
-(NSMutableURLRequest *) asynSoapInvoke:(NSString *)method soapurl:(NSString *)soapurl params:(NSArray *)params
{
    
    NSString * post=[self creatSoapParms:method params:params];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *soapAction = [NSString stringWithFormat:@"%@/%@",WEB_NAMESPACE , method  ];
    
    NSURL *url=[NSURL URLWithString:soapurl];
    NSMutableURLRequest  *request=[[NSMutableURLRequest alloc]init];
    
    [request setTimeoutInterval: 10 ];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setURL: url ] ;
    [request setHTTPMethod:@"POST"];
     [request setTimeoutInterval:20];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content- Length"];
    [request setHTTPBody:postData];
    return request;
}
//生成soap请求参数xml
-(NSString *) creatSoapParms:(NSString *)method params:(NSArray *)params
{
    NSMutableString * param = [[ NSMutableString alloc ] init ] ;
    [ param appendString:@"<"];
    [ param appendString:method];
    [ param appendString:@" xmlns=\""];
    [ param appendString:WEB_NAMESPACE];//添加命名空间
    [ param appendString:@"\">\n"];
    for (NSDictionary *item in params) {
        NSString * key=[[item allKeys] objectAtIndex:0];
        [param appendFormat:@"<%@>",key];
        if ([[item objectForKey:key] isKindOfClass:[NSNumber class]]) {
            [param appendString:((NSNumber *)[item objectForKey:key]).stringValue];
        }
        else
        {
            [param appendString:[item objectForKey:key]];
        }
        
        [param appendFormat:@"</%@>",key];
    }
    [ param appendFormat:@"</%@>\n",method];
    
    NSString *post =[ NSString stringWithFormat:SOAPMSGXML11,@"",param];
    //    NSLog(@"========postData============\n%@\n", post);
    return post;
}


//解析xml取出json数据
-(NSDictionary *) parserXml:(NSData *) data
{
    NSDictionary * json=nil;
    NSError *err;
    TBXML *tbxml=[[TBXML alloc]initWithXMLData:data error:&err];
    TBXMLElement *root = tbxml.rootXMLElement;//得到根路径
    
    //    NSLog(@"=root=%@",[TBXML elementName:root]);
    if (root) {
        TBXMLElement *body = [TBXML childElementNamed:@"soapenv:Body" parentElement:root];
        //        NSLog(@"=body=%@",[TBXML elementName:body]);
        if(body)
        {
            TBXMLElement * response=body->firstChild;
            //            NSLog(@"=response=%@",[TBXML elementName:response]);
            if (response) {
                TBXMLElement * retunjson=response->firstChild;
                //                NSLog(@"=retunjson=%@",[TBXML elementName:retunjson]);
                if (retunjson) {
                    NSString *jsonstr=[TBXML textForElement:retunjson];
                    NSLog(@"=jsonstr=%@",jsonstr);
                    json=[self dictionaryWithJsonString:jsonstr];
                }
                
            }
        }
        
        
    }
    return json;
}

/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}


@end
