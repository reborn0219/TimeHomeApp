//
//  ReviewDetailVC.m
//  TimeHomeApp
//
//  Created by us on 16/6/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ReviewDetailVC.h"
#import "PostPresenter.h"

@interface ReviewDetailVC ()

@end

@implementation ReviewDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"审核详情页";
    [self.noPassView setHidden:YES];
    [self.reviewingView setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    @WeakObj(self);
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"isPush"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [PostPresenter getTopicInfo:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            selfWeak.RTML = data;
            [selfWeak.topicImgView sd_setImageWithURL:[NSURL URLWithString:selfWeak.RTML.picurl] placeholderImage:PLACEHOLDER_IMAGE];
            selfWeak.topicContentLb.text = selfWeak.RTML.title;
            selfWeak.reasonLb.text = selfWeak.RTML.auditremarks;
            
            if (selfWeak.RTML.state.integerValue==0) {
                [selfWeak.noPassView setHidden:YES];
                [selfWeak.reviewingView setHidden:NO];
            }else if(selfWeak.RTML.state.integerValue == 2)
            {
                [selfWeak.noPassView setHidden:NO];
                [selfWeak.reviewingView setHidden:YES];
            }

        });
        

    } withTopicID:_topicID];
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
