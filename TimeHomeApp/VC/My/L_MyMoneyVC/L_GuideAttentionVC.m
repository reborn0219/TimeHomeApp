//
//  L_GuideAttentionVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/12/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#define weixin_follow_ts  @"weixin_follow_ts"
#define img_h SCREEN_WIDTH/720.0f*896.0f
#define view_h 200
#import "L_WithdrawMoneyViewController.h"
#import "L_NewMinePresenters.h"

#import "L_GuideAttentionVC.h"

@interface L_GuideAttentionVC ()

@property (nonatomic, strong) UIScrollView *scrollV;
@end
@implementation L_GuideAttentionVC


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self.view addSubview:self.scrollV];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 懒加载初始化scrollerView

 @return _scrollV
 */
-(UIScrollView *)scrollV
{
    if (!_scrollV) {
        
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [_scrollV setBackgroundColor:BLACKGROUND_COLOR];

        UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,img_h)];
        [imgV setBackgroundColor:[UIColor redColor]];
        [imgV setImage:[UIImage imageNamed:weixin_follow_ts]];
        [_scrollV addSubview:imgV];
        
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setBackgroundColor:[UIColor whiteColor]];
        cancleBtn.layer.borderWidth  = 1;
        [cancleBtn setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        cancleBtn.layer.borderColor = NEW_RED_COLOR.CGColor;
        [cancleBtn setTitle:@"取  消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton * areadyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [areadyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [areadyBtn setBackgroundColor:NEW_RED_COLOR];
        [areadyBtn setTitle:@"已完成关注" forState:UIControlStateNormal];
        [areadyBtn addTarget:self action:@selector(areadyAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView   * btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, imgV.frame.size.height, SCREEN_WIDTH,view_h)];
        [btnBackView addSubview:cancleBtn];
        [btnBackView addSubview:areadyBtn];
        [btnBackView setBackgroundColor:[UIColor whiteColor]];
        [_scrollV addSubview:btnBackView];
        
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(btnBackView).offset(20);
            make.right.equalTo(btnBackView).offset(-(SCREEN_WIDTH/2)-20);
            make.top.equalTo(@30);
            make.height.equalTo(@40);

        }];
        
        [areadyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.equalTo(btnBackView).offset((SCREEN_WIDTH/2)+20);
            make.right.equalTo(btnBackView).offset(-20);
            make.top.equalTo(@30);
            make.height.equalTo(@40);

        }];
        [_scrollV setContentSize:CGSizeMake(SCREEN_WIDTH,img_h + 64 +200)];
        
    }
    return _scrollV;
}

#pragma mark -取消点击事件
-(void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark -已经关注点击事件
-(void)areadyAction
{
    
    [self whetherToFocusOn];
}

#pragma mark - 判断用户是否关注公众账号
-(void)whetherToFocusOn
{
    
    @WeakObj(self);
    [L_NewMinePresenters  whetherToFocusOn:_unionid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (resultCode == SucceedCode) {
                
                NSLog(@"----用户是否关注接口-----%@",data);
                NSDictionary * dic = data;
                NSString * isfollow = [dic objectForKey:@"isfollow"];
                if(isfollow.boolValue)
                {
                    
                    L_WithdrawMoneyViewController *withdrawVC = [[UIStoryboard storyboardWithName:@"MyTab" bundle:nil] instantiateViewControllerWithIdentifier:@"L_WithdrawMoneyViewController"];
                    [selfWeak.navigationController pushViewController:withdrawVC animated:YES];
                
                    
                }else{
                    [selfWeak showToastMsg:@"请先关注公众号！" Duration:2.0f];
                }
                
            }else if(resultCode == FailureCode)
            {
                [selfWeak showToastMsg:@"请先关注公众号！" Duration:2.0f];
            }

        });
    }];
    
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
