//
//  FoodFoodAppDelegate.h
//  FoodFood
//
//  Created by Francis Lukesh on 3/28/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodFoodAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)grabURL;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
