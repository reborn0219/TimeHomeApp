//
//  ZG_ ScratchViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/7/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZG_ScratchViewController.h"
#import "MDScratchImageView.h"
#import "ImageUitls.h"

#import "ZG_ScratchPresenters.h"

#import "scratchTableViewCell.h"
#import "L_ZhongJiangRecordViewController.h"//中奖纪录

#import "ScratchRuleViewController.h"

@interface ZG_ScratchViewController ()
<MDScratchImageViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    MDScratchImageView *topImageView;//头部视图
    
    UIScrollView *scroll;
    
    NSString *isScratch;//是否刮奖判断:0未刮，1已刮
    
    NSDictionary *dataDict_;
    NSArray *dataArr_;
    
    NSTimer *connectTimer;//定时器
    
    UITableView *tableView_;
    
    UILabel *scratchNumberLal;//抽奖剩余次数
    
    UILabel *scratchInfo;//中奖区副标题
    UILabel *scratchName;//中奖奖品
    
    UIImageView *good1;//商品1图片
    UIImageView *good2;//商品2图片
    UIImageView *good3;//商品3图片
    
    UIImageView *ScratchBack;//中奖区背景
    
    CGPoint center;//抽奖按钮中点
    
    UIButton *goToShop;//去积分商城
    UIButton *againScratch;//继续抽奖按钮
    
    int scrollTag;//自动滚动标记
    
    NSString *readytime_;//准备抽奖的宝箱位置-第几个宝箱
    NSString *frequency_;//抽奖对应签到的累计天数
    
    NSString *ruleStr;//抽奖规则字段
}

@end

@implementation ZG_ScratchViewController

#pragma mark - http method

-(void)getSysrecordList{
    
    [ZG_ScratchPresenters getSysrecordListWithUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                dataDict_ = dict[@"map"];
                dataArr_ = dict[@"list"];
                
                ruleStr = [NSString stringWithFormat:@"%@",dataDict_[@"drawrule"]];
                
                NSArray *piclistArr = dataDict_[@"piclist"];
                
                NSString *url1 = [NSString stringWithFormat:@""];
                NSString *url2 = [NSString stringWithFormat:@""];
                NSString *url3 = [NSString stringWithFormat:@""];
                if (piclistArr.count > 0) {
                    NSDictionary *urlDict1 = piclistArr[0];
                    url1 = [NSString stringWithFormat:@"%@",urlDict1[@"picurl"]];
                    [ImageUitls saveAndShowImage:good1 withName:url1];
                }
                if (piclistArr.count > 1) {
                    NSDictionary *urlDict2 = piclistArr[1];
                    url2 = [NSString stringWithFormat:@"%@",urlDict2[@"picurl"]];
                    [ImageUitls saveAndShowImage:good2 withName:url2];
                }
                
                if (piclistArr.count > 2) {
                    NSDictionary *urlDict3 = piclistArr[2];
                    url3 = [NSString stringWithFormat:@"%@",urlDict3[@"picurl"]];
                    [ImageUitls saveAndShowImage:good3 withName:url3];
                }
                
                scratchNumberLal.text = [NSString stringWithFormat:@"今日还可抽奖%@次",dataDict_[@"remainluckdrawtimes"]];
                
                int remainluckdrawtimes = [dataDict_[@"remainluckdrawtimes"] intValue];
                
                if (remainluckdrawtimes > 0) {
                    
                    goToShop.frame = CGRectMake( ScratchBack.frame.size.height / 165 * 30, goToShop.frame.origin.y, goToShop.frame.size.width, goToShop.frame.size.height);
                    
                    againScratch.frame = CGRectMake( ScratchBack.frame.size.width - ScratchBack.frame.size.height / 165 * 30 - againScratch.frame.size.width, againScratch.frame.origin.y, againScratch.frame.size.width, againScratch.frame.size.height);
                    againScratch.hidden = NO;
                }else{
                    
                    goToShop.center = center;
                    againScratch.center = center;
                    againScratch.hidden = YES;
                }
                
                if (dataArr_.count > 0) {
                    
                    if (connectTimer) {
                        [connectTimer invalidate];//停止时钟
                        connectTimer=nil;
                    }
                    connectTimer =[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(connectTimeout) userInfo:nil repeats:YES];
                    
                    [tableView_ reloadData];
                }
                
                
            }else
            {
                //[self showToastMsg:data Duration:5.0];
                goToShop.frame = CGRectMake( ScratchBack.frame.size.height / 165 * 30, goToShop.frame.origin.y, goToShop.frame.size.width, goToShop.frame.size.height);
                
                againScratch.frame = CGRectMake( ScratchBack.frame.size.width - ScratchBack.frame.size.height / 165 * 30 - againScratch.frame.size.width, againScratch.frame.origin.y, againScratch.frame.size.width, againScratch.frame.size.height);
                againScratch.hidden = NO;
            }
        });
    }];
}

