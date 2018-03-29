//
//  TCServerMonitorViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerProfileViewController.h"
#import "TCServerPerformanceRequest.h"
#import <WYChart/WYLineChartView.h>
#import <WYChart/WYChartCategory.h>
#import <WYChart/WYLineChartPoint.h>
#import <WYChart/WYLineChartCalculator.h>
#import "TCServerPerformance+CoreDataClass.h"
#import "TCServerCPU+CoreDataClass.h"
#import "TCServerMemory+CoreDataClass.h"
#import "TCServerDisk+CoreDataClass.h"
#import "TCServerNet+CoreDataClass.h"
#import "NSString+Extension.h"
#import "TCServerConfigRequest.h"
#import "TCServerConfig+CoreDataClass.h"
#import "TCServerBasicInfo+CoreDataClass.h"
#import "TCServerInfoViewController.h"
#import "TCServerSystemConfig+CoreDataClass.h"
#import "TCServerSystemInfo+CoreDataClass.h"
#import "TCSystemLoadRequest.h"
#import "TCSystemLoad+CoreDataClass.h"
#import "TCAlertController.h"
#import "TCTimePeriodCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "TCServerStatusLabel.h"
#import "TCMonitorHistoryTableViewController.h"
#import "TCServerToolViewController.h"
#import "TCServerConfigInfoViewController.h"
#import "TCServerDiskInfoCell.h"
#import "TCDiskInfo+CoreDataClass.h"
#import "TCServerBusinessInfo+CoreDataClass.h"
#import "TCGagueChartView.h"
#import "TCPieChartView.h"
#import "TCDonutChartView.h"
#import "TCBarChartView.h"
#import "TCServerUsage+CoreDataClass.h"
#import "TCServerStatusManager.h"
#define SERVER_PROFILE_PERIOD_CELL_ID   @"SERVER_PROFILE_PERIOD_CELL_ID"
#define SERVER_PROFILE_DISK_CELL_ID     @"SERVER_PROFILE_DISK_CELL_ID"

//for test
#import "TCNetProfileViewController.h"


@interface TCServerProfileViewController ()<WYLineChartViewDelegate,WYLineChartViewDatasource,
UITableViewDelegate,UITableViewDataSource,TCServerStatusDelegate>
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, strong)   TCServerPerformance *performance;
@property (nonatomic, strong)   TCServerConfig      *config;
@property (nonatomic, strong)   TCSystemLoad        *systemLoad;
@property (nonatomic, weak) IBOutlet    UILabel             *nameLabel;
@property (nonatomic, weak) IBOutlet    UIImageView         *iconView;
@property (nonatomic, weak) IBOutlet    UILabel             *ipLabel;
@property (nonatomic, weak) IBOutlet    TCServerStatusLabel *statusLabel;
//资源概况
@property (nonatomic, weak) IBOutlet    UILabel             *systemTimeLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *runTimeLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *loginUserAmountLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *oneMinLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *fiveMinLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *tenMinLabel;
//配置信息
@property (nonatomic, weak) IBOutlet    UILabel             *systemNameLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *cpuDescLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *memoryDescLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *storageDescLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *networkDescLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *diskTypeLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *diskSizeLabel;
@property (nonatomic, weak) IBOutlet    UITableView         *diskTableView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *diskTableHeightConstraint;
@property (nonatomic, weak) IBOutlet    TCGagueChartView    *cpuUsageView;
@property (nonatomic, weak) IBOutlet    UILabel             *cpuUsageLabel;
@property (nonatomic, weak) IBOutlet    TCPieChartView      *memoryUsageView;
@property (nonatomic, weak) IBOutlet    UILabel             *memoryUsageLabel;
@property (nonatomic, weak) IBOutlet    TCDonutChartView    *diskUtilView;
@property (nonatomic, weak) IBOutlet    UILabel             *diskUtilLabel;
@property (nonatomic, weak) IBOutlet    TCDonutChartView    *diskUsageView;
@property (nonatomic, weak) IBOutlet    UILabel             *diskUsageLabel;
@property (nonatomic, weak) IBOutlet    TCBarChartView      *netInView;
@property (nonatomic, weak) IBOutlet    UILabel             *netInLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *netInMaxLabel;
@property (nonatomic, weak) IBOutlet    TCBarChartView      *netOutView;
@property (nonatomic, weak) IBOutlet    UILabel             *netOutLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *netOutMaxLabel;
//费用信息
//监控信息
@property (nonatomic, strong)   NSMutableArray      *periodMenuOptions;
@property (nonatomic, assign)   NSInteger           periodSelectedIndex;
@property (nonatomic, weak) IBOutlet    UICollectionView    *periodCollectionView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *cpuChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *memoryChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *diskChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *netChartView;
@property (nonatomic, strong) NSMutableArray    *cpuPoints;
@property (nonatomic, strong) NSMutableArray    *memoryPoints;
@property (nonatomic, strong) NSMutableArray    *diskPoints;
@property (nonatomic, strong) NSMutableArray    *netOutputPoints;
@property (nonatomic, strong) NSMutableArray    *netInputPoints;
- (void) reloadConfigData;
- (void) reloadChartData;
- (void) initChartUI;
- (void) initMonitorPeriodUI;
- (void) updateChartUI;
- (void) updateConfigUI;
- (void) updateSystemLoadUI;
- (IBAction) onAverageLoadButton:(id)sender;
- (IBAction) onInfoButton:(id)sender;
- (IBAction) onHelpButton:(id)sender;
- (IBAction) onToolButton:(id)sender;
- (IBAction) onConfigDetailButton:(id)sender;
- (IBAction) onResourceDetailButton:(id)sender;
- (IBAction) onFeeDetailButton:(id)sender;
- (IBAction) onMonitorDetailButton:(id)sender;
@end

