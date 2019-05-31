//
//  PAUploadImageRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUploadImageRequest.h"
#import "AFURLRequestSerialization.h"

@implementation PAUploadImageRequest
{
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (NSString *)baseUrl{
//    return @"http://192.168.200.179:9091";
    return PA_NEW_NOTICE_URL;
}
- (NSString *)requestUrl{
    NSString * time =[XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"];
    //return [NSString stringWithFormat:@"upload"];
    return @"upload";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data=UIImageJPEGRepresentation(_image, 1.0);
        if (data.length>100*1024) {
            if (data.length>1024*1024) {//1M以及以上
                data=UIImageJPEGRepresentation(_image, 0.7);
            }else if (data.length>512*1024) {//0.5M-1M
                data=UIImageJPEGRepresentation(_image, 0.8);
            }else if (data.length>200*1024) {
                //0.25M-0.5M
                data=UIImageJPEGRepresentation(_image, 0.9);
            }
        }
        NSString *name = @"file.jpeg";
        NSString *formKey = @"file";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

- (id)requestArgument{
    NSDictionary *dict = @{};
    AppDelegate * delegate = GetAppDelegates;
    return @{@"appId":@"APP_H5_WG",
             @"timeStamp":[XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"]};
}


@end