-(void)getScratchInfo{
    
    [ZG_ScratchPresenters getScratchWithReadyTime:readytime_ frequency:frequency_ updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data[@"map"];
                NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
                
                NSString *rewarddesc = [NSString stringWithFormat:@"%@",dict[@"rewarddesc"]];
                if ([type isEqualToString:@"1"]) {
                    
                    scratchInfo.text = @"已入账到您的积分账户";
                    scratchName.text = rewarddesc;
                }else if ([type isEqualToString:@"2"]){
                    
                    scratchInfo.text = @"已入账到您的积分账户";
                    scratchName.text = rewarddesc;
                }else{
                    
                    scratchInfo.text = @"多多签到就有多多抽奖机会哦";
                    
                    if ([XYString isBlankString:rewarddesc]) {
                        
                        scratchName.text = @"很遗憾~没有中奖";
                    }else{
                        
                        scratchName.text = rewarddesc;
                    }
                }
            }else
            {
//                [self showToastMsg:data Duration:5.0];
            }
        });
    }];
}

#pragma mark - extend method

-(void)getReadytime:(NSString *)readytime
          frequency:(NSString *)frequency{
    
    readytime_ = readytime;
    frequency_ = frequency;
}

-(void)configNavigation{
    
    self.title = @"刮奖区";
}

-(void)configUI{
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake( 10, 5, SCREEN_WIDTH - 2 * 10, SCREEN_HEIGHT - 5 - self.navigationController.navigationBar.frame.size.height - 20)];
    scroll.backgroundColor = UIColorFromRGB(0xf6402b);
    [self.view addSubview:scroll];
    
    [self setDict];
}

