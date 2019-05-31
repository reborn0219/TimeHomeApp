//
//  RedPacketsVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司.

#import "RedPacketsVC.h"
#import "BBSMainPresenters.h"

@interface RedPacketsVC ()<UITableViewDataSource,UITableViewDelegate>

/**
 红包领取列表table
 */
@property (nonatomic, strong) UITableView *table;

/**
 表头红包信息view
 */
@property (nonatomic, strong) UIView *tableHeaderView;

/**
 发红包人的头像imgV
 */
@property (nonatomic, strong) UIImageView *headImgV;

/**
 发红包人名字label
 */
@property (nonatomic, strong) UILabel *redmanLb;

/**
 发红包祝福内容label
 */
@property (nonatomic, strong) UILabel *redcontentLb;

/**
 红包领取列表数据arr
 */
@property (nonatomic, strong) NSArray *redlist;

/**
 红包单个dic
 */
@property (nonatomic, strong) NSDictionary *redInfo;

/**
 红包总量和领取详情展示str
 */
@property (nonatomic, copy) NSString * sectionText;

/**
 红包金额显示label
 */
@property (nonatomic, strong) UILabel *moneyLb;

@end
@implementation RedPacketsVC
#pragma mark - lifeCircle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:@"RedPacketsCell" bundle:nil] forCellReuseIdentifier:@"RedPacketsCell"];
    self.navigationItem.title = @"红包领取详情";
    self.table.tableHeaderView = self.tableHeaderView;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @WeakObj(self);
    [BBSMainPresenters getRedReceiveInfo:_redid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           
           if(resultCode == SucceedCode)
           {
               [self.table setHidden:NO];
               
               _redInfo = [NullPointerUtils toDealWithNullPointer:data];
               _redlist = [NullPointerUtils toDealWithNullArr:[_redInfo objectForKey:@"list"]];
               
               [_headImgV sd_setImageWithURL:[NSURL URLWithString:[_redInfo objectForKey:@"userpicurl"]] placeholderImage:kHeaderPlaceHolder];
               
               
               NSString * allmoney = [_redInfo objectForKey:@"allmoney"];
               NSString * lastmoney = [_redInfo objectForKey:@"lastmoney"];
               NSString * allcount = [_redInfo objectForKey:@"allcount"];
               NSString * lastcount = [_redInfo objectForKey:@"lastcount"];
               _redmanLb.text = [_redInfo objectForKey:@"nickname"];
               _redcontentLb.text = [_redInfo objectForKey:@"subtitle"];
               _sectionText= [NSString stringWithFormat:@"已领取%d/%@个红包    共%.2f/%@元",(allcount.intValue-lastcount.intValue),allcount,(allmoney.floatValue-lastmoney.floatValue),allmoney];
               
               NSString * isme = @"0";
               NSString * money= @"0";
               for (int i =0; i<_redlist.count; i++) {
                   NSDictionary * dic = [_redlist objectAtIndex:i];
                   
                   NSString * ismestr = [dic objectForKey:@"isme"];
                   if (ismestr.boolValue) {
                       isme = ismestr;
                       money = [dic objectForKey:@"money"];
                   }
               }
               NSString * moneyText = [NSString stringWithFormat:@"%.2fyuan",money.floatValue];
               if (isme.boolValue) {
                
                   [_moneyLb setHidden:NO];
                   [_moneyLb setAttributedText:[self changeToSuperscriptForNumberSignWith:moneyText changeString:@"yuan"]];
                   [_redcontentLb setFrame:CGRectMake(0,140,SCREEN_WIDTH-20,21)];
               }else
               {
                   [_moneyLb setHidden:YES];
               }

               [self.table reloadData];


           }else
           {
               [selfWeak showToastMsg:data Duration:2.0f];
               [self.table setHidden:YES];
           }
           NSLog(@"%@",data);
           
       });
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}
#pragma mark - 给UILabel增加上下标
-(NSMutableAttributedString *)changeToSuperscriptForNumberSignWith:(NSString *)string changeString:(NSString *)changeString{
    
    NSRange range = [string rangeOfString:changeString];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSDictionary * attris = @{NSBaselineOffsetAttributeName:@(11),
                              
                              NSFontAttributeName:[UIFont systemFontOfSize:10]};
    
    [attributedString setAttributes:attris range:range];
    
    return attributedString;
    
}

