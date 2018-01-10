//
//  PCCImageService.m
//  PCChallenege
//
//  Created by Kaushik on 1/8/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCCImageService.h"


const NSString * imageCacheKeyPrefix = @"Image-";

@interface PCCImageService(){
    NSCache * cache;
}
@end
@implementation PCCImageService

+ (id)sharedService {
    static PCCImageService *_serviceManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceManager = [[self alloc] init];
    });
    
    return _serviceManager;
}


-(id) init {
    self = [super init];
    if(self) {
        cache = [[NSCache alloc] init];
    }
    return self;
}

/**
 * Get Image from cache first and if not then get from server
 *
 **/

- (void) getImageForKey: (NSString *) key
       completion: (void (^)(UIImage * image)) handler
{
    UIImage * image = [cache objectForKey: key];
    
    if(image)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler(image);
        });
    }
    else
    {
        
        image = [UIImage imageNamed:@"DefaultImage"];
        
        [cache setObject:image forKey: key];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler(image);
        });
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0ul ),^(void){
            
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:key]]];
            
            if( !image)
            {
                image = [UIImage imageNamed:@"DefaultImage"];
                
            }
            
            [cache setObject:image forKey: key];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                handler(image);
            });
        });
    }
}


- (void) getItemImage: (NSString *) imagePath
           completion: (void (^)(UIImage * image)) handler
{
    [self getImageForKey:imagePath completion:handler];
}

@end
