//
//  TCNetProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/21.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCNetProfileViewController.h"
#import <WYChart/WYLineChartView.h>
#import <WYChart/WYChartCategory.h>
#import <WYChart/WYLineChartPoint.h>
#import <WYChart/WYLineChartCalculator.h>
#import "NSString+Extension.h"

//need change
#import "TCServerPerformanceRequest.h"
#import "TCServerPerformance+CoreDataClass.h"
#import "TCServerCPU+CoreDataClass.h"
#import "TCServerMemory+CoreDataClass.h"
#import "TCServerDisk+CoreDataClass.h"
#import "TCServerNet+CoreDataClass.h"


@interface TCNetProfileViewController ()<WYLineChartViewDelegate,WYLineChartViewDatasource>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    WYLineChartView *ipChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView *tcpChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView *udpChartView;
@property (nonatomic, weak) IBOutlet    WYLineChartView *icmpChartView;
@property (nonatomic, strong)   NSMutableArray      *ipPoints;
@property (nonatomic, strong)   NSMutableArray      *tcpPoints;
@property (nonatomic, strong)   NSMutableArray      *udpPoints;
@property (nonatomic, strong)   NSMutableArray      *icmpPoints;
- (void) initChartUI;
- (void) updateChartUI;
- (void) reloadChartData;

//need change
@property (nonatomic, assign)   NSInteger           serverID;
@property (nonatomic, strong)   TCServerPerformance *performance;
@end

@implementation TCNetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.title = @"网络情况";
    _ipPoints = [NSMutableArray new];
    _tcpPoints = [NSMutableArray new];
    _udpPoints = [NSMutableArray new];
    _icmpPoints = [NSMutableArray new];
    
    //need change
    _serverID = 186;
#if ONLINE_ENVIROMENT
    _serverID = 20;
#endif
    
    [self initChartUI];
    [self startLoadingWithBackgroundColor:YES];
    [self reloadChartData];
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

#pragma mark - extension
- (void) initChartUI
{
    UIColor *axisColor = [UIColor colorWithRed:102/255.0 green:112/255.0 blue:130/255.0 alpha:1.0];
    
    //设置IP曲线图
    _ipChartView.backgroundColor = [UIColor clearColor];
    _ipChartView.delegate = self;
    _ipChartView.datasource = self;
    _ipChartView.clipsToBounds = NO;
    
    _ipChartView.lineLeftMargin = 0;
    _ipChartView.lineRightMargin = 0;
    _ipChartView.lineTopMargin = 0;
    _ipChartView.lineBottomMargin = 0;
    
    _ipChartView.animationDuration = 1.0;
    _ipChartView.animationStyle = kWYLineChartAnimationDrawing;
    _ipChartView.scrollable = NO;
    _ipChartView.pinchable = NO;
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:@[@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(1.0)]];
    [mutableArray addObject:tmpPoints];
    _ipPoints = mutableArray;
    _ipChartView.points = [NSArray arrayWithArray:_ipPoints];
    
    _ipChartView.touchPointColor = [UIColor redColor];
    _ipChartView.labelsFont = [UIFont systemFontOfSize:10];
    
    _ipChartView.verticalReferenceLineColor = [UIColor clearColor];
    _ipChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _ipChartView.axisColor = axisColor;
    _ipChartView.labelsColor = axisColor;
    
    //设置TCP曲线图
    _tcpChartView.backgroundColor = [UIColor clearColor];
    _tcpChartView.delegate = self;
    _tcpChartView.datasource = self;
    _tcpChartView.lineLeftMargin = 0;
    _tcpChartView.lineRightMargin = 0;
    _tcpChartView.lineTopMargin = 0;
    _tcpChartView.lineBottomMargin = 0;
    _tcpChartView.animationDuration = 1.0;
    _tcpChartView.animationStyle = kWYLineChartAnimationDrawing;
    _tcpChartView.scrollable = NO;
    _tcpChartView.pinchable = NO;
    _tcpPoints = mutableArray;
    _tcpChartView.points = [NSArray arrayWithArray:_tcpPoints];
    _tcpChartView.labelsFont = [UIFont systemFontOfSize:10];
    _tcpChartView.verticalReferenceLineColor = [UIColor clearColor];
    _tcpChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _tcpChartView.axisColor = axisColor;
    _tcpChartView.labelsColor = axisColor;
    
    //设置UDP曲线图
    _udpChartView.backgroundColor = [UIColor clearColor];
    _udpChartView.delegate = self;
    _udpChartView.datasource = self;
    _udpChartView.lineLeftMargin = 0;
    _udpChartView.lineRightMargin = 0;
    _udpChartView.lineTopMargin = 0;
    _udpChartView.lineBottomMargin = 0;
    _udpChartView.animationDuration = 1.0;
    _udpChartView.animationStyle = kWYLineChartAnimationDrawing;
    _udpChartView.scrollable = NO;
    _udpChartView.pinchable = NO;
    _udpPoints = mutableArray;
    _udpChartView.points = [NSArray arrayWithArray:_udpPoints];
    _udpChartView.labelsFont = [UIFont systemFontOfSize:12];
    _udpChartView.verticalReferenceLineColor = [UIColor clearColor];
    _udpChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _udpChartView.axisColor = axisColor;
    _udpChartView.labelsColor = axisColor;
    
    //设置ICMP曲线图
    _icmpChartView.backgroundColor = [UIColor clearColor];
    _icmpChartView.delegate = self;
    _icmpChartView.datasource = self;
    _icmpChartView.lineLeftMargin = 0;
    _icmpChartView.lineRightMargin = 0;
    _icmpChartView.lineTopMargin = 0;
    _icmpChartView.lineBottomMargin = 0;
    _icmpChartView.animationDuration = 1.0;
    _icmpChartView.animationStyle = kWYLineChartAnimationDrawing;
    _icmpChartView.scrollable = NO;
    _icmpChartView.pinchable = NO;
    _icmpPoints = mutableArray;
    _icmpChartView.points = [NSArray arrayWithArray:_icmpPoints];
    _icmpChartView.labelsFont = [UIFont systemFontOfSize:12];
    _icmpChartView.verticalReferenceLineColor = [UIColor clearColor];
    _icmpChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    _icmpChartView.axisColor = axisColor;
    _icmpChartView.labelsColor = axisColor;
}