@implementation TCServerProfileViewController

- (instancetype) initWithID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主机详情";
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _cpuPoints = [NSMutableArray new];
    _memoryPoints = [NSMutableArray new];
    _diskPoints = [NSMutableArray new];
    _netOutputPoints = [NSMutableArray new];
    _netInputPoints = [NSMutableArray new];
    
    [self initMonitorPeriodUI];
    [self initChartUI];
    [self startLoadingWithBackgroundColor:YES];
    [self reloadChartData];
    
    __weak __typeof(self) weakSelf = self;
    [self reloadConfigData];
//    TCServerConfigRequest *configReq = [[TCServerConfigRequest alloc] initWithServerID:_serverID];
//    [configReq startWithSuccess:^(TCServerConfig *config) {
//        weakSelf.config = config;
//        [weakSelf updateConfigUI];
//    } failure:^(NSString *message) {
//        NSLog(@"server config fail:%@",message);
//    }];
    
    TCSystemLoadRequest *loadReq = [[TCSystemLoadRequest alloc] initWithServerID:_serverID];
    [loadReq startWithSuccess:^(TCSystemLoad *sysLoad) {
        weakSelf.systemLoad = sysLoad;
        [weakSelf updateSystemLoadUI];
    } failure:^(NSString *message) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadConfigData)
                                                 name:NOTIFICATION_MODIFY_SERVER
                                               object:nil];
    
    UINib *diskCellNib = [UINib nibWithNibName:@"TCServerDiskInfoCell" bundle:nil];
    [_diskTableView registerNib:diskCellNib forCellReuseIdentifier:SERVER_PROFILE_DISK_CELL_ID];
    _diskTableView.tableFooterView = [UIView new];
    _diskTableView.delegate = self;
    _diskTableView.dataSource = self;
    
    [[TCServerStatusManager shared] addObserver:self withServerID:_serverID];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_cpuChartView updateGraph];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[TCServerStatusManager shared] removeObserver:self withServerID:_serverID];
}


#pragma mark - WYLineChartViewDelegate

- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _memoryChartView)
    {
        return [_memoryPoints[0] count];
    }else if(chartView == _diskChartView)
    {
        return [_diskPoints[0] count];
    }else if(chartView == _netChartView)
    {
        return [_netOutputPoints[0] count];
    }
    return [_cpuPoints[0] count];
}

- (NSInteger)numberOfLabelOnYAxisInLineChartView:(WYLineChartView *)chartView {
    return 8;
}

- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 0.0f;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _memoryChartView)
    {
        return [_memoryPoints[0] count];
    }else if(chartView == _diskChartView)
    {
        return [_diskPoints[0] count];
    }else if(chartView == _netChartView)
    {
        return [_netOutputPoints[0] count];
    }
    return [_cpuPoints[0] count];
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _memoryChartView)
    {
        return [_memoryPoints[0] count];
    }else if(chartView == _diskChartView)
    {
        return [_diskPoints[0] count];
    }else if(chartView == _netChartView)
    {
        return [_netOutputPoints[0] count];
    }
    return [_cpuPoints[0] count];
}


#pragma mark - WYLineChartViewDatasource

