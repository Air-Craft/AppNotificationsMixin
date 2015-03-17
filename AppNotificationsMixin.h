//
//  AppNotificationsMixin.h
//  SoundWandMidi
//
//  Created by Hari Karam Singh on 25/12/2013.
//
//

#import <Foundation/Foundation.h>

@protocol AppNotificationsObserver <NSObject>

@optional 
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;
- (void)applicationDidReceiveMemoryWarning;
- (void)applicationWillTerminate;
- (void)applicationSignificantTimeChange;
- (void)applicationProtectedDataWillBecomeUnavailable;
- (void)applicationProtectedDataDidBecomeAvailable;

// For later...
//- (void)applicationWillChangeStatusBarOrientation; // userInfo contains NSNumber with new orientation;
//- (void)applicationDidChangeStatusBarOrientation;
//- (void)applicationWillChangeStatusBarFrame;       // userInfo contains NSValue with new frame;
//- (void)applicationDidChangeStatusBarFrame;
//- (void)contentSizeCategoryDidChange;

/** iOS7 */
//- (void)applicationBackgroundRefreshStatusDidChange;
//- (void)applicationUserDidTakeScreenshot;
//

@end

/** Not a true mixin but hooks up NSNotifications to a particular NSObject which call optional event methods on that object  */
@interface AppNotificationsMixin : NSObject

/** Start listening to app notifs on your object instance.  Only protocol methods _currently_ responded to will get event hooks.  If you add it dynamically later, you'll need to call this again.  Safe to call multiple times - all previous are removed before adding  */
+ (void)mixinToObject:(id<AppNotificationsObserver>)anObject;

/** Stop listening to notifications.  Probably a good idea to call if your object is temporary. (UNTESTED) */
+ (void)removeFromObject:(id<AppNotificationsObserver>)anObject;


@end