- (void) updateChartUI
{
    //重新计算ip points
    [_ipPoints removeAllObjects];
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
    [_ipPoints addObjectsFromArray:mutableArray];
    self.ipChartView.points = [NSArray arrayWithArray:_ipPoints];
    [self.ipChartView updateGraph];
    
    //重新计算tcp points
    [_tcpPoints removeAllObjects];
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
    [_tcpPoints addObjectsFromArray:memoryPointArray];
    self.tcpChartView.points = [NSArray arrayWithArray:_tcpPoints];
    [self.tcpChartView updateGraph];
    
    //重新计算udp points
    [_udpPoints removeAllObjects];
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
    [_udpPoints addObjectsFromArray:diskPointArray];
    self.udpChartView.points = [NSArray arrayWithArray:_udpPoints];
    [self.udpChartView updateGraph];
    
    //重新计算网络points
    [_icmpPoints removeAllObjects];
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
    [_icmpPoints addObjectsFromArray:outputPointArray];
    
    self.icmpChartView.points = [NSArray arrayWithArray:_icmpPoints];
    [self.icmpChartView updateGraph];
}

- (void) reloadChartData
{
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    //startTime = endTime - 86400;  //24hour
    //startTime = endTime - 604800;   //one week
    //startTime = endTime - 3600;
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


#pragma mark - WYLineChartViewDelegate

- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _ipChartView)
    {
        return [_ipPoints[0] count];
    }else if(chartView == _udpChartView)
    {
        return [_udpPoints[0] count];
    }else if(chartView == _tcpChartView)
    {
        return [_tcpPoints[0] count];
    }
    return [_icmpPoints[0] count];
}

- (NSInteger)numberOfLabelOnYAxisInLineChartView:(WYLineChartView *)chartView {
    return 8;
}

- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 0.0f;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _ipChartView)
    {
        return [_ipPoints[0] count];
    }else if(chartView == _tcpChartView)
    {
        return [_tcpPoints[0] count];
    }else if(chartView == _udpChartView)
    {
        return [_udpPoints[0] count];
    }
    return [_icmpPoints[0] count];
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    if (chartView == _ipChartView)
    {
        return [_ipPoints[0] count];
    }else if(chartView == _tcpChartView)
    {
        return [_tcpPoints[0] count];
    }else if(chartView == _udpChartView)
    {
        return [_udpPoints[0] count];
    }
    return [_icmpPoints[0] count];
}


#pragma mark - WYLineChartViewDatasource

