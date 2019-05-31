//
//  SigninPopVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SigninPopVC.h"
#import "SigninCell.h"
#import "SiginRulesVC.h"
#import "SigninModel.h"
#import "UserPointAndMoneyPresenters.h"
#import "ZG_ScratchViewController.h"

///签到背景图片长宽比
#define  SIGNIN_BACK_IMG_SCALE  (958.0f/630.17f)
///签到文字背景view距离顶部高度和背景图片高度比例
#define  SIGNIN_LB_VIEW_TOP_SCALE (958.0f/193.0f)

///签到日历距离顶部高度和背景图片高度比例

#define  SIGNIN_LB_VIEW_TOP_SCALE (958.0f/193.0f)

@interface SigninPopVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) SigninModel *SML;
@property (nonatomic, assign) BOOL ishow;
@end

@implementation SigninPopVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _ishow = YES;
    
    _lb_back_view_layout_top.constant = (SCREEN_WIDTH - 80.0f)*SIGNIN_BACK_IMG_SCALE/SIGNIN_LB_VIEW_TOP_SCALE;
    _collectionView_center_layout.constant = SCREEN_WIDTH/320.0f*30.0f;
    
    [self.view layoutIfNeeded];
    _sigininCollectionV.delegate =self;
    _sigininCollectionV.dataSource = self;
    _sigininCollectionV.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    _sigininCollectionV.layer.borderWidth = 1.5;
    [_sigininCollectionV registerNib:[UINib nibWithNibName:@"SigninCell" bundle:nil] forCellWithReuseIdentifier:@"SigninCell"];
    [_signinPopImg setAlpha:0];
    [_signinPopLb  setAlpha:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self assignmentOperation];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QianDao];
    
//    [TalkingData trackPageBegin:@"qiandao"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QianDao}];
    
//    [TalkingData trackPageEnd:@"qiandao"];
}
#pragma mark - 初始化
+(instancetype)shareSigninPopVC {
    
    SigninPopVC * shareSigninPopVC= [[SigninPopVC alloc] initWithNibName:@"SigninPopVC" bundle:nil];
    return shareSigninPopVC;
    
}

-(void)showInVC:(UIViewController *)VC with:(NSDictionary *)dic {
    
    _nextVC = VC;
    
    _SML = [SigninModel mj_objectWithKeyValues:dic];
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [VC presentViewController:self animated:YES completion:^{
    }];
    
}
#pragma mark - 关闭VC
-(void)dismiss {
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if(_block)
    {
        _block(@(_ishow),nil,0);
    }
    
    if (_SML.isfirst.boolValue) {
        
        if(!_SML.issign.boolValue){
            [AppDelegate showToastMsg:@"您今日还没有签到，您可以点击“我的”模块中继续签到!" Duration:2.5];
        }
    }
    
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SigninCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SigninCell" forIndexPath:indexPath];
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(SigninCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item<_SML.monthdays.integerValue) {
        
        if (_SML.isactset.boolValue) {
            
            NSArray *  arr = [_SML.positions componentsSeparatedByString:@","];
            NSString * indexStr = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
            
            if ([DataDealUitls stringInArray:indexStr:arr]) {
                
                
                cell.numLb.text = @"";
                
                NSArray *  openarr = [_SML.useropentimes componentsSeparatedByString:@","];

                if (![XYString isBlankString:_SML.useropentimes]&&[DataDealUitls stringInArray:indexStr:openarr]) {
                    
                    [cell.backImg setImage:[UIImage imageNamed:@"宝箱1"]];

                }else
                {
                    [cell.backImg setImage:[UIImage imageNamed:@"宝箱"]];

                }
                
            }else if(indexPath.item<_SML.monthsignnum.integerValue)
            {
                [cell.backImg setImage:[UIImage imageNamed:@"红圈"]];
                cell.numLb.text = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];

            }else
            {
                
                [cell.backImg setImage:[UIImage imageNamed:@""]];
                cell.numLb.text = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];

            }
        }else
        {
            
            if(indexPath.item<_SML.monthsignnum.integerValue)
            {
                [cell.backImg setImage:[UIImage imageNamed:@"红圈"]];
                cell.numLb.text = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
                
            }else
            {
                
                [cell.backImg setImage:[UIImage imageNamed:@""]];
                cell.numLb.text = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
                
            }
            
        }
        
    }else
    {
        [cell.backImg setImage:[UIImage imageNamed:@""]];
        cell.numLb.text = @"";
        
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 0);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_WIDTH-130.0)/7.0f,(SCREEN_WIDTH-130.0)/7.0f);
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 35;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    return [UICollectionReusableView new];
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0 ;
}