- (NSString *)lineChartView:(WYLineChartView *)chartView contextTextForPointAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    if (_performance)
    {
        if (chartView == _cpuChartView)
        {
            if (index < _performance.cpu.count)
            {
                TCServerCPU *cpuItem = [_performance.cpu objectAtIndex:index];
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:cpuItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:cpuItem.created_time];
            }
        }else if(chartView == _memoryChartView)
        {
            if (index < _performance.memory.count)
            {
                TCServerMemory *memoryItem = [_performance.memory objectAtIndex:index];
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:memoryItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:memoryItem.created_time];
            }
        }else if(chartView == _diskChartView)
        {
            if (index < _performance.disk.count)
            {
                TCServerDisk *diskItem = [_performance.disk objectAtIndex:index];
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:diskItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:diskItem.created_time];
            }
        }else if(chartView == _netChartView)
        {
            if (index < _performance.net.count)
            {
                TCServerNet *netItem = [_performance.net objectAtIndex:index];
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:netItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:netItem.created_time];
            }
        }
    }
    return [NSString stringWithFormat:@"%lu月", index+1];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        return _memoryPoints[0][index];
    }else if(chartView == _diskChartView)
    {
        return _diskPoints[0][index];
    }else if(chartView == _netChartView)
    {
        return _netOutputPoints[0][index];
    }
    return _cpuPoints[0][index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        return _memoryPoints[0][index];
    }else if(chartView == _diskChartView)
    {
        return _diskPoints[0][index];
    }else if(chartView == _netChartView)
    {
        return _netOutputPoints[0][index];
    }
    return _cpuPoints[0][index];
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForYAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        CGFloat maxValue = [self.memoryChartView.calculator maxValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        CGFloat minValue = [self.memoryChartView.calculator minValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.memoryChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _diskChartView)
    {
        CGFloat maxValue = [self.diskChartView.calculator maxValuePointsOfLinesPointSet:self.diskChartView.points].value;
        CGFloat minValue = [self.diskChartView.calculator minValuePointsOfLinesPointSet:self.diskChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.diskChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _netChartView)
    {
        CGFloat maxValue = [self.netChartView.calculator maxValuePointsOfLinesPointSet:self.netChartView.points].value;
        CGFloat minValue = [self.netChartView.calculator minValuePointsOfLinesPointSet:self.netChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.netChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }
    CGFloat maxValue = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    CGFloat minValue = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.cpuChartView];
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    return [NSString stringWithFormat:@"%.02f",value];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToYAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _memoryChartView)
    {
        CGFloat maxValue = [self.memoryChartView.calculator maxValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        CGFloat minValue = [self.memoryChartView.calculator minValuePointsOfLinesPointSet:self.memoryChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.memoryChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _diskChartView)
    {
        CGFloat maxValue = [self.diskChartView.calculator maxValuePointsOfLinesPointSet:self.diskChartView.points].value;
        CGFloat minValue = [self.diskChartView.calculator minValuePointsOfLinesPointSet:self.diskChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.diskChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _netChartView)
    {
        CGFloat maxValue = [self.netChartView.calculator maxValuePointsOfLinesPointSet:self.netChartView.points].value;
        CGFloat minValue = [self.netChartView.calculator minValuePointsOfLinesPointSet:self.netChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.netChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }
    CGFloat maxValue = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    CGFloat minValue = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.cpuChartView];
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    return value;
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToHorizontalReferenceLineAtIndex:(NSInteger)index {
    return 0.0;
}

- (NSDictionary *)lineChartView:(WYLineChartView *)chartView attributesForLineAtIndex:(NSUInteger)index {
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionary];
    resultAttributes[kWYLineChartLineAttributeLineStyle] = @(kWYLineChartMainBezierWaveLine);
    resultAttributes[kWYLineChartLineAttributeDrawGradient] = @(true);
    resultAttributes[kWYLineChartLineAttributeJunctionStyle] = @(kWYLineChartJunctionShapeSolidCircle);
    
    UIColor *lineColor;
    if (chartView == _diskChartView)
    {
        lineColor = [UIColor colorWithRed:151/255.f green:186/255.f blue:147/255.f alpha:1.0];
    }else if(chartView == _memoryChartView)
    {
        lineColor = [UIColor colorWithRed:216/255.f green:91/255.f blue:98/255.f alpha:1.0];
    }else if(chartView == _netChartView)
    {
        if (index == 0)
        {
            lineColor = [UIColor colorWithRed:151/255.f green:186/255.f blue:147/255.f alpha:1.0];
        }else
        {
            lineColor = [UIColor colorWithRed:216/255.f green:91/255.f blue:98/255.f alpha:1.0];
        }
    }else
    {
        lineColor = [UIColor colorWithRed:119/255.f green:215/255.f blue:220/255.f alpha:1.0];
    }
    resultAttributes[kWYLineChartLineAttributeLineColor] = lineColor;
    resultAttributes[kWYLineChartLineAttributeJunctionColor] = lineColor;
    return resultAttributes;
}


#pragma mark - extension
- (void) reloadConfigData
{
    __weak __typeof(self) weakSelf = self;
    TCServerConfigRequest *configReq = [[TCServerConfigRequest alloc] initWithServerID:_serverID];
    [configReq startWithSuccess:^(TCServerConfig *config) {
        weakSelf.config = config;
        NSLog(@"_config:%@",weakSelf.config.system_info.config.disk_info);
        [weakSelf updateConfigUI];
    } failure:^(NSString *message) {
        NSLog(@"server config fail:%@",message);
    }];
}

- (void) reloadChartData
{
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    if (_periodSelectedIndex == 1)
    {
        startTime = endTime - 86400;  //24hour
    }else if(_periodSelectedIndex == 2)
    {
        startTime = endTime - 604800;   //one week
    }else
    {
        startTime = endTime - 3600;
    }
    //startTime = endTime - 18144000;   //one month
    __weak __typeof(self) weakSelf = self;
    TCServerPerformanceRequest *request = [[TCServerPerformanceRequest alloc] initWithServerID:_serverID type:0 startTime:startTime endTime:endTime];
    [request startWithSuccess:^(TCServerPerformance *performance) {
        weakSelf.performance = performance;
        [weakSelf updateChartUI];
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        NSLog(@"fail message:%@",message);
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (void) initChartUI
{
    UIColor *axisColor = [UIColor colorWithRed:102/255.0 green:112/255.0 blue:130/255.0 alpha:1.0];
    
    //设置CPU曲线图
    _cpuChartView.backgroundColor = [UIColor clearColor];
    _cpuChartView.delegate = self;
    _cpuChartView.datasource = self;
    _cpuChartView.clipsToBounds = NO;
    
    _cpuChartView.lineLeftMargin = 0;
    _cpuChartView.lineRightMargin = 0;
    _cpuChartView.lineTopMargin = 0;
    _cpuChartView.lineBottomMargin = 0;
    
    _cpuChartView.animationDuration = 1.0;
    _cpuChartView.animationStyle = kWYLineChartAnimationDrawing;
    _cpuChartView.scrollable = NO;
    _cpuChartView.pinchable = NO;
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:@[@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(1.0)]];
    [mutableArray addObject:tmpPoints];
    _cpuPoints = mutableArray;
    _cpuChartView.points = [NSArray arrayWithArray:_cpuPoints];
    
    _cpuChartView.touchPointColor = [UIColor redColor];
    _cpuChartView.labelsFont = [UIFont systemFontOfSize:12];
    
    _cpuChartView.verticalReferenceLineColor = [UIColor clearColor];
    _cpuChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _cpuChartView.axisColor = axisColor;
    _cpuChartView.labelsColor = axisColor;
    
    //设置内存曲线图
    _memoryChartView.backgroundColor = [UIColor clearColor];
    _memoryChartView.delegate = self;
    _memoryChartView.datasource = self;
    _memoryChartView.lineLeftMargin = 0;
    _memoryChartView.lineRightMargin = 0;
    _memoryChartView.lineTopMargin = 0;
    _memoryChartView.lineBottomMargin = 0;
    _memoryChartView.animationDuration = 1.0;
    _memoryChartView.animationStyle = kWYLineChartAnimationDrawing;
    _memoryChartView.scrollable = NO;
    _memoryChartView.pinchable = NO;
    _memoryPoints = mutableArray;
    _memoryChartView.points = [NSArray arrayWithArray:_memoryPoints];
    _memoryChartView.labelsFont = [UIFont systemFontOfSize:12];
    _memoryChartView.verticalReferenceLineColor = [UIColor clearColor];
    _memoryChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _memoryChartView.axisColor = axisColor;
    _memoryChartView.labelsColor = axisColor;
    
    //设置硬盘使用情况曲线图
    _diskChartView.backgroundColor = [UIColor clearColor];
    _diskChartView.delegate = self;
    _diskChartView.datasource = self;
    _diskChartView.lineLeftMargin = 0;
    _diskChartView.lineRightMargin = 0;
    _diskChartView.lineTopMargin = 0;
    _diskChartView.lineBottomMargin = 0;
    _diskChartView.animationDuration = 1.0;
    _diskChartView.animationStyle = kWYLineChartAnimationDrawing;
    _diskChartView.scrollable = NO;
    _diskChartView.pinchable = NO;
    _diskPoints = mutableArray;
    _diskChartView.points = [NSArray arrayWithArray:_diskPoints];
    _diskChartView.labelsFont = [UIFont systemFontOfSize:12];
    _diskChartView.verticalReferenceLineColor = [UIColor clearColor];
    _diskChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _diskChartView.axisColor = axisColor;
    _diskChartView.labelsColor = axisColor;
    
    //设置网络曲线图
    _netChartView.backgroundColor = [UIColor clearColor];
    _netChartView.delegate = self;
    _netChartView.datasource = self;
    _netChartView.lineLeftMargin = 0;
    _netChartView.lineRightMargin = 0;
    _netChartView.lineTopMargin = 0;
    _netChartView.lineBottomMargin = 0;
    _netChartView.animationDuration = 1.0;
    _netChartView.animationStyle = kWYLineChartAnimationDrawing;
    _netChartView.scrollable = NO;
    _netChartView.pinchable = NO;
    _netOutputPoints = mutableArray;
    _netChartView.points = [NSArray arrayWithArray:_netOutputPoints];
    _netChartView.labelsFont = [UIFont systemFontOfSize:12];
    _netChartView.verticalReferenceLineColor = [UIColor clearColor];
    _netChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _netChartView.axisColor = axisColor;
    _netChartView.labelsColor = axisColor;
}

- (void) initMonitorPeriodUI
{
    _periodMenuOptions = [NSMutableArray new];
    [_periodMenuOptions addObject:@"1小时"];
    [_periodMenuOptions addObject:@"24小时"];
    [_periodMenuOptions addObject:@"1周"];
    [_periodMenuOptions addObject:@"更多"];
    
    UINib *periodCell = [UINib nibWithNibName:@"TCTimePeriodCell" bundle:nil];
    [_periodCollectionView registerNib:periodCell forCellWithReuseIdentifier:SERVER_PROFILE_PERIOD_CELL_ID];
    
    UICollectionViewFlowLayout *areaLayout = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)
    {
        areaLayout = [[UICollectionViewFlowLayout alloc] init];
    }else
    {
        areaLayout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithRight betweenOfCell:15.0];
    }
    //areaLayout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithRight betweenOfCell:15.0];
    areaLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_periodCollectionView setCollectionViewLayout:areaLayout];
    [_periodCollectionView setAllowsMultipleSelection:NO];
    
    _periodSelectedIndex = 0;
    [_periodCollectionView reloadData];
}

- (void) updateChartUI
{
    //重新计算cpu points
    [_cpuPoints removeAllObjects];
    NSMutableArray *rawPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.cpu.count; i++)
    {
        TCServerCPU *cpu = [self.performance.cpu objectAtIndex:i];
        [rawPoints addObject:@(cpu.percent.floatValue)];
    }
    
    if (rawPoints.count == 1)
    {
        NSNumber *cpuNum1 = rawPoints.firstObject;
        NSNumber *cpuNum2 = [NSNumber numberWithFloat:cpuNum1.floatValue];
        [rawPoints addObject:cpuNum2];
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:rawPoints];
    [mutableArray addObject:tmpPoints];
    [_cpuPoints addObjectsFromArray:mutableArray];
    self.cpuChartView.points = [NSArray arrayWithArray:_cpuPoints];
    [self.cpuChartView updateGraph];
    
    //重新计算内存points
    [_memoryPoints removeAllObjects];
    NSMutableArray *rawMemoryPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.memory.count; i++)
    {
        TCServerMemory *memory = [self.performance.memory objectAtIndex:i];
        [rawMemoryPoints addObject:@(memory.percent.floatValue)];
    }
    if (rawMemoryPoints.count == 1)
    {
        NSNumber *memoryNum1 = rawMemoryPoints.firstObject;
        NSNumber *memoryNum2 = [NSNumber numberWithFloat:memoryNum1.floatValue];
        [rawMemoryPoints addObject:memoryNum2];
    }
    
    NSMutableArray *memoryPointArray = [NSMutableArray array];
    NSArray *tmpMemoryPoints = [WYLineChartPoint pointsFromValueArray:rawMemoryPoints];
    [memoryPointArray addObject:tmpMemoryPoints];
    [_memoryPoints addObjectsFromArray:memoryPointArray];
    self.memoryChartView.points = [NSArray arrayWithArray:_memoryPoints];
    [self.memoryChartView updateGraph];
    
    //重新计算硬盘points
    [_diskPoints removeAllObjects];
    NSMutableArray *rawDiskPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.disk.count; i++)
    {
        TCServerDisk *disk = [self.performance.disk objectAtIndex:i];
        [rawDiskPoints addObject:@(disk.percent.floatValue)];
    }
    if (rawDiskPoints.count == 1)
    {
        NSNumber *diskPoint1 = rawDiskPoints.firstObject;
        NSNumber *diskPoint2 = [NSNumber numberWithFloat:diskPoint1.floatValue];
        [rawDiskPoints addObject:diskPoint2];
    }
    NSMutableArray *diskPointArray = [NSMutableArray array];
    NSArray *tmpDiskPoints = [WYLineChartPoint pointsFromValueArray:rawDiskPoints];
    [diskPointArray addObject:tmpDiskPoints];
    [_diskPoints addObjectsFromArray:diskPointArray];
    self.diskChartView.points = [NSArray arrayWithArray:_diskPoints];
    [self.diskChartView updateGraph];
    
    //重新计算网络points
    [_netOutputPoints removeAllObjects];
    NSMutableArray *rawNetOutputPoints = [NSMutableArray new];
    NSMutableArray *rawNetInputPoints = [NSMutableArray new];
    for (int i = 0; i < self.performance.net.count; i++)
    {
        TCServerNet *net = [self.performance.net objectAtIndex:i];
        [rawNetOutputPoints addObject:@(net.output)];
        [rawNetInputPoints addObject:@(net.input)];
    }
    if (rawNetInputPoints.count == 1)
    {
        NSNumber *inputNum1 = rawNetInputPoints.firstObject;
        NSNumber *inputNum2 = [NSNumber numberWithInteger:inputNum1.integerValue];
        [rawNetInputPoints addObject:inputNum2];
        NSNumber *outputNum1 = rawNetOutputPoints.firstObject;
        NSNumber *outputNum2 = [NSNumber numberWithInteger:outputNum1.integerValue];
        [rawNetOutputPoints addObject:outputNum2];
    }
    NSMutableArray *outputPointArray = [NSMutableArray array];
    NSArray *tmpNetOutputPoints = [WYLineChartPoint pointsFromValueArray:rawNetOutputPoints];
    [outputPointArray addObject:tmpNetOutputPoints];
    NSArray *tmpNetInputPoints = [WYLineChartPoint pointsFromValueArray:rawNetInputPoints];
    [outputPointArray addObject:tmpNetInputPoints];
    [_netOutputPoints addObjectsFromArray:outputPointArray];
    
    self.netChartView.points = [NSArray arrayWithArray:_netOutputPoints];
    [self.netChartView updateGraph];
}