-(void)setDict{
    
    float Cardinality = 398.0 / 173;
    
    //--------------头部区域--------------
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, scroll.frame.size.width / Cardinality)];
    backView.image  = [UIImage imageNamed:@"奖品页"];
    [scroll addSubview:backView];
    
    //--------------奖品区域--------------
    
    //奖品1
    UIView *firstGoods = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.origin.y + backView.frame.size.height, backView.frame.size.width / 3, backView.frame.size.width / 3)];
    
    firstGoods.backgroundColor = [UIColor clearColor];
    [scroll addSubview:firstGoods];
    
    good1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, firstGoods.frame.size.width / 3 * 2, firstGoods.frame.size.width / 3 * 2)];
    good1.center = CGPointMake(firstGoods.frame.size.width / 2, good1.center.y);
    
    NSString *url1 = [NSString stringWithFormat:@""];
    [ImageUitls saveAndShowImage:good1 withName:url1];
    good1.backgroundColor = [UIColor whiteColor];
    
    [firstGoods addSubview:good1];
    
    UILabel *good1Lal = [[UILabel alloc]initWithFrame:CGRectMake(good1.frame.origin.x + 5, good1.frame.origin.y + good1.frame.size.height + 10, good1.frame.size.width - 10, 20)];
    good1Lal.backgroundColor = UIColorFromRGB(0xfdee7a);
    good1Lal.text = @"奖品";
    good1Lal.textColor = UIColorFromRGB(0xf6402b);
    good1Lal.font = [UIFont systemFontOfSize:15];
    
    good1Lal.textAlignment = NSTextAlignmentCenter;
    good1Lal.layer.cornerRadius = 10;
    good1Lal.layer.masksToBounds = YES;
    [firstGoods addSubview:good1Lal];
    
    firstGoods.frame = CGRectMake(firstGoods.frame.origin.x, firstGoods.frame.origin.y, firstGoods.frame.size.width, good1Lal.frame.origin.y + good1Lal.frame.size.height + 10);
    
    //奖品2
    UIView *secondGoods = [[UIView alloc]initWithFrame:CGRectMake(firstGoods.frame.size.width, backView.frame.origin.y + backView.frame.size.height, backView.frame.size.width / 3, backView.frame.size.width / 3)];
    secondGoods.backgroundColor = [UIColor clearColor];
    [scroll addSubview:secondGoods];
    
    good2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, secondGoods.frame.size.width / 3 * 2, secondGoods.frame.size.width / 3 * 2)];
    good2.center = CGPointMake(secondGoods.frame.size.width / 2, good2.center.y);
    good2.backgroundColor = [UIColor whiteColor];
    
    NSString *url2 = [NSString stringWithFormat:@""];
    [ImageUitls saveAndShowImage:good2 withName:url2];
    
    [secondGoods addSubview:good2];
    
    UILabel *good2Lal = [[UILabel alloc]initWithFrame:CGRectMake(good2.frame.origin.x + 5, good2.frame.origin.y + good2.frame.size.height + 10, good2.frame.size.width - 10, 20)];
    good2Lal.backgroundColor = UIColorFromRGB(0xfdee7a);
    good2Lal.text = @"奖品";
    good2Lal.textColor = UIColorFromRGB(0xf6402b);
    good2Lal.font = [UIFont systemFontOfSize:15];
    good2Lal.textAlignment = NSTextAlignmentCenter;
    good2Lal.layer.cornerRadius = 10;
    good2Lal.layer.masksToBounds = YES;
    
    [secondGoods addSubview:good2Lal];
    
    secondGoods.frame = CGRectMake(secondGoods.frame.origin.x, secondGoods.frame.origin.y, secondGoods.frame.size.width, good2Lal.frame.origin.y + good2Lal.frame.size.height + 10);
    //奖品3
    UIView *thirdGoods = [[UIView alloc]initWithFrame:CGRectMake(firstGoods.frame.size.width * 2, backView.frame.origin.y + backView.frame.size.height, backView.frame.size.width / 3, backView.frame.size.width / 3)];
    
    thirdGoods.backgroundColor = [UIColor clearColor];
    [scroll addSubview:thirdGoods];
    
    good3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, thirdGoods.frame.size.width / 3 * 2, thirdGoods.frame.size.width / 3 * 2)];
    good3.center = CGPointMake(thirdGoods.frame.size.width / 2, good3.center.y);
    
    NSString *url3 = [NSString stringWithFormat:@""];
    [ImageUitls saveAndShowImage:good3 withName:url3];
    good3.backgroundColor = [UIColor whiteColor];
    
    [thirdGoods addSubview:good3];
    
    UILabel *good3Lal = [[UILabel alloc]initWithFrame:CGRectMake(good3.frame.origin.x + 5, good3.frame.origin.y + good3.frame.size.height + 10, good3.frame.size.width - 10, 20)];
    good3Lal.backgroundColor = UIColorFromRGB(0xfdee7a);
    good3Lal.text = @"奖品";
    good3Lal.textColor = UIColorFromRGB(0xf6402b);
    good3Lal.font = [UIFont systemFontOfSize:15];
    
    good3Lal.textAlignment = NSTextAlignmentCenter;
    good3Lal.layer.cornerRadius = 10;
    good3Lal.layer.masksToBounds = YES;
    [thirdGoods addSubview:good3Lal];
    
    thirdGoods.frame = CGRectMake(thirdGoods.frame.origin.x, thirdGoods.frame.origin.y, thirdGoods.frame.size.width, good3Lal.frame.origin.y + good3Lal.frame.size.height + 10);
    
    //--------------刮奖区域--------------
    //中奖信息
    ScratchBack = [[UIImageView alloc]initWithFrame:CGRectMake(good1.frame.origin.x, firstGoods.frame.origin.y + firstGoods.frame.size.height, scroll.frame.size.width - 2 * good1.frame.origin.x, (scroll.frame.size.width - 2 * good1.frame.origin.x) / 341 * 165)];
    ScratchBack.userInteractionEnabled = YES;
    ScratchBack.image = [UIImage imageNamed:@"刮奖积分"];
    [scroll addSubview:ScratchBack];
    
    scratchName = [[UILabel alloc]initWithFrame:CGRectMake(0, ScratchBack.frame.size.height / 165 * 20, ScratchBack.frame.size.width,(ScratchBack.frame.size.height - ScratchBack.frame.size.height / 165 * 20 * 2) / 2)];
    scratchName.backgroundColor = [UIColor clearColor];
    scratchName.textAlignment = NSTextAlignmentCenter;
    scratchName.textColor = UIColorFromRGB(0xf6402b);
    scratchName.font = [UIFont systemFontOfSize:20];
    scratchName.text = @"很遗憾~没有中奖";
    
    [ScratchBack addSubview:scratchName];
    
    scratchInfo = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 30, 30)];
    scratchInfo.backgroundColor = [UIColor clearColor];
    scratchInfo.textAlignment = NSTextAlignmentCenter;
    scratchInfo.textColor = UIColorFromRGB(0xbe860d);
    scratchInfo.font = [UIFont systemFontOfSize:15];
    scratchInfo.text = @"多多签到就有多多抽奖机会哦";
    [scratchInfo setNumberOfLines:1];
    [scratchInfo sizeToFit];
    scratchInfo.center = CGPointMake(ScratchBack.frame.size.width / 2,  ScratchBack.frame.size.height / 2);
    [ScratchBack addSubview:scratchInfo];
    
    UILabel *gotoShopLal = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 30, 30)];
    if (self.view.frame.size.width == 320.0) {
        
        gotoShopLal.font = [UIFont systemFontOfSize:12];
    }else{
        
        gotoShopLal.font = [UIFont systemFontOfSize:15];
    }
    
    gotoShopLal.text = @"去积分商城逛逛";
    [gotoShopLal setNumberOfLines:1];
    [gotoShopLal sizeToFit];
    
    center = CGPointMake(ScratchBack.frame.size.width / 2, (ScratchBack.frame.size.height - ScratchBack.frame.size.height / 165 * 20 - scratchInfo.frame.origin.y - scratchInfo.frame.size.height) / 2 + scratchInfo.frame.origin.y + scratchInfo.frame.size.height);
    goToShop = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, gotoShopLal.frame.size.width + 20, gotoShopLal.frame.size.height + 10)];
    [goToShop setTitle:@"去积分商城逛逛" forState:UIControlStateNormal];
    [goToShop setTitleColor:UIColorFromRGB(0xfdee7a) forState:UIControlStateNormal];
    [goToShop setBackgroundColor:UIColorFromRGB(0xbe860d)];
    
    if (self.view.frame.size.width == 320.0) {
        
        goToShop.titleLabel.font = [UIFont systemFontOfSize:12];
    }else{
        
        goToShop.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    goToShop.layer.cornerRadius = goToShop.frame.size.height / 2;
    goToShop.layer.masksToBounds = YES;
    goToShop.center = center;
    [goToShop addTarget:self action:@selector(goToShop:) forControlEvents:UIControlEventTouchUpInside];
    [ScratchBack addSubview:goToShop];
    
    againScratch = [[UIButton alloc]initWithFrame:goToShop.frame];
    [againScratch setTitle:@"继续抽奖" forState:UIControlStateNormal];
    againScratch.hidden = YES;
    [againScratch setTitleColor:UIColorFromRGB(0xfdee7a) forState:UIControlStateNormal];
    [againScratch setBackgroundColor:UIColorFromRGB(0xf6402b)];
    if (self.view.frame.size.width == 320.0) {
        
        againScratch.titleLabel.font = [UIFont systemFontOfSize:12];
    }else{
        
        againScratch.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    againScratch.layer.cornerRadius = goToShop.frame.size.height / 2;
    againScratch.layer.masksToBounds = YES;
    againScratch.center = center;
    [againScratch addTarget:self action:@selector(againScratch:) forControlEvents:UIControlEventTouchUpInside];
    [ScratchBack addSubview:againScratch];
    
    topImageView = [[MDScratchImageView alloc]initWithFrame:ScratchBack.frame];
    topImageView.delegate = self;
    [topImageView setImage:[UIImage imageNamed:@"刮奖区"] radius:60.f];
    [scroll addSubview:topImageView];
    
    //--------------规则区域--------------
    
    scratchNumberLal = [[UILabel alloc]initWithFrame:CGRectMake(ScratchBack.frame.origin.x, ScratchBack.frame.origin.y + ScratchBack.frame.size.height + 10, ScratchBack.frame.size.width, 20)];
    
    scratchNumberLal.text = [NSString stringWithFormat:@"今日还可抽奖0次"];
    scratchNumberLal.font = [UIFont systemFontOfSize:15];
    scratchNumberLal.textColor = [UIColor whiteColor];
    scratchNumberLal.backgroundColor = [UIColor clearColor];
    scratchNumberLal.textAlignment = NSTextAlignmentLeft;
    [scroll addSubview:scratchNumberLal];
    
    UILabel *scratchruleLal = [[UILabel alloc]initWithFrame:CGRectMake(ScratchBack.frame.origin.x + ScratchBack.frame.size.width / 2 , ScratchBack.frame.origin.y + ScratchBack.frame.size.height + 10, ScratchBack.frame.size.width / 2, 20)];
    scratchruleLal.text = @"抽奖规则 >";
    scratchruleLal.font = [UIFont systemFontOfSize:15];
    scratchruleLal.textColor = UIColorFromRGB(0xfdee7a);
    scratchruleLal.backgroundColor = [UIColor clearColor];
    scratchruleLal.textAlignment = NSTextAlignmentRight;
    scratchruleLal.userInteractionEnabled = YES;
    [scroll addSubview:scratchruleLal];
    
    UITapGestureRecognizer *ruleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rule:)];
    [scratchruleLal addGestureRecognizer:ruleTap];
    
    UIButton *goToWinningBt = [[UIButton alloc]initWithFrame:CGRectMake(scratchNumberLal.frame.origin.x, scratchruleLal.frame.origin.y + scratchruleLal.frame.size.height + 10, scratchNumberLal.frame.size.width, scratchNumberLal.frame.size.width / 341 * 39)];
    
    [goToWinningBt setBackgroundImage:[UIImage imageNamed:@"查看按钮"] forState:UIControlStateNormal];
    [goToWinningBt setBackgroundImage:[UIImage imageNamed:@"查看按钮"] forState:UIControlStateHighlighted];
    [goToWinningBt setTitle:@"查看中奖纪录" forState:UIControlStateNormal];
    [goToWinningBt setTitleColor:UIColorFromRGB(0xf6402b) forState:UIControlStateNormal];
    [goToWinningBt setTitleColor:UIColorFromRGB(0xf6402b) forState:UIControlStateHighlighted];
    
    [goToWinningBt addTarget:self action:@selector(goToWinning:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:goToWinningBt];
    
    //--------------他人手气区域--------------
    
    UILabel *otherTestLal = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 30, 30)];
    otherTestLal.font = [UIFont systemFontOfSize:15];
    otherTestLal.text = @"看看别人的手气";
    [otherTestLal setNumberOfLines:1];
    [otherTestLal sizeToFit];
    
    UILabel *otherLal = [[UILabel alloc]initWithFrame:CGRectMake(0, goToWinningBt.frame.origin.y + goToWinningBt.frame.size.height + 15, otherTestLal.frame.size.width + 15, otherTestLal.frame.size.height + 5)];
    
    otherLal.textAlignment = NSTextAlignmentCenter;
    otherLal.text = @"看看别人的手气";
    otherLal.font = [UIFont systemFontOfSize:15];
    otherLal.textColor = UIColorFromRGB(0xfdee7a);
    
    otherLal.layer.cornerRadius = otherLal.frame.size.height / 2;
    otherLal.layer.masksToBounds = YES;
    //边框宽度及颜色设置
    [otherLal.layer setBorderWidth:1];
    [otherLal.layer setBorderColor:CGColorRetain(UIColorFromRGB(0xfdee7a).CGColor)];
    [self showToastMsg:@"" Duration:1.0];
    otherLal.center = CGPointMake(scroll.frame.size.width / 2, otherLal.center.y);
    
    [scroll addSubview:otherLal];
    
    UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(scratchNumberLal.frame.origin.x, otherLal.frame.origin.y, otherLal.frame.origin.x - scratchNumberLal.frame.origin.x, (otherLal.frame.origin.x - scratchNumberLal.frame.origin.x) / 118 * 6)];
    
    left.image = [UIImage imageNamed:@"圆点"];
    left.center = CGPointMake(left.center.x, otherLal.center.y);
    left.backgroundColor = [UIColor clearColor];
    [scroll addSubview:left];
    
    UIImageView *right = [[UIImageView alloc]initWithFrame:CGRectMake(otherLal.frame.origin.x + otherLal.frame.size.width, left.frame.origin.y, left.frame.size.width, left.frame.size.height)];
    
    right.image = [UIImage imageNamed:@"圆点"];
    right.backgroundColor = [UIColor clearColor];
    [scroll addSubview:right];
    
    tableView_ = [[UITableView alloc]initWithFrame:CGRectMake(goToWinningBt.frame.origin.x, otherLal.frame.origin.y + otherLal.frame.size.height + 10, ScratchBack.frame.size.width, 220) style:UITableViewStylePlain];
    
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.showsVerticalScrollIndicator = NO;
    //tableView_.scrollEnabled = NO;
    tableView_.userInteractionEnabled = NO;
    [scroll addSubview:tableView_];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"scratchTableViewCell" bundle:nil] forCellReuseIdentifier:@"scratchTableViewCell"];
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, tableView_.frame.origin.y + tableView_.frame.size.height + 20);
}

