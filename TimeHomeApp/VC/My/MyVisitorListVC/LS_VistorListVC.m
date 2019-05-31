//
//  LS_VistorListVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_VistorListVC.h"
#import "LS_VistorDetailsVC.h"
#import "UserTrafficPresenter.h"
#import "UserVisitor.h"

#define line_w 64.0f

@interface LS_VistorListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) UIButton *leftBtn;
@property (nonatomic, copy) UIButton *rightBtn;
@property (nonatomic, copy) UIView *lineView;
@property (nonatomic, copy) NSArray *vistorSArr;
@property (nonatomic, copy) NSArray *vistorArr;

@end
@implementation LS_VistorListVC

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = @"0";
    
    [self.view addSubview:self.table];
    
    [self.stable setHidden:YES];
    [self.view addSubview:self.stable];
    
    [self.view addSubview:self.topView];
    self.navigationItem.title = @"访客通行记录";
    self.nothingnessView=[NothingnessView getInstanceView];
    self.nothingnessView.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60);
    [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无访客"]];
    self.nothingnessView.lab_Clues.text = @"暂无记录！";
    [self.view addSubview: self.nothingnessView];
    


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestVistorlist];
    
}

#pragma mark - 请求访客通行记录

-(void)requestVistorlist
{
    
    @WeakObj(self);
    THIndicatorVCStart
    [UserTrafficPresenter getUserTrafficForupDataWithType:_type ViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                [self.nothingnessView setHidden:YES];
                if ([selfWeak.type isEqualToString:@"0"]) {
                    
                    _vistorArr = data;
                    [selfWeak.table reloadData];
                }else if([selfWeak.type isEqualToString:@"1"])
                {
                    _vistorSArr = data;
                    [selfWeak.stable reloadData];
                    
                }
                
            }else
            {
                
                [self.nothingnessView setHidden:NO];

            }
        });
        
    }];
    
}
#pragma mark - selectAction

-(void)leftBtnAction:(UIButton *)sender
{

    _type = @"0";
    [_lineView setFrame:CGRectMake((SCREEN_WIDTH/2.0f-line_w)/2.0f,line_w-6,line_w,2)];
    [_stable setHidden:YES];
    [_table setHidden:NO];
    
    [_rightBtn setTitleColor:UIColorFromRGB(0x2C1C1C) forState:UIControlStateNormal];
    [sender setTitleColor:kNewRedColor forState:UIControlStateNormal];
    [self requestVistorlist];

}
-(void)rightBtnAction:(UIButton *)sender
{
    _type = @"1";
    [_lineView setFrame:CGRectMake(SCREEN_WIDTH-((SCREEN_WIDTH/2.0f-line_w)/2.0f)-line_w,line_w-6,line_w,2)];
    [_stable setHidden:NO];
    [_table setHidden:YES];
    
    [_leftBtn setTitleColor:UIColorFromRGB(0x2C1C1C) forState:UIControlStateNormal];
    [sender setTitleColor:kNewRedColor forState:UIControlStateNormal];
    [self requestVistorlist];

}
#pragma mark - 初始化lineView
-(UIView *)lineView
{
    if (!_lineView) {
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2.0f-line_w)/2.0f,line_w-6,line_w,2)];
        [_lineView setBackgroundColor:kNewRedColor];
        
    }
    return _lineView;
    
}
#pragma mark - 顶部切换View
-(UIView*)topView
{
    if (!_topView) {
        
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        [_topView setBackgroundColor:NABAR_COLOR];
        
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [_leftBtn setTitleColor:kNewRedColor forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorFromRGB(0x2C1C1C) forState:UIControlStateNormal];

        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];

        

        [_leftBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 60)];
        [_rightBtn setFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 60)];
        
        [_topView addSubview:_leftBtn];
        [_topView addSubview:_rightBtn];
        [_topView addSubview:self.lineView];
        
        [_leftBtn setTitle:@"我发出的" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"我收到的" forState:UIControlStateNormal];

       
    }
    return _topView;
    
}
#pragma mark - 我发出的访客通行记录Table懒加载

-(UITableView *)table
{
    if (!_table) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,60,SCREEN_WIDTH, SCREEN_HEIGHT-60-(44+statuBar_Height)) style:UITableViewStylePlain];
        [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _table.tag = 1000;
        _table.delegate = self;
        _table.dataSource = self;
        
        [_table registerNib:[UINib nibWithNibName:@"LS_VistorCell" bundle:nil] forCellReuseIdentifier:@"LS_VistorCell"];
    }
    return _table;
    
}
#pragma mark - 我收到的访客通行记录Table懒加载

-(UITableView *)stable
{
    if (!_stable) {
        
        _stable = [[UITableView alloc]initWithFrame:CGRectMake(0,60,SCREEN_WIDTH, SCREEN_HEIGHT-60-(44+statuBar_Height)) style:UITableViewStylePlain];
        [_stable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        _stable.tag = 1001;
        _stable.delegate = self;
        _stable.dataSource = self;
        
        [_stable registerNib:[UINib nibWithNibName:@"LS_VistorSCell" bundle:nil] forCellReuseIdentifier:@"LS_VistorSCell"];
        
    }
    return _stable;
}


#pragma mark - TableViewDelegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==1000) {
        
        UserVisitor * UV  = [_vistorArr objectAtIndex:indexPath.row];

        LS_VistorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LS_VistorCell"];
        [cell assignmentWithModel:UV];
        
        return cell;
        
        
    }else if (tableView.tag == 1001)
    {
        
        UserVisitor * UV  = [_vistorSArr objectAtIndex:indexPath.row];
        LS_VistorSCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LS_VistorSCell"];
        [cell assignmentWithModel:UV];

        return cell;
    }
    
    return [UITableViewCell new];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==1000) {
        
        return 80;
    }else if(tableView.tag == 1001){
        
        return 90;
    
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1000) {
        
        return _vistorArr.count;
    }else if(tableView.tag == 1001){
        
        return _vistorSArr.count;
        
    }

    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (tableView.tag==1000) {
        
        UserVisitor * UV  = [_vistorArr objectAtIndex:indexPath.row];
        
        LS_VistorDetailsVC * lsVC = [[LS_VistorDetailsVC alloc]init];
        lsVC.vistorID = UV.theID;
        lsVC.ls_type = @"2";
        [self.navigationController pushViewController:lsVC animated:YES];

     
        
    }else if (tableView.tag == 1001)
    {
        
        UserVisitor * UV  = [_vistorSArr objectAtIndex:indexPath.row];
        
        LS_VistorDetailsVC * lsVC = [[LS_VistorDetailsVC alloc]init];
        lsVC.vistorID = UV.theID;
        lsVC.ls_type = @"1";
        [self.navigationController pushViewController:lsVC animated:YES];


    }
   
}

@end
