//
//  CENTROAPIClient.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface CENTROAPIClient : AFHTTPClient

+ (CENTROAPIClient *)sharedClient;
- (BOOL) networkIsReachable;

@end