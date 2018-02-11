//
//  TCCorpProfileRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCorpProfileRequest.h"
#import "TCCorp+CoreDataClass.h"

@interface TCCorpProfileRequest()
@property (nonatomic, assign)   NSInteger     corpID;
@end

@implementation TCCorpProfileRequest

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.ignoreCache = YES;
    }
    return self;
}

- (instancetype) initWithCorpID:(NSInteger)cid
{
    self = [super init];
    if (self)
    {
        _corpID = cid;
        self.ignoreCache = YES;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(TCCorp *user))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        TCCorp *corp = [self resultCorp];
        success ? success(corp) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (TCCorp *) resultCorp
{
    NSArray *corpDictArray = [self.responseJSONObject objectForKey:@"data"];
    if (corpDictArray && corpDictArray.count >= 1)
    {
        NSDictionary *corpDict = corpDictArray.firstObject;
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCCorp *corp = [TCCorp mj_objectWithKeyValues:corpDict context:context];
        return corp;
    }
    return nil;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/company/%ld",_corpID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

/*
- (id)requestArgument
{
    return nil;
}
 
- (NSInteger)cacheTimeInSeconds
{
    return 0;
}
 */

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
