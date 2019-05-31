//
//  PANewHomeBannerViewModel.m
//  TimeHomeApp
//
//  Created by ning on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeBannerViewModel.h"
#import "AppSystemSetPresenters.h"
#import "PANewHomeBannerView.h"

@interface PANewHomeBannerViewModel()
@property (nonatomic,strong) NSArray *bannerArray;
@end

@implementation PANewHomeBannerViewModel

- (void)update{
    [AppSystemSetPresenters getBannerUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.bannerArray = nil;
            
            if(resultCode==SucceedCode){
                self.bannerArray=(NSArray *)data;
                NSURL *url;
                NSDictionary * dic;
                NSMutableArray *urlArray = [NSMutableArray array];
                if (self.bannerArray.count > 0) {
                    for(int i=0;i<self.bannerArray.count;i++){
                        dic=[self.bannerArray objectAtIndex:i];
                        url = [NSURL URLWithString:[dic objectForKey:@"fileurl"]];
                        [urlArray addObject:url];
                    }
                    [self.bannerView updateWithImageUrlArray:urlArray andBannerArray:self.bannerArray isLocalImage:NO];
                }else{
                    NSArray *images = @[
                                        @"社区轮播图@2x.png",
                                        ];
                    [self.bannerView updateWithImageUrlArray:images andBannerArray:self.bannerArray isLocalImage:YES];
                }
            }else{
                NSArray *images = @[
                                    @"社区轮播图@2x.png",
                                    ];
                [self.bannerView updateWithImageUrlArray:images andBannerArray:self.bannerArray isLocalImage:YES];
            }
        });
    }];
}

-(NSArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray= [NSArray array];
    }
    return _bannerArray;
}

@end
