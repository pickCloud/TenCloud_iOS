//
//  TCAppRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAppRequest.h"
#import "TCApp+CoreDataClass.h"

@interface TCAppRequest()
@end

@implementation TCAppRequest

- (void) startWithSuccess:(void(^)(TCApp *app))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *userDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCApp *app = [TCApp mj_objectWithKeyValues:userDict context:context];
        success ? success(app) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/application";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return @{@"id":@(_appID)};
}

@end