- (void) updateConfigUI
{
    _nameLabel.text = _config.basic_info.name;
    _ipLabel.text = _config.basic_info.public_ip;
    UIImage *iconImage = nil;
    NSString *providerName = _config.business_info.provider;
    if (providerName == nil)
    {
        providerName = @"";
    }
    if ([providerName isEqualToString:SERVER_PROVIDER_ALIYUN])
    {
        iconImage = [UIImage imageNamed:@"server_type_aliyun"];
    }else if([providerName isEqualToString:SERVER_PROVIDER_AMAZON])
    {
        iconImage = [UIImage imageNamed:@"server_type_amazon"];
    }else if([providerName isEqualToString:SERVER_PROVIDER_MICROS])
    {
        iconImage = [UIImage imageNamed:@"server_type_microyun"];
    }else
    {
        iconImage = [UIImage imageNamed:@"server_type_tencentyun"];
    }
    [_iconView setImage:iconImage];
    [_statusLabel setStatus:_config.basic_info.machine_status];
    
    TCServerSystemConfig *sysConfig = _config.system_info.config;
    _systemNameLabel.text = sysConfig.os_name;
    CGFloat gigaByte = sysConfig.memory / 1024.0;
    NSString *memoryDescStr = [NSString stringWithFormat:@"%gG",gigaByte];
    _memoryDescLabel.text = memoryDescStr;
    NSString *cpuDescStr = [NSString stringWithFormat:@"%d",(int)(sysConfig.cpu)];
    _cpuDescLabel.text = cpuDescStr;
    
    //_diskTypeLabel.text = sysConfig.system_disk_type;
    //_diskSizeLabel.text = sysConfig.system_disk_size;
    
    /*
    TCDiskInfo *tmpInfo = [TCDiskInfo MR_createEntity];
    tmpInfo.system_disk_type = @"just ytpe";
    tmpInfo.system_disk_size = @"129G";
    tmpInfo.system_disk_id = @"id223";
    [sysConfig.disk_info addObject:tmpInfo];
     */

    [_diskTableView reloadData];
    NSInteger diskRow = sysConfig.disk_info.count;
    CGFloat diskTableHeight = 43 * diskRow;//TCSCALE(48) * diskRow;
    _diskTableHeightConstraint.constant = diskTableHeight;
    NSLog(@"_diskTableView:%@",_diskTableView);
}

