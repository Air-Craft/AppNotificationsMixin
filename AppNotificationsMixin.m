//
//  AppNotificationsMixin.m
//  SoundWandMidi
//
//  Created by Hari Karam Singh on 25/12/2013.
//
//

#import "AppNotificationsMixin.h"

/** We need to keep track of the notification ids to remove them later on a per object basis.  Form: { object: [ids] } */
static NSMutableDictionary *_objectToNotifIdsMap;

@implementation AppNotificationsMixin

+ (void)mixinToObject:(id<AppNotificationsObserver>)anObject
{
    // Remove any existing first in case they re-add
    [self removeFromObject:anObject];
    
    // Init the map
    if (!_objectToNotifIdsMap) _objectToNotifIdsMap = [NSMutableDictionary dictionary];
    
    NSMutableArray *_idsForObject = [NSMutableArray array];
    
    // Add the observer hooks but only if the method is implemented
    if ([anObject respondsToSelector:@selector(applicationDidEnterBackground)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationDidEnterBackgroundNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationDidEnterBackground];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationWillEnterForeground)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationWillEnterForegroundNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationWillEnterForeground];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationDidFinishLaunchingWithOptions:)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationDidFinishLaunchingNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationDidFinishLaunchingWithOptions:note.userInfo];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationDidBecomeActive)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationDidBecomeActiveNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationDidBecomeActive];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationWillResignActive)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationWillResignActiveNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationWillResignActive];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationDidReceiveMemoryWarning)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationDidReceiveMemoryWarningNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationDidReceiveMemoryWarning];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationWillTerminate)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationWillTerminateNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationWillTerminate];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationSignificantTimeChange)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationSignificantTimeChangeNotification"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationSignificantTimeChange];
                          
                      }];
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationProtectedDataWillBecomeUnavailable)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationProtectedDataWillBecomeUnavailable"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationProtectedDataWillBecomeUnavailable];
                          
                      }];    
        [_idsForObject addObject:notifId];
    }
    
    if ([anObject respondsToSelector:@selector(applicationProtectedDataDidBecomeAvailable)]) {
        id notifId = [[NSNotificationCenter defaultCenter]
                      addObserverForName:@"UIApplicationProtectedDataDidBecomeAvailable"
                      object:nil
                      queue:nil
                      usingBlock:^(NSNotification *note) {
                          
                          [anObject applicationProtectedDataDidBecomeAvailable];
                          
                      }];    
        [_idsForObject addObject:notifId];
    }
    
    // Add to our tracking map.  We need a literal ref as we can't assume NSCopying
    if (_idsForObject.count) {
        NSValue *key = [NSValue valueWithPointer:(__bridge const void *)anObject];
        _objectToNotifIdsMap[key] = _idsForObject;
    }
}

//---------------------------------------------------------------------

+ (void)removeFromObject:(id<AppNotificationsObserver>)anObject
{
    if (_objectToNotifIdsMap) return;
    
    // Find our object
    __block NSArray *notifIds;
    for (NSValue *key in [_objectToNotifIdsMap allKeys]) {
        if (key.pointerValue == (__bridge const void *)anObject) {
            notifIds = [_objectToNotifIdsMap objectForKey:key];
        }
    }
    
    // If found them remove them
    if (notifIds) {
        for (id notifId in notifIds) {
            [[NSNotificationCenter defaultCenter] removeObserver:notifId];
        }
    }

}


@end
