//
//  NetUpLoadImageCommand.m
//  TimeHomeApp
//
//  Created by us on 16/1/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetUpLoadFileCommand.h"
#import "NetWorks.h"
#import "ImageUitls.h"
@implementation NetUpLoadFileCommand

-(void)execute:(CommandModel *)param CompleteBlock:(CommandCompleteBlock)completeBlock
{

    NSMutableURLRequest * request=[self creadRequestForParam:param.paramDict url:param.commandUrl];
    [NetWorks NSURLSessionForRequst:request CompleteBlock:completeBlock];
}

///生成网络请求
-(NSMutableURLRequest *) creadRequestForParam:(NSDictionary *)paramDic url:(NSString *)url
{
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xFromIOS";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    request.HTTPMethod = @"POST";
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    /***************普通参数***************/
    NSDictionary * params=[paramDic objectForKey:@"hearparam"];
    if (params!=nil) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // 参数开始的标志
            [body appendString:MPboundary];
            [body appendString:@"\r\n"];
            NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
            [body appendString:(disposition)];
            
            [body appendString:@"\r\n"];
            [body appendString:obj];
            [body appendString:@"\r\n"];
        }];
        
        
        // YY--\r\n
//        [body appendString:endMPboundary];
    }
    /***************普通参数结束***************/
    
    
    /***************文件参数***************/
    // 参数开始的标志
    [body appendString:MPboundary];
    [body appendString:@"\r\n"];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [paramDic objectForKey:@"heardKey"], [paramDic objectForKey:@"fileName"]];
    [body appendString:disposition];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", [paramDic objectForKey:@"mimeType"]];
    [body appendString:type];
    
    [body appendString:(@"\r\n")];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSData * data=nil;
    if([[paramDic objectForKey:@"file"] isKindOfClass:[NSString class]])
    {
        NSString * file=[paramDic objectForKey:@"file"];
        if (file!=nil&&![file isEqualToString:@""]) {
            data=[NSData dataWithContentsOfFile:file];
        }
    }
    else if([[paramDic objectForKey:@"file"] isKindOfClass:[UIImage class]])
    {
        UIImage * image=[paramDic objectForKey:@"file"];
        if (image) {
            //判断图片是不是png格式的文件
            if ([ImageUitls typeForImageData:UIImageJPEGRepresentation(image,1.0)]) {
                //返回为JPEG图像。
                data = UIImageJPEGRepresentation(image, 0.3);
            }else {
                //返回为png图像。
                data = UIImagePNGRepresentation(image);
            }
        }
    }
    else if([[paramDic objectForKey:@"file"] isKindOfClass:[NSData class]])
    {
        data=[paramDic objectForKey:@"file"];
    }
    else if([[paramDic objectForKey:@"file"] isKindOfClass:[NSURL class]])
    {
        NSURL * file=[paramDic objectForKey:@"file"];
        if (file!=nil) {
            data=[NSData dataWithContentsOfURL:file];
        }
    }
   
    if(data){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:60];
    //设置http body
    [request setHTTPBody:myRequestData];
    
//    NSLog(@"%@",[[NSString alloc] initWithData:myRequestData encoding:NSUTF8StringEncoding]);
//    NSLog(@"==%@",myRequestData);

    return request;
}

@end
