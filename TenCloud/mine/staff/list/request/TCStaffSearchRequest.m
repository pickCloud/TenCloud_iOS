//
//  TCStaffSearchRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStaffSearchRequest.h"
//#import "TCServer+CoreDataClass.h"
#import "TCStaff+CoreDataClass.h"

@interface TCStaffSearchRequest()
//@property (nonatomic, assign)   NSInteger   clusterID;
//@property (nonatomic, strong)   NSString    *serverName;
////@property (nonatomic, strong)   NSString    *regionName;
////@property (nonatomic, strong)   NSString    *providerName;
//@property (nonatomic, strong)   NSArray     *regions;
//@property (nonatomic, strong)   NSArray     *providers;
@end

@implementation TCStaffSearchRequest


/*
- (instancetype) initWithServerName:(NSString*)name
                            regions:(NSArray*)regions
                          providers:(NSArray*)providers
{
    self = [super init];
    if (self)
    {
        _clusterID = 1;
        _serverName = name;
        _regions = regions;
        _providers = providers;
        _serverName = _serverName != nil ? _serverName : @"";
    }
    return self;
}
 */

- (void) startWithSuccess:(void(^)(NSArray<TCStaff*> *staffArray))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        /*
        NSArray *containerDictArray = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"container array:%@",containerDictArray);
        NSArray *containerArray = [NSArray mj_objectArrayWithKeyValuesArray:containerDictArray];
        success ? success(containerArray) : nil;
        */
        NSArray *dictArray = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *resArray = [TCStaff mj_objectArrayWithKeyValuesArray:dictArray context:context];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        NSNumber *statusNum = [request.responseJSONObject objectForKey:@"status"];
        failure ? failure(message,statusNum.integerValue) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/employee/search";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument
{
    if (_keyword == nil)
    {
        _keyword = @"";
    }
    if (_status == -100)
    {
        return @{@"employee_name":_keyword};
    }
    return @{
             @"employee_name":_keyword,
             @"status":@(_status)
             };
}
@end