- (void) updateSystemLoadUI
{
    _systemTimeLabel.text = _systemLoad.date;
    _runTimeLabel.text = _systemLoad.run_time;
    NSString *amountStr = [NSString stringWithFormat:@"%d",(int)_systemLoad.login_users];
    _loginUserAmountLabel.text = amountStr;
    CGFloat oneMinLoad = _systemLoad.one_minute_load;
    NSString *oneMinStr = [NSString stringWithFormat:@"%g",oneMinLoad];
    _oneMinLabel.text = oneMinStr;
    if (oneMinLoad > 0.7)
    {
        [_oneMinLabel setTextColor:STATE_ALERT_COLOR];
    }else
    {
        [_oneMinLabel setTextColor:THEME_TINT_COLOR];
    }
    CGFloat fiveMinLoad = _systemLoad.five_minute_load;
    NSString *fiveMinStr = [NSString stringWithFormat:@"%g",fiveMinLoad];
    _fiveMinLabel.text = fiveMinStr;
    if (fiveMinLoad > 0.7)
    {
        [_fiveMinLabel setTextColor:STATE_ALERT_COLOR];
    }else
    {
        [_fiveMinLabel setTextColor:THEME_TINT_COLOR];
    }
    CGFloat fifteenMinLoad = _systemLoad.fifth_minute_load;
    NSString *tenMinStr = [NSString stringWithFormat:@"%g",fifteenMinLoad];
    _tenMinLabel.text = tenMinStr;
    if (fifteenMinLoad > 0.7)
    {
        [_tenMinLabel setTextColor:STATE_ALERT_COLOR];
    }else
    {
        [_tenMinLabel setTextColor:THEME_TINT_COLOR];
    }
    
    TCServerUsage *usage = _systemLoad.monitor;
    
    _cpuUsageView.percent = usage.cpuUsageRate.floatValue/100.0; //0.25;
    _cpuUsageView.foregroundColor = THEME_TINT_COLOR;
    NSString *cpuUsageStr = [NSString stringWithFormat:@"%g%%",usage.cpuUsageRate.floatValue];
    _cpuUsageLabel.text = cpuUsageStr;
    _memoryUsageView.percent = usage.memUsageRate.floatValue/100.0;
    _memoryUsageView.foregroundColor = THEME_TINT_COLOR;
    NSString *memUsageStr = [NSString stringWithFormat:@"%g%%",usage.memUsageRate.floatValue];
    _memoryUsageLabel.text = memUsageStr;
    _diskUtilView.percent = usage.diskUtilize.floatValue/100.0;
    _diskUtilView.foregroundColor = THEME_TINT_COLOR;
    NSString *diskUtilStr = [NSString stringWithFormat:@"%g%%",usage.diskUtilize.floatValue];
    _diskUtilLabel.text = diskUtilStr;
    _diskUsageView.percent = usage.diskUsageRate.floatValue/100.0;
    _diskUsageView.foregroundColor = THEME_TINT_COLOR;
    NSString *diskUsageStr = [NSString stringWithFormat:@"%g%%",usage.diskUsageRate.floatValue];
    _diskUsageLabel.text = diskUsageStr;
    CGFloat netInRatio = 0;
    CGFloat netOutRatio = 0;
    if (usage.netUsageRate.length > 0)
    {
        NSArray *netStrArray = [usage.netUsageRate componentsSeparatedByString:@"/"];
        if (netStrArray.count >= 2)
        {
            NSString *inStr = [netStrArray objectAtIndex:0];
            NSString *outStr = [netStrArray objectAtIndex:1];
            netInRatio = inStr.floatValue;
            netOutRatio = outStr.floatValue;
        }
    }
    _netInView.percent = netInRatio / 100.0;
    _netInView.foregroundColor = THEME_TINT_COLOR;
    //_netInLabel.text = [NSString stringWithFormat:@"%g%%",netInRatio];
    _netInLabel.text = usage.netDownload;
    _netInMaxLabel.text = usage.netInputMax;
    _netOutView.percent = netOutRatio / 100.0;
    _netOutView.foregroundColor = THEME_TINT_COLOR;
    //_netOutLabel.text = [NSString stringWithFormat:@"%g%%",netOutRatio];
    _netOutLabel.text = usage.netUpload;
    _netOutMaxLabel.text = usage.netOutputMax;
}

