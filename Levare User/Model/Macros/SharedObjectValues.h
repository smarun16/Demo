//
//  SharedObjectValues.h
//
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#ifndef iOSAppTemplate_SharedObjectValues_h
#define iOSAppTemplate_SharedObjectValues_h


#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define DBMANAGER [DbManager sharedObject]
#define HTTPMANAGER [HttpManager sharedObject]
#define SESSION [Session sharedObject]
#define SESSION_2 [Session2 sharedObject]
#define NAVIGATION [Navigation sharedObject]
#define HELPER [Helper sharedObject]
#define COREDATAMANAGER [CoreDataManager sharedObject]
#define STORY_BOARD [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#endif