- (NSString *)lineChartView:(WYLineChartView *)chartView contextTextForPointAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    if (_performance)
    {
        if (chartView == _ipChartView)
        {
            if (index < _performance.cpu.count)
            {
                TCServerCPU *cpuItem = [_performance.cpu objectAtIndex:index];
                return [NSString timeStringFromInteger:cpuItem.created_time];
                /*
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:cpuItem.created_time];
                }
                 
                return [NSString chartTimeStringFromInteger:cpuItem.created_time];
                 */
            }
        }else if(chartView == _tcpChartView)
        {
            if (index < _performance.memory.count)
            {
                TCServerMemory *memoryItem = [_performance.memory objectAtIndex:index];
                NSString *tcpTimeStr = [NSString timeStringFromInteger:memoryItem.created_time];
                //return [NSString timeStringFromInteger:memoryItem.created_time];
                NSLog(@"tcp time str:%@",tcpTimeStr);
                return tcpTimeStr;
                /*
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:memoryItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:memoryItem.created_time];
                 */
            }
        }else if(chartView == _udpChartView)
        {
            if (index < _performance.disk.count)
            {
                TCServerDisk *diskItem = [_performance.disk objectAtIndex:index];
                return [NSString timeStringFromInteger:diskItem.created_time];
                /*
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:diskItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:diskItem.created_time];
                 */
            }
        }else if(chartView == _icmpChartView)
        {
            if (index < _performance.net.count)
            {
                TCServerNet *netItem = [_performance.net objectAtIndex:index];
                return [NSString timeStringFromInteger:netItem.created_time];
                /*
                if (_periodSelectedIndex == 0)
                {
                    return [NSString timeStringFromInteger:netItem.created_time];
                }
                return [NSString chartTimeStringFromInteger:netItem.created_time];
                 */
                
            }
        }
    }
    return [NSString stringWithFormat:@"%lu月", index+1];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _ipChartView)
    {
        return _ipPoints[0][index];
    }else if(chartView == _tcpChartView)
    {
        return _tcpPoints[0][index];
    }else if(chartView == _udpChartView)
    {
        return _udpPoints[0][index];
    }
    return _udpPoints[0][index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    if (chartView == _ipChartView)
    {
        return _ipPoints[0][index];
    }else if(chartView == _tcpChartView)
    {
        return _tcpPoints[0][index];
    }else if(chartView == _udpChartView)
    {
        return _udpPoints[0][index];
    }
    return _icmpPoints[0][index];
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForYAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _ipChartView)
    {
        CGFloat maxValue = [self.ipChartView.calculator maxValuePointsOfLinesPointSet:self.ipChartView.points].value;
        CGFloat minValue = [self.ipChartView.calculator minValuePointsOfLinesPointSet:self.ipChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.ipChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _tcpChartView)
    {
        CGFloat maxValue = [self.tcpChartView.calculator maxValuePointsOfLinesPointSet:self.tcpChartView.points].value;
        CGFloat minValue = [self.tcpChartView.calculator minValuePointsOfLinesPointSet:self.tcpChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.tcpChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }else if(chartView == _udpChartView)
    {
        CGFloat maxValue = [self.udpChartView.calculator maxValuePointsOfLinesPointSet:self.udpChartView.points].value;
        CGFloat minValue = [self.udpChartView.calculator minValuePointsOfLinesPointSet:self.udpChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.udpChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        CGFloat value = minValue + interval * index;
        return [NSString stringWithFormat:@"%.02f",value];
    }
    CGFloat maxValue = [self.icmpChartView.calculator maxValuePointsOfLinesPointSet:self.icmpChartView.points].value;
    CGFloat minValue = [self.icmpChartView.calculator minValuePointsOfLinesPointSet:self.icmpChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.icmpChartView];
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    return [NSString stringWithFormat:@"%.02f",value];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToYAxisLabelAtIndex:(NSInteger)index {
    if (chartView == _ipChartView)
    {
        CGFloat maxValue = [self.ipChartView.calculator maxValuePointsOfLinesPointSet:self.ipChartView.points].value;
        CGFloat minValue = [self.ipChartView.calculator minValuePointsOfLinesPointSet:self.ipChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.ipChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _tcpChartView)
    {
        CGFloat maxValue = [self.tcpChartView.calculator maxValuePointsOfLinesPointSet:self.tcpChartView.points].value;
        CGFloat minValue = [self.tcpChartView.calculator minValuePointsOfLinesPointSet:self.tcpChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.tcpChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }else if(chartView == _udpChartView)
    {
        CGFloat maxValue = [self.udpChartView.calculator maxValuePointsOfLinesPointSet:self.udpChartView.points].value;
        CGFloat minValue = [self.udpChartView.calculator minValuePointsOfLinesPointSet:self.udpChartView.points].value;
        NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.udpChartView];
        CGFloat interval = 5.0;
        if (yPointNum > 0)
        {
            interval = (maxValue - minValue) / yPointNum;
        }
        return (minValue + interval * index);
    }
    CGFloat maxValue = [self.icmpChartView.calculator maxValuePointsOfLinesPointSet:self.icmpChartView.points].value;
    CGFloat minValue = [self.icmpChartView.calculator minValuePointsOfLinesPointSet:self.icmpChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.icmpChartView];
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
    if (chartView == _ipChartView)
    {
        lineColor = [UIColor colorWithRed:151/255.f green:186/255.f blue:147/255.f alpha:1.0];
    }else if(chartView == _tcpChartView)
    {
        lineColor = [UIColor colorWithRed:216/255.f green:91/255.f blue:98/255.f alpha:1.0];
    }else if(chartView == _udpChartView)
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
@end