- (IBAction) onAverageLoadButton:(id)sender
{
    NSString *desc = @"load average数据是每隔5秒钟检查一次活跃的进程数，然后按特定算法计算出的数值。如果这个数除以逻辑CPU的数量，结果高于5的时候就表明系统在超负荷运转了。\n\r\n平均负载的值越小代表系统压力越小，越大则代表系统压力越大。通常，我们会以最后一个数值，也就是15分钟内的平均负载作为参考来评估系统的负载情况。\n\r\n对于只有单核cpu的系统，1.0是该系统所能承受负荷的边界值，大于1.0则有处理需要等待。\n\r\n一个单核cpu的系统，平均负载的合适值是0.7以下。如果负载长期徘徊在1.0，则需要考虑马上处理了。超过1.0的负载，可能会带来非常严重的后果。";
    [TCAlertController presentWithTitle:@"平均负载"
                                   desc:desc];
}

- (IBAction) onInfoButton:(id)sender
{
    TCServerInfoViewController *infoVC = [[TCServerInfoViewController alloc] initWithServerID:_serverID];
    infoVC.title = @"基本信息";
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction) onHelpButton:(id)sender
{
    NSLog(@"on help button");
}

- (IBAction) onToolButton:(id)sender
{
    TCServerToolViewController *toolVC = [[TCServerToolViewController alloc] initWithServerID:_serverID status:_statusLabel.text];
    [self presentViewController:toolVC animated:NO completion:nil];
}

