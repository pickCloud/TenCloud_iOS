//
//  TCLocalAccount.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCLocalAccount.h"
#import "TCUser+CoreDataClass.h"

#define ACCOUNT_MOBILE      @"ACCOUNT_MOBILE"
#define ACCOUNT_TOKEN       @"ACCOUNT_TOKEN"

@interface TCLocalAccount ()
{
    NSMutableArray      *mObserverArray;
}
@end

@implementation TCLocalAccount

+ (TCLocalAccount *) shared
{
    static TCLocalAccount *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCLocalAccount alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        mObserverArray = [NSMutableArray new];
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [array.firstObject stringByAppendingPathComponent:@"accountArchiverModel"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        {
            NSData *undata = [[NSData alloc] initWithContentsOfFile:fileName];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
            self = [unarchiver decodeObjectForKey:@"account_model"];
            [unarchiver finishDecoding];
        }
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        mObserverArray = [NSMutableArray new];
        self.mobile = [aDecoder decodeObjectForKey:ACCOUNT_MOBILE];
        self.token = [aDecoder decodeObjectForKey:ACCOUNT_TOKEN];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mobile forKey:ACCOUNT_MOBILE];
    [aCoder encodeObject:self.token forKey:ACCOUNT_TOKEN];
}

- (void) addObserver:(id<TCLocalAccountDelegate>)obs
{
    if (obs)
    {
        [mObserverArray addObject:obs];
    }
}

- (void) removeObserver:(id<TCLocalAccountDelegate>)obs
{
    if (obs)
    {
        [mObserverArray removeObject:obs];
    }
}

- (BOOL) isLogin
{
    return ((self.token != nil) && (self.token.length > 0));
}

- (void) loginSuccess:(TCUser*)user
{
    NSLog(@"login success, prepare send notification");
    TCLocalAccount *account = [TCLocalAccount shared];
    account.mobile = user.mobile;
    account.token = user.token;
    [account save];
    for (id<TCLocalAccountDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(accountLoggedIn:)])
        {
            [obs accountLoggedIn:account];
        }
    }
}

- (void) logout
{
    TCLocalAccount *account = [TCLocalAccount shared];
    account.mobile = @"";
    account.token = @"";
    [account save];
    for (id<TCLocalAccountDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(accountLogout:)])
        {
            [obs accountLogout:account];
        }
    }
}

- (void) save
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[TCLocalAccount shared] forKey:@"account_model"];
    [archiver finishEncoding];
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:@"accountArchiverModel"];
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"归档成功");
    }
}

@end
