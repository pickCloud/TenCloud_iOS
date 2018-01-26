//
//  TCMessageListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMessageListRequest.h"
#import "TCMessage+CoreDataClass.h"

@interface TCMessageListRequest()
@end

@implementation TCMessageListRequest

- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        self.ignoreCache = YES;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCMessage*> *messageArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataArrayDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *msgArray = [TCMessage mj_objectArrayWithKeyValuesArray:dataArrayDict context:context];
        success ? success(msgArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/messages/?page=%ld&mode=%ld",_page,_mode];
    if (_mode == 0)
    {
        url = [NSString stringWithFormat:@"/api/messages/?page=%ld",_page];
    }
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