- (IBAction) onConfigDetailButton:(id)sender
{
    TCServerConfigInfoViewController *infoVC = nil;
    infoVC = [[TCServerConfigInfoViewController alloc] initWithConfig:_config];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction) onResourceDetailButton:(id)sender
{
    NSLog(@"on res detail button");
    //TCNetProfileViewController *netVC = [TCNetProfileViewController new];
    //[self.navigationController pushViewController:netVC animated:YES];
}

- (IBAction) onFeeDetailButton:(id)sender
{
    NSLog(@"on fee detail button");
}

- (IBAction) onMonitorDetailButton:(id)sender
{
    NSLog(@"on monitor detail button");
    //TCMonitorHistoryTableViewController *historyVC = nil;
    //historyVC = [[TCMonitorHistoryTableViewController alloc] initWithServerID:_serverID];
    //[self.navigationController pushViewController:historyVC animated:YES];
}


#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _periodMenuOptions.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCTimePeriodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERVER_PROFILE_PERIOD_CELL_ID forIndexPath:indexPath];
    NSString *periodName = [_periodMenuOptions objectAtIndex:indexPath.row];
    [cell setName:periodName];
    [cell setSelected:indexPath.row == _periodSelectedIndex];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_periodMenuOptions objectAtIndex:indexPath.row];
    if (text == nil || text.length == 0)
    {
        text = @"默认";
    }
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TCFont(10.0)} context:nil].size;
    return CGSizeMake(textSize.width + 8, textSize.height + 4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3)
    {
        [_periodCollectionView reloadData];
        TCMonitorHistoryTableViewController *historyVC = nil;
        historyVC = [[TCMonitorHistoryTableViewController alloc] initWithServerID:_serverID];
        [self.navigationController pushViewController:historyVC animated:YES];
        return;
    }
    _periodSelectedIndex = indexPath.row;
    [_periodCollectionView reloadData];
    [self reloadChartData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _diskTableView)
    {
        NSLog(@"hhhh:%ld",_config.system_info.config.disk_info.count);
        if (_config) {
            return _config.system_info.config.disk_info.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerDiskInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_PROFILE_DISK_CELL_ID forIndexPath:indexPath];
    NSArray *infoArray = _config.system_info.config.disk_info;
    if (infoArray && (indexPath.row < infoArray.count))
    {
        BOOL showNumber = infoArray.count > 1;
        TCDiskInfo *info = [infoArray objectAtIndex:indexPath.row];
        if (showNumber)
        {
            [cell setDiskInfo:info withNumber:indexPath.row+1];
        }else
        {
            [cell setDiskInfo:info withNumber:0];
        }
    }
    return cell;
    /*
    TCServerContainerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CONTAINER_CELL_REUSE_ID forIndexPath:indexPath];
    NSArray *strArray = [_containerArray objectAtIndex:indexPath.row];
    [cell setContainer:strArray];
    return cell;
     */
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - TCServerStatusDelegate
- (void) serverWithID:(NSInteger)serverID statusChanged:(NSString*)newStatus
            completed:(BOOL)completed
{
    NSLog(@"-- server %ld profile statusChanged:%@",serverID, newStatus);
    if (newStatus && newStatus.length > 0)
    {
        [_statusLabel setStatus:newStatus];
    }
}
@end
