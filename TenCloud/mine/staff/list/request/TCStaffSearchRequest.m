//
//  TCStaffSearchRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStaffSearchRequest.h"
#import "TCStaff+CoreDataClass.h"

@interface TCStaffSearchRequest()

@end

@implementation TCStaffSearchRequest

- (void) startWithSuccess:(void(^)(NSArray<TCStaff*> *staffArray))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
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
