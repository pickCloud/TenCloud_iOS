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
#import "MKDropdownMenu.h"
#import "ShapeSelectView.h"


@interface TCServerProfileViewController ()<WYLineChartViewDelegate,WYLineChartViewDatasource>
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, strong)   TCServerPerformance *performance;
@property (nonatomic, strong)   TCServerConfig      *config;
@property (nonatomic, strong)   TCSystemLoad        *systemLoad;
@property (nonatomic, weak) IBOutlet    UILabel             *nameLabel;
@property (nonatomic, weak) IBOutlet    UIImageView         *iconView;
@property (nonatomic, weak) IBOutlet    UILabel             *ipLabel;
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
//费用信息
//监控信息
@property (nonatomic, strong)   NSMutableArray      *periodMenuOptions;
@property (nonatomic, assign)   NSInteger           periodSelectedIndex;
@property (nonatomic, weak) IBOutlet    MKDropdownMenu      *periodMenu;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *cpuChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *memoryChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *diskChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *netChartView;
@property (nonatomic, strong) NSMutableArray    *cpuPoints;
@property (nonatomic, strong) NSMutableArray    *memoryPoints;
@property (nonatomic, strong) NSMutableArray    *diskPoints;
@property (nonatomic, strong) NSMutableArray    *netOutputPoints;
@property (nonatomic, strong) NSMutableArray    *netInputPoints;
- (void) reloadChartData;
- (void) initChartUI;
- (void) initPeriodMenuUI;
- (void) updateChartUI;
- (void) updateConfigUI;
- (void) updateSystemLoadUI;
- (IBAction) onAverageLoadButton:(id)sender;
- (IBAction) onInfoButton:(id)sender;
- (IBAction) onHelpButton:(id)sender;
- (IBAction) onConfigButton:(id)sender;
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
    
    [self initPeriodMenuUI];
    [self initChartUI];
    [self startLoadingWithBackgroundColor:YES];
    [self reloadChartData];
    
    __weak __typeof(self) weakSelf = self;
    TCServerConfigRequest *configReq = [[TCServerConfigRequest alloc] initWithServerID:_serverID];
    [configReq startWithSuccess:^(TCServerConfig *config) {
        weakSelf.config = config;
        [weakSelf updateConfigUI];
    } failure:^(NSString *message) {
        NSLog(@"server config fail:%@",message);
    }];
    
    TCSystemLoadRequest *loadReq = [[TCSystemLoadRequest alloc] initWithServerID:_serverID];
    [loadReq startWithSuccess:^(TCSystemLoad *sysLoad) {
        weakSelf.systemLoad = sysLoad;
        [weakSelf updateSystemLoadUI];
    } failure:^(NSString *message) {
        
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_cpuChartView updateGraph];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_periodMenu closeAllComponentsAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                return [NSString timeStringFromInteger:cpuItem.created_time];
            }
        }else if(chartView == _memoryChartView)
        {
            if (index < _performance.memory.count)
            {
                TCServerMemory *memoryItem = [_performance.memory objectAtIndex:index];
                return [NSString timeStringFromInteger:memoryItem.created_time];
            }
        }else if(chartView == _diskChartView)
        {
            if (index < _performance.disk.count)
            {
                TCServerDisk *diskItem = [_performance.disk objectAtIndex:index];
                return [NSString timeStringFromInteger:diskItem.created_time];
            }
        }else if(chartView == _netChartView)
        {
            if (index < _performance.net.count)
            {
                TCServerNet *netItem = [_performance.net objectAtIndex:index];
                return [NSString timeStringFromInteger:netItem.created_time];
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
- (void) reloadChartData
{
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    //startTime = endTime - 86400;  //24hour
    //startTime = endTime - 604800;   //one week
    startTime = endTime - 18144000;   //one month
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

- (void) initPeriodMenuUI
{
    _periodMenuOptions = [NSMutableArray new];
    [_periodMenuOptions addObject:@"1个小时"];
    [_periodMenuOptions addObject:@"24个小时"];
    [_periodMenuOptions addObject:@"1周"];
    [_periodMenuOptions addObject:@"1个月"];
    
    UIColor *dropDownBgColor = [UIColor colorWithRed:39/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    self.periodMenu.selectedComponentBackgroundColor = dropDownBgColor;
    self.periodMenu.dropdownBackgroundColor = dropDownBgColor;
    self.periodMenu.dropdownShowsTopRowSeparator = YES;
    self.periodMenu.dropdownShowsBottomRowSeparator = NO;
    self.periodMenu.dropdownShowsBorder = NO;
    self.periodMenu.backgroundDimmingOpacity = 0.5;//0.05;
    self.periodMenu.componentTextAlignment = NSTextAlignmentLeft;
    self.periodMenu.dropdownCornerRadius = TCSCALE(4.0);
    self.periodMenu.rowSeparatorColor = THEME_BACKGROUND_COLOR;
    
    UIImage *disclosureImg = [UIImage imageNamed:@"dropdown"];
    self.periodMenu.disclosureIndicatorImage = disclosureImg;
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
    NSString *providerName = _config.basic_info.cluster_name;
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
    
    TCServerSystemConfig *sysConfig = _config.system_info.config;
    _systemNameLabel.text = sysConfig.os_name;
    CGFloat gigaByte = sysConfig.memory / 1024.0;
    NSString *memoryDescStr = [NSString stringWithFormat:@"%gG",gigaByte];
    _memoryDescLabel.text = memoryDescStr;
    NSString *cpuDescStr = [NSString stringWithFormat:@"%d",(int)(sysConfig.cpu)];
    _cpuDescLabel.text = cpuDescStr;
    _storageDescLabel.text = @"暂无数据";
    _networkDescLabel.text = @"暂无数据";
}

- (void) updateSystemLoadUI
{
    _systemTimeLabel.text = _systemLoad.date;
    _runTimeLabel.text = _systemLoad.run_time;
    NSString *amountStr = [NSString stringWithFormat:@"%d",(int)_systemLoad.login_users];
    _loginUserAmountLabel.text = amountStr;
    NSString *oneMinStr = [NSString stringWithFormat:@"%g",_systemLoad.one_minute_load];
    _oneMinLabel.text = oneMinStr;
    NSString *fiveMinStr = [NSString stringWithFormat:@"%g",_systemLoad.five_minute_load];
    _fiveMinLabel.text = fiveMinStr;
    NSString *tenMinStr = [NSString stringWithFormat:@"%g",_systemLoad.fifteen_minute_load];
    _tenMinLabel.text = tenMinStr;
}

- (IBAction) onAverageLoadButton:(id)sender
{
    [TCAlertController presentWithTitle:@"平均负载的值越小代表系统压力越小，越大则代表系统压力越大。"
                                okBlock:nil];
}

- (IBAction) onInfoButton:(id)sender
{
    TCServerInfoViewController *infoVC = [[TCServerInfoViewController alloc] initWithServerID:_serverID];
    infoVC.title = _config.basic_info.name;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction) onHelpButton:(id)sender
{
    NSLog(@"on help button");
}

- (IBAction) onConfigButton:(id)sender
{
    NSLog(@"on config button");
}

- (IBAction) onResourceDetailButton:(id)sender
{
    NSLog(@"on res detail button");
}

- (IBAction) onFeeDetailButton:(id)sender
{
    NSLog(@"on fee detail button");
}

- (IBAction) onMonitorDetailButton:(id)sender
{
    NSLog(@"on monitor detail button");
}


#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return _periodMenuOptions.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return TCSCALE(32);
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return MAX(dropdownMenu.bounds.size.width/3, 125);
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    UIFont *menuFont = [UIFont systemFontOfSize:TCSCALE(12)];
    NSDictionary *attr = @{ NSFontAttributeName : menuFont,
                            NSForegroundColorAttributeName :THEME_PLACEHOLDER_COLOR
                            };
    NSString *rawStr = self.periodMenuOptions[_periodSelectedIndex];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:rawStr
                                                              attributes:attr];
    return str;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    UIFont *menuFont = [UIFont systemFontOfSize:TCSCALE(12)];
    NSDictionary *attr = @{ NSFontAttributeName : menuFont,
                            NSForegroundColorAttributeName :THEME_TEXT_COLOR
                            };
    NSString *rawStr = self.periodMenuOptions[_periodSelectedIndex];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:rawStr
                                                              attributes:attr];
    return str;
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ShapeSelectView *shapeSelectView = (ShapeSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[ShapeSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShapeSelectView class]) owner:nil options:nil] firstObject];
    }
    NSString *statusStr = self.periodMenuOptions[row];
    shapeSelectView.textLabel.text = statusStr;
    shapeSelectView.selected = _periodSelectedIndex == row;
    return shapeSelectView;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self colorForRow:row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _periodSelectedIndex = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    [self reloadChartData];
}

- (UIColor *)colorForRow:(NSInteger)row {
    return DROPDOWN_CELL_BG_COLOR;
}
@end
