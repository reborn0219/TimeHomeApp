//
//  HouseFunctionVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HouseFunctionVC.h"
#import "HouseTableVC.h"
#import "RentalAndSalesTableVC.h"
#import "ReleaseHouseVC.h"
#import "SolicitingHouseVC.h"
#import "ReleaseRentalParking.h"

@interface HouseFunctionVC ()<UITableViewDelegate,UITableViewDataSource>
{
    //功能数据
    NSMutableArray * arrFunction;
}
/**
 *  功能列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HouseFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);;
      [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];

    
    self.tableView.dataSource=self;
    [self setExtraCellLineHidden:self.tableView];
    
    if(self.jumpCode==0)
    {
        [self setHouseTableData];
    }
    else if (self.jumpCode==1)
    {
        [self setParkingTableData];
    }
    else if (self.jumpCode==2||self.jumpCode==3)
    {
        self.navigationItem.rightBarButtonItem=nil;
        [self setHouseTableData];
    }
}
/**
 *  设置房屋出租数据
 */
-(void)setHouseTableData
{
    arrFunction=[NSMutableArray new];
    [arrFunction addObject:@{@"出租":@"房屋租售_出租"}];
    [arrFunction addObject:@{@"出售":@"车位租售_出售"}];
    [arrFunction addObject:@{@"求租":@"房屋租售_求租"}];
    [arrFunction addObject:@{@"求购":@"车位租售_求购"}];
    
}
/**
 *  车位出租数据
 */
-(void)setParkingTableData
{
    arrFunction=[NSMutableArray new];
    [arrFunction addObject:@{@"出租":@"车位租售_出租"}];
    [arrFunction addObject:@{@"出售":@"车位租售_出售"}];
    [arrFunction addObject:@{@"求租":@"车位租售_求租"}];
    [arrFunction addObject:@{@"求购":@"车位租售_求购"}];
    
}


#pragma mark ----------关于列表数据及协议处理--------------
/**
 *  设置隐藏列表分割线
 *
 *  @param tableView tableView description
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrFunction count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    NSDictionary * dic=[arrFunction objectAtIndex:indexPath.row];
    cell.textLabel.font=DEFAULT_SYSTEM_FONT(16);
    cell.textLabel.text=[[dic allKeys] lastObject];
    cell.imageView.image=[UIImage imageNamed:[[dic allValues] lastObject]];
    return cell;
}
/**
 *  设置列表高度
 *
 *  @param tableView tableView description
 *  @param indexPath indexPath description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.jumpCode==0) {//房
        switch (indexPath.row) {
            case 0://出租
            {
                HouseTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"HouseTableVC"];
                htVc.jmpCode=0;
                [self.navigationController pushViewController:htVc animated:YES];
            }
                break;
            case 1://出售
            {
                HouseTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"HouseTableVC"];
                htVc.jmpCode=1;
                htVc.title=@"出售";
                [self.navigationController pushViewController:htVc animated:YES];
            }
                break;
            case 2://求租
            {
                RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                htVc.jmpCode=0;
                htVc.title=@"求租";
                [self.navigationController pushViewController:htVc animated:YES];

            }
                break;
            case 3://求购
            {
                RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                htVc.jmpCode=1;
                htVc.title=@"求购";
                [self.navigationController pushViewController:htVc animated:YES];

            }
                break;
                
            default:
                break;
        }
    }
    else if (self.jumpCode==1)//车
    {
        switch (indexPath.row) {
            case 0://出租
            {
                RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                htVc.jmpCode=4;
                htVc.title=@"出租";
                [self.navigationController pushViewController:htVc animated:YES];

            }
                break;
            case 1://出售
            {
                RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                htVc.jmpCode=5;
                htVc.title=@"出售";
                [self.navigationController pushViewController:htVc animated:YES];

            }
                break;
            case 2://求租
            {
                RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                htVc.jmpCode=2;
                htVc.title=@"求租";
                [self.navigationController pushViewController:htVc animated:YES];

            }
                break;
            case 3://求购
            {
                RentalAndSalesTableVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesTableVC"];
                htVc.jmpCode=3;
                htVc.title=@"求购";
                [self.navigationController pushViewController:htVc animated:YES];

            }
                break;
                
            default:
                break;
        }

    }
    else if (self.jumpCode==2)//房屋发布信息
    {
        switch (indexPath.row) {
            case 0://出租
            {
                ReleaseHouseVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseHouseVC"];
                htVc.jmpCode=0;
                htVc.title=@"发布出租信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
            case 1://出售
            {
                ReleaseHouseVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseHouseVC"];
                htVc.jmpCode=1;
                htVc.title=@"发布出售信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
            case 2://求租
            {
                SolicitingHouseVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"SolicitingHouseVC"];
                htVc.jmpCode=0;
                htVc.title=@"发布求租信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
            case 3://求购
            {
                SolicitingHouseVC * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"SolicitingHouseVC"];
                htVc.jmpCode=1;
                htVc.title=@"发布求购信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
    }
    else if (self.jumpCode==3)//车位发布信息
    {
        switch (indexPath.row) {
            case 0://出租
            {
                ReleaseRentalParking * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseRentalParking"];
                htVc.jmpCode=0;
                htVc.title=@"发布出租信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
            case 1://出售
            {
                ReleaseRentalParking * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseRentalParking"];
                htVc.jmpCode=1;
                htVc.title=@"发布出售信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
            case 2://求租
            {
                ReleaseRentalParking * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseRentalParking"];
                htVc.jmpCode=2;
                htVc.title=@"发布求租信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
            case 3://求购
            {
                ReleaseRentalParking * htVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseRentalParking"];
                htVc.jmpCode=3;
                htVc.title=@"发布求购信息";
                [self.navigationController pushViewController:htVc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
    }

    
}
/**
 * 导航条右按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)Nav_RightEvent:(UIBarButtonItem *)sender {
    
    HouseFunctionVC *hfVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HouseFunctionVC"];
    hfVC.jumpCode=_jumpCode==0?2:3;
    hfVC.title=@"选择发布类别";
    [self.navigationController pushViewController:hfVC animated:YES];
    
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