#pragma mark - 关闭弹框
- (IBAction)closeSigninVC:(id)sender {
    
    [self dismiss];
}
#pragma mark - 签到规则跳转
- (IBAction)signinRulesAction:(id)sender {
    
    SiginRulesVC * srVC = [[SiginRulesVC alloc]init];
    srVC.hidesBottomBarWhenPushed = YES;
    [_nextVC.navigationController pushViewController:srVC animated:YES];
    [self dismiss];
    
}
#pragma mark - 签到
- (IBAction)siginAction:(id)sender {
    
    
    UIButton * btn = (UIButton *)sender;
    
    if ([btn.titleLabel.text isEqualToString:@"签    到"]){
        
        @WeakObj(self);
        [UserPointAndMoneyPresenters addSignLogUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(resultCode==SucceedCode)
                {
                    
                    NSLog(@"签到返回信息：-----%@",data);
                    _ishow = NO;
                    
                    NSString *  remainingdays = [NSString stringWithFormat:@"%@",[data objectForKey:@"remainingdays"]];
                    
                    NSString *  remainluckdrawtimes = [NSString stringWithFormat:@"%@",[data objectForKey:@"remainluckdrawtimes"]];

                    
                    NSDictionary * dic=(NSDictionary *)data;
                    NSString * tmp=[NSString stringWithFormat:@"签到成功！积分+%@",[[dic objectForKey:@"integral"] stringValue]];
                    
                    _SML.monthsignnum = [NSString stringWithFormat:@"%ld",_SML.monthsignnum.integerValue + 1];
                    _SML.issign = @"1";
                 
                    _SML.remainingdays = remainingdays;
                    _SML.remainluckdrawtimes = remainluckdrawtimes;
                    
                    
                    [self siginPopViewAnimation];
                    _signinPopLb.text = tmp;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isSignup"];//设置签到状态为1
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [selfWeak assignmentOperation];
                    [selfWeak.sigininCollectionV reloadData];
                    
                }else
                {
                    
                    
                }
                
            });
            
        }];
        

    }else if ([btn.titleLabel.text isEqualToString:@"去抽奖"])
    {
        
        ZG_ScratchViewController * zgsVC = [[ZG_ScratchViewController alloc]init];
        [zgsVC getReadytime:_SML.readytime frequency:_SML.frequency];
        zgsVC.hidesBottomBarWhenPushed = YES;
        [_nextVC.navigationController pushViewController:zgsVC animated:YES];
        [self dismiss];
        
    }
    
    
    
    
    

}

#pragma mark - 签到提示框动画
-(void)siginPopViewAnimation
{
 
    AppDelegate * appDelget = GetAppDelegates;

    
    _signinPopLb.alpha  = 1;
    _signinPopImg.alpha = 1;

    CGFloat jf;
    
    if (!appDelget.isupgrade.boolValue) {
        
        jf = 3.0f;
    }else
    {
        jf = 2.0f;
    }
    [UIView animateWithDuration:3 animations:^{
        

        if (!appDelget.isupgrade.boolValue) {

            _signinPopImg.transform = CGAffineTransformTranslate(_signinPopImg.transform, 0,-12);
            _signinPopLb.transform = CGAffineTransformTranslate(_signinPopLb.transform, 0,-12);

            _signinPopImg.alpha = 0;
            _signinPopLb.alpha  = 0;
        }else
        {
            _signinPopLb.alpha  = 0.5;
            _signinPopImg.alpha = 1;
        }
        
    } completion:^(BOOL finished) {

        if (appDelget.isupgrade.boolValue) {
        
            _signinPopImg.alpha = 1;
            _signinPopLb.text = [NSString stringWithFormat:@"恭喜升级到LV%@!",appDelget.userData.level];
            _signinPopLb.alpha  = 1;

            [UIView animateWithDuration:3 animations:^{
                
                _signinPopLb.alpha  = 0;
                _signinPopImg.alpha = 0;
                _signinPopImg.transform = CGAffineTransformTranslate(_signinPopImg.transform, 0,-12);
                _signinPopLb.transform = CGAffineTransformTranslate(_signinPopLb.transform, 0,-12);


            } completion:^(BOOL finished) {
                
                
                
            }];
            
        }else
        {
            _signinPopLb.alpha  = 0;
            _signinPopImg.alpha = 0;

        }
        
    }];

}
-(void)assignmentOperation{
    
    if (_SML.issign.boolValue) {
        
        if ([_SML.remainingdays isEqualToString:@"0"]&&_SML.remainluckdrawtimes.integerValue>0) {
            
            
            [_againSignumLb setHidden:YES];
            [_siginBtn setBackgroundImage:[UIImage imageNamed:@"去抽奖钮"] forState:UIControlStateNormal];
            [_siginBtn setTitle:@"去抽奖" forState:UIControlStateNormal];
            [_siginBtn setTitleColor:UIColorFromRGB(0xFEF080) forState:UIControlStateNormal];
            
        }else
        {
            
            if (_SML.remainingdays.integerValue>0) {
                
                [_againSignumLb setHidden:NO];
                _againSignumLb.text = [NSString stringWithFormat:@"再签到%@天就可以抽奖了哦~",_SML.remainingdays];

            }else
            {
                
                [_againSignumLb setHidden:YES];
                _againSignumLb.text = @"";

            }

            [_siginBtn setBackgroundImage:[UIImage imageNamed:@"不能签钮"] forState:UIControlStateNormal];
            [_siginBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
            [_siginBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
            
        }

    }else
    {
        
        [_againSignumLb setHidden:NO];
        
        if (_SML.remainingdays.integerValue>0) {

            _againSignumLb.text = [NSString stringWithFormat:@"再签到%@天就可以抽奖了哦~",_SML.remainingdays];
            
        }else
        {
            _againSignumLb.text = @"";
        }
        
        [_siginBtn setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
        [_siginBtn setTitle:@"签    到" forState:UIControlStateNormal];
        [_siginBtn setTitleColor:UIColorFromRGB(0xE51915) forState:UIControlStateNormal];

    }
    
    NSString * signNumStr =  [NSString stringWithFormat:@"当月累计签到%@天",_SML.monthsignnum];
    ///连续签到天数赋值
    NSMutableAttributedString *signAtrNumStr = [[NSMutableAttributedString alloc] initWithString:signNumStr];
    NSUInteger startLocation = [signNumStr rangeOfString:@"到"].location+1;
    NSUInteger endLocation =   [signNumStr rangeOfString:@"天"].location;
    NSRange range = NSMakeRange(startLocation, endLocation - startLocation);
    [signAtrNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    _signinNumLb.attributedText = signAtrNumStr;
    
}
@end
