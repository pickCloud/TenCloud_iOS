//
//  TCMessageCountRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMessageCountRequest.h"
#import "TCDataSync.h"

@interface TCMessageCountRequest()
@property (nonatomic, assign)       NSInteger        status;
@end

@implementation TCMessageCountRequest

- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        _status = status;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSInteger count))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSNumber *msgNum = [dataDict objectForKey:@"num"];
            if (msgNum)
            {
                success ? success (msgNum.integerValue) : nil;
            }
            NSNumber *permNum = [dataDict objectForKey:@"permission_changed"];
            if (permNum)
            {
                if (permNum.integerValue == 1)
                {
                    [[TCDataSync shared] permissionChanged];
                }
            }
            NSNumber *adminNum = [dataDict objectForKey:@"admin_changed"];
            if (adminNum)
            {
                if (adminNum.integerValue > 0)
                {
                    BOOL isAdmin = adminNum.integerValue == 1;
                    [[TCDataSync shared] adminChanged:isAdmin];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/messages/count";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return @{@"status":@(_status)};
}
@end
