//
//  TCStaffListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStaffListRequest.h"
#import "TCStaff+CoreDataClass.h"

@interface TCStaffListRequest()

@end

@implementation TCStaffListRequest


- (void) startWithSuccess:(void(^)(NSArray<TCStaff *> *staffArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *arrayDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *resArray = [TCStaff mj_objectArrayWithKeyValuesArray:arrayDict context:context];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *url = [NSString stringWithFormat:@"/api/company/%ld/employees",cid];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
