//
//  SSAppDelegate.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "CENTROAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "SSUser.h"

static NSString *const kCENTROAPIBaseURLString = @"http://centro.herokuapp.com/";

@implementation CENTROAPIClient

+ (CENTROAPIClient *)sharedClient {
    static CENTROAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString: kCENTROAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (BOOL) networkIsReachable {
    
    BOOL networkReach = NO;
    
    if ([self networkReachabilityStatus] == -1) {
        networkReach = NO;
    } else if ([self networkReachabilityStatus] == 0) {
        networkReach = NO;
    } else if ([self networkReachabilityStatus] == 1) {
        networkReach = YES;
    } else if ([self networkReachabilityStatus] == 2) {
        networkReach = YES;
    } else {
        networkReach = NO;
    }
    
    return networkReach;
}

@end