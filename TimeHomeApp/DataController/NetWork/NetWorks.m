//
//  NetWorks.m
//  TimeHomeApp
//
//  Created by us on 16/2/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetWorks.h"
#import "Reachability.h"
#import "MessageAlert.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import "LogInPresenter.h"
#import "MsgAlertView.h"

@implementation NetWorks

///进行网络请求 NSURLSession
+(void)NSURLSessionForRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock
{
    if (![Reachability isNetAvailableStatus]) {
        
//        MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
//        UIViewController * currVC=[(AppDelegate *)[UIApplication sharedApplication].delegate getCurrentViewController];
//        msgAlert.isHiddLeftBtn=YES;
//        [msgAlert showInVC:currVC withTitle:@"您的网络慢或无网络,请检查您的网络设置!" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
            [msgV showMsgViewForMsg:@"您的网络好像不太给力，请检查网络!" btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                
            }];
        });
        completeBlock(@"您的网络好像不太给力，请检查网络!",NONetWorkCode,nil);
    }else
    {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSURLSession *session =[NSURLSession sharedSession];
        NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error Cord - -- - - -%@",error);
                completeBlock(error.localizedDescription,FailureCode,error);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            });
            
            NSInteger responseCode=[(NSHTTPURLResponse *)response statusCode];
            if (responseCode==200) {
                NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
             
                if([XYString isBlankString:[NSString stringWithFormat:@"%@",[dicJson objectForKey:@"errcode"]]]){
                    
                    completeBlock(dicJson,FailureCode,error);
                    
                }else{
                    
                    NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
                    if(errcode==10000)///登录失效
                    {
                        [LogInPresenter ReLogInFor:data];
                        completeBlock(data,TOKENInvalid,nil);                                                
                    }
                    else if(errcode==0)
                    {
                        completeBlock(data,SucceedCode,nil);
                    }
                    else
                    {
                        completeBlock(data,SucceedCode,nil);
                    }
                }
            }
            else
            {
                NSLog(@"网络请求错误码为：%ld",(long)responseCode);
                completeBlock([NSString stringWithFormat:@"服务器压力太大出问题了,请稍后再试!"],FailureCode,error);
                
            }
            
        }];
        [task resume];
    }

}
///进行网络请求 NSURLConnection
+(void)NSURLConnectionForRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock
{
    if (![Reachability isNetAvailableStatus]) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
            [msgV showMsgViewForMsg:@"您的网络好像不太给力，请检查网络!" btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
            }];
        });
        completeBlock(@"您的网络好像不太给力，请检查网络!",NONetWorkCode,nil);
    }
    else
    {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse *response,NSData *data,NSError *connectionError)
         {
             if (connectionError) {
                 completeBlock(connectionError.localizedDescription,FailureCode,connectionError);
                 return;
             }
             
             NSInteger responseCode=[(NSHTTPURLResponse *)response statusCode];
             if (responseCode==200) {
                 NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
                 //“errcode”:0
                 //,”errmsg”:””
                 NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
                 if(errcode==10000)///登录失效
                 {
                     [LogInPresenter ReLogInFor:data];
                     completeBlock(data,TOKENInvalid,nil);
                 }
                 else if(errcode==0)
                 {
                     completeBlock(data,SucceedCode,nil);
                 }
                 else
                 {
                     completeBlock(data,SucceedCode,nil);
                 }

             }
             else
             {
                 
                 NSLog(@"");
                 
                 completeBlock([NSString stringWithFormat:@"服务器压力太大出问题了,请稍后再试!"],FailureCode,nil);
                 
             }
             
         }];

    }
}
///上传文件
+(void)NSURLSessionUpLoadFileForRequst:(NSMutableURLRequest *)request fileData:(NSData *)data CompleteBlock:(CommandCompleteBlock)completeBlock
{
    if (![Reachability isNetAvailableStatus]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
            [msgV showMsgViewForMsg:@"您的网络好像不太给力，请检查网络!" btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
            }];
        });
         completeBlock(@"您的网络好像不太给力，请检查网络!",NONetWorkCode,nil);
        return ;
    }
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
            completeBlock(error.localizedDescription,FailureCode,error);
            return;
        }
        
        NSInteger responseCode=[(NSHTTPURLResponse *)response statusCode];
        if (responseCode==200) {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            if(errcode==10000)///登录失效
            {
                [LogInPresenter ReLogInFor:data];
                completeBlock(data,TOKENInvalid,nil);
            }
            else if(errcode==0)
            {
                completeBlock(data,SucceedCode,nil);
            }
            else
            {
                completeBlock(data,SucceedCode,nil);
            }

        }
        else
        {
            completeBlock([NSString stringWithFormat:@"服务器压力太大出问题了,请稍后再试!"],FailureCode,nil);
            
        }
    }];
    [uploadTask resume];

}


///进行网络请求 NSURLSession
+(void)NSURLSessionVersionForRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock
{
    
    if (![Reachability isNetAvailableStatus]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
            [msgV showMsgViewForMsg:@"您的网络好像不太给力，请检查网络!" btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                
            }];
        });
        completeBlock(@"您的网络好像不太给力，请检查网络!",NONetWorkCode,nil);
    }else
    {
        NSURLSession *session =[NSURLSession sharedSession];
        NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                completeBlock(error.localizedDescription,FailureCode,error);
                return;
            }
            
            NSInteger responseCode=[(NSHTTPURLResponse *)response statusCode];
            if (responseCode==200) {
                completeBlock(data,SucceedCode,nil);
            }
            else
            {
                completeBlock([NSString stringWithFormat:@"服务器压力太大出问题了,请稍后再试!"],FailureCode,error);
                
            }
            
        }];
        [task resume];
    }
    
}

///进行网络请求 NSURLSession
+(void)NSURLSessionForRedBagRequst:(NSMutableURLRequest *)request CompleteBlock:(CommandCompleteBlock)completeBlock
{
    if (![Reachability isNetAvailableStatus]) {
          dispatch_async(dispatch_get_main_queue(), ^{
            MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
            [msgV showMsgViewForMsg:@"您的网络好像不太给力，请检查网络!" btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            }];
        });
        completeBlock(@"您的网络好像不太给力，请检查网络!",NONetWorkCode,nil);
    }else
    {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSURLSession *session =[NSURLSession sharedSession];
        NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error Cord - -- - - -%@",error);
                completeBlock(error.localizedDescription,FailureCode,error);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            });
            
            NSInteger responseCode=[(NSHTTPURLResponse *)response statusCode];
            if (responseCode==200) {
                NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
                
                if([XYString isBlankString:[NSString stringWithFormat:@"%@",[dicJson objectForKey:@"code"]]]){
                    
                    completeBlock(dicJson,FailureCode,error);
                    
                }else{
                    
                    NSInteger errcode=[[dicJson objectForKey:@"code"]intValue];
                    if(errcode==10000)///登录失效
                    {
                        [LogInPresenter ReLogInFor:data];
                        completeBlock(data,TOKENInvalid,nil);
                    }
                    else if(errcode==0)
                    {
                        completeBlock(data,SucceedCode,nil);
                    }
                    else
                    {
                        completeBlock(data,SucceedCode,nil);
                    }
                }
            }
            else
            {
                NSLog(@"网络请求错误码为：%ld",(long)responseCode);
                completeBlock([NSString stringWithFormat:@"服务器压力太大出问题了,请稍后再试!"],FailureCode,error);
                
            }
            
        }];
        [task resume];
    }
    
}

@end
