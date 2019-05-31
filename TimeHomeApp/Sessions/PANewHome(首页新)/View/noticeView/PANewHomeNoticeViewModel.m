//
//  PANewHomeNoticeViewModel.m
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeNoticeViewModel.h"
#import "CommunityManagerPresenters.h"
#import "PANewHomeNoticeCell.h"

@interface PANewHomeNoticeViewModel()



@end

@implementation PANewHomeNoticeViewModel

- (void)update{
    [CommunityManagerPresenters getTopPropertyNoticeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode){
                NSArray *notificArray=(NSArray *)data;
                if(notificArray!=nil&&notificArray.count>0) {
                    self.noticeCell.notificArray = notificArray;
                }
            }
        });
    }];
}


@end