#pragma mark - 初始化tableview
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
    }
    return _table;
}
#pragma mark - 初始化tableviewHeaderView
-(UIView *)tableHeaderView
{
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/681*402)];
        UIImageView * imgV = [[UIImageView alloc]initWithFrame:_tableHeaderView.bounds];
        [_tableHeaderView addSubview:imgV];
        [imgV setImage:[UIImage imageNamed:@"领红包详情背景-红"]];
        UIView * headerV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20-60)/2, 20, 60, 60)];
        _headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(2,2,56,56)];
        _headImgV.layer.masksToBounds = YES;
        _headImgV.layer.cornerRadius = 28.0f;
        [headerV addSubview:_headImgV];
        [_headImgV setImage:[UIImage imageNamed:@"新个人头像"]];
        headerV.backgroundColor = [UIColor whiteColor];
        headerV.layer.cornerRadius = 30;
        _redmanLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 90,SCREEN_WIDTH-20,21)];
        _redmanLb.textColor = [UIColor whiteColor];
        _redmanLb.text = @"昵称";
        _redmanLb.font = [UIFont systemFontOfSize:12.0f];
        _redmanLb.textAlignment = NSTextAlignmentCenter;
        [_tableHeaderView addSubview:_redmanLb];
        
        _moneyLb = [[UILabel alloc]initWithFrame:CGRectMake(0,113,SCREEN_WIDTH-20,21)];
        _moneyLb.textColor = [UIColor yellowColor];
        _moneyLb.text = @"0.01";
        _moneyLb.font = [UIFont boldSystemFontOfSize:26];
        _moneyLb.textAlignment = NSTextAlignmentCenter;
        [_moneyLb setHidden:YES];
        [_tableHeaderView addSubview:_moneyLb];
        
        _redcontentLb = [[UILabel alloc]initWithFrame:CGRectMake(0,130,SCREEN_WIDTH-20,21)];
        _redcontentLb.textColor = [UIColor whiteColor];
        _redcontentLb.text = @"恭喜发财 大吉大利";
        _redcontentLb.font = [UIFont fontWithName:@"AmericanTypewriter-Bold"size:16];
        _redcontentLb.textAlignment = NSTextAlignmentCenter;
        [_tableHeaderView addSubview:_redcontentLb];
        [_tableHeaderView addSubview:headerV];
    }
    return _tableHeaderView;
}
#pragma mark - tableview 代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RedPacketsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RedPacketsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * rowDic = [_redlist objectAtIndex:indexPath.row];
    NSString * ishot = [rowDic objectForKey:@"ishot"];
    
    if (indexPath.row==0) {
        [cell.topView setHidden:NO];

    }else
    {
        [cell.topView setHidden:YES];
    }
    NSLog(@"-----是否最佳%@",ishot);
    
    [cell isTheBest:ishot.boolValue];

    cell.nickeLb.text = [rowDic objectForKey:@"nickname"];
    

    [cell.headerImageV sd_setImageWithURL:[NSURL URLWithString:[rowDic objectForKey:@"userpicurl"]] placeholderImage:kHeaderPlaceHolder];
    NSString * moneyS = [rowDic objectForKey:@"money"];
    
    
    CGFloat moneyF = moneyS.floatValue;
    cell.moneyLb.text = [NSString stringWithFormat:@"%.2f  元",moneyF];
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _redlist.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc]init];
    [v setBackgroundColor:BLACKGROUND_COLOR];
    UILabel * lb = [[UILabel  alloc]initWithFrame:CGRectMake(0, 5,190, 21)];
    lb.font = [UIFont systemFontOfSize:12.0f];
    [lb setTextColor:TEXT_COLOR];
    lb.text = _sectionText;
    [v addSubview:lb];
    return v;
}

@end
