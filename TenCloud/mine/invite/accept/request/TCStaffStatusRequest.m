//
//  TCStaffStatusRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStaffStatusRequest.h"

@interface TCStaffStatusRequest()
@property (nonatomic, assign)   NSInteger   corpID;
@end

@implementation TCStaffStatusRequest

- (instancetype) initWithCorpID:(NSInteger)corpID
{
    self = [super init];
    if (self)
    {
        _corpID = corpID;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSInteger status))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict && ![dataDict isKindOfClass:[NSNull class]])
        {
            NSNumber *statusNumber = [dataDict objectForKey:@"status"];
            if (statusNumber)
            {
                success ? success(statusNumber.integerValue) : nil;
            }
        }else
        {
            success ? success(STAFF_STATUS_UNEXIST) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/employee/status";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return @{@"id":@(_corpID)};
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    NSString *token = [[TCLocalAccount shared] token];
    if (token == nil)
    {
        token = @"";
    }
    NSString *cidStr = [NSString stringWithFormat:@"%ld",_corpID];
    return [NSDictionary dictionaryWithObjectsAndKeys:token,@"Authorization",
            cidStr,@"Cid", nil];
}
@end