//touch的响应方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    //convert point to the white layer's coordinates拿到在self.view上但同时在whiteView上的点，下面的同这里一样，不一一解释了
//    point = [topImageView.layer convertPoint:point fromLayer:self.view.layer]; //get layer using containsPoint:
//    if ([topImageView.layer containsPoint:point]) {
//        //convert point to blueLayer’s coordinates
//
//        scroll.scrollEnabled = NO;
//    }
    
//    －－－－－－－－－－华丽丽的分割线，从这里开始是我写的点击的方法，相对来说比上面使用起来更方便点
        CGPoint point=[[touches anyObject]locationInView:self.view];
    
    
        CALayer *layer=[topImageView.layer hitTest:point];
        if (layer==topImageView.layer) {
            
            
        }
}

#pragma mark - connectTime method

-(void)connectTimeout{
    
    scrollTag ++;
    NSIndexPath *path;
    if (dataArr_.count <= scrollTag * 5) {
        scrollTag = 0;
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    }else{
        
        path = [NSIndexPath indexPathForRow:5 * scrollTag inSection:0];
    }
    
    [tableView_ scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - button tap method
                                                                                  
-(void)goToWinning:(id)sender{
    
//    [self showToastMsg:@"跳转中奖纪录" Duration:3.0];
    UIStoryboard * my = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
    L_ZhongJiangRecordViewController *zjVC = [my instantiateViewControllerWithIdentifier:@"L_ZhongJiangRecordViewController"];
    zjVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zjVC animated:YES];
}

-(void)rule:(id)sender{
    
//    [self showToastMsg:@"弹出规则" Duration:3.0];
    [[ScratchRuleViewController shareScratchRuleVC]showInVC:self with:ruleStr];
}

-(void)goToShop:(id)sender{
    
//    [self showToastMsg:@"打开商城" Duration:3.0];
    
    [self comeingoodsWithCallBack:^{
        
    }];
}

-(void)againScratch:(id)sender{
    
    topImageView = [[MDScratchImageView alloc]initWithFrame:ScratchBack.frame];
    topImageView.delegate = self;
    [topImageView setImage:[UIImage imageNamed:@"刮奖区"] radius:60.f];
    isScratch = @"0";
    [scroll addSubview:topImageView];
}

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%s %p progress == %.2f", __PRETTY_FUNCTION__, scratchImageView, maskingProgress);
    
    if(maskingProgress > 0 && [isScratch isEqualToString:@"0"]){
        
        //[self showToastMsg:@"已经兑奖" Duration:2.0];
        isScratch = @"1";
        scroll.scrollEnabled = NO;
        [self getScratchInfo];
    }
    if (maskingProgress > 0.4) {
        [topImageView removeFromSuperview];
        scroll.scrollEnabled = YES;
        [self getSysrecordList];
    }
}

#pragma mark - life cycle method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ChouJang];
    
//    [TalkingData trackPageBegin:@"choujiang"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (connectTimer) {
        [connectTimer invalidate];//停止时钟
        connectTimer=nil;
    }
    
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ChouJang}];
    
//    [TalkingData trackPageEnd:@"choujiang"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isScratch = @"0";
    scrollTag = 0;
    ruleStr = @"";
    
    [self configNavigation];
    [self configUI];
    
    [self getSysrecordList];
    
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = dataArr_[indexPath.row];
    
    scratchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scratchTableViewCell"];
    
    //cell.model = model;
    cell.name.text = [NSString stringWithFormat:@"%@",dict[@"username"]];
    cell.info.text = [NSString stringWithFormat:@"%@",dict[@"rewardcontent"]];
    NSString *beginTime = [NSString stringWithFormat:@"%@",dict[@"systime"]];
    
    NSString *timeStr = [self dateTimeDifferenceWithStartTime:beginTime];
    
    cell.time.text = timeStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - time sub method

/**
 * 开始到结束的时间差
 */
-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [NSDate date];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天前",day];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时前",house];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分钟前",minute];
    }else{
        str = [NSString stringWithFormat:@"%d秒前",second];
    }
    return str;
}

@end
