![Vizury Logo](https://github.com/vizury/vizury-ios-sdk/blob/master/VizuryLogo.png)
## Summary
 This is iOS SDK integration guide.

## Components

  * [Example app](#example-app)
  * [Basic Integration](#basic-integration)
	* [Getting the SDK](#sdk-get)
	* [Add the SDK to project](#sdk-add)
	* [Vizury SDK Initialization](#sdk-init)
	* [Event Logging](#event-logging)
  * [Push Notifications](#push-notifications)
	* [Configuring Apple Developer Settings](#config-apple-dev)
	* [Configuring project for GCM](#config-gcm)
		* [Set up CocoaPods dependencies](#setup-pods)
		* [Enabling GCM](#enable-gcm)
	* [Configuring Application](#config-app) 
	* [DeepLinks](#deeplinks)
 
## <a id="basic-integration"></a>Basic Integration

### <a id="sdk-get"></a>Getting the SDK
Download the latest Vizury iOS SDK [`VizuryEventLogger`][VizuryEventLogger_ios] . Extract the archive into a directory of your choice. The extracted file is `VizuryEventLogger.framework`

### <a id="sdk-add"></a>Add the SDK to project
Go to the Build phases -> Link Binary with Libraries

![addSDK-1](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/addSDK-1.png)


Click on the `+` icon -> Add Other. Add the extracted `VizuryEventLogger.framework` file

![addSDK-2](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/addSDK-2.png)


### <a id="sdk-init"></a>Vizury SDK Initialization
 
 Import the VizuryEventLogger
 
 ```objc
 #import <VizuryEventLogger/VizuryEventLogger.h>
 ```
 
 Add the follwing in `didFinishLaunchingWithOptions` method to initialize the SDK
 
```objc
  [VizuryEventLogger initializeEventLoggerInApplication:(UIApplication*)application
                            WithPackageId:(NSString *)packageId
                            ServerURL:(NSString *)serverURL
                            WithCachingEnabled:(BOOL) caching
                            AndGCMWithSandBoxOption:(NSObject *)sandBoxOption];
```
```
Where 
  packageId     : packageId obtained from vizury
  serverURL     : serverURL obtained from vizury
  caching       : pass true if your app supports offline usage and you want to send user behaviour data 
                  to vizury while he was offline. Pass false otherwise
  sandBoxOption : @YES for for development or @NO for production
``` 
 
### <a id="event-logging"></a>Event Logging

When a user browse through the app, various activities happen e.g. visiting a product, adding the product to cart, making purchase, etc. These are called events. Corresponding to each event, app needs to pass certain variables to the SDK which the SDK will automatically pass to Vizury servers.
Create an attributeDictionary with the attributes associated with the event and call `VizuryEventLogger logEvent` with event name and the attributeDictionary.

```objc
	#import <VizuryEventLogger/VizuryEventLogger.h>

	NSDictionary *attributeDictionary  =   [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"AKSJDASNBD",@"productid",
                                            @"789", @"productPrice",
                                            @"Shirt",@"category",
                                            nil];

    [VizuryEventLogger logEvent:@"productPage" WithAttributes:attributeDictionary];
```


## <a id="push-notifications"></a>Push Notifications

### <a id="config-apple-dev"></a>Configuring Apple Developer Settings

To enable sending Push Notifications through APNs, you need

a) An SSL certificate associated with an App ID configured for Push Notifications.
    
b) Provisioning profile for that App ID.

You can create both in the [Apple Developer Member Center][apple-dev-member-center]


### <a id="config-gcm"></a>Configuring project for GCM

For sending push notifications we are using GCM-APNS interface. For this you need to get a configuration file from google	


### <a id="setup-pods"></a>Set up CocoaPods dependencies

* If you don't have an Xcode project yet, create one now.
* Create a Podfile if you don't have one:

```
$ cd your-project directory
$ pod init
```

* Add the pods that you want to install. You can include a Pod in your Podfile like this:

```
pod 'Google/CloudMessaging'
```

* Install the pods and open the .xcworkspace file to see the project in Xcode.

```
$ pod install
$ open your-project.xcworkspace
```
	
### <a id="enable-gcm"></a>Enabling GCM

Create a google project [here][create-project] if you don't already have one. Enter the `AppName` and `iOS Bundle Id`. The `iOS Bundle Id` should be same as your apps bundle identifier.

![createProject-1](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/createProject-1.png)

Click `Cloud Messaging` -> upload APNS Certificate (P12 format) and click on `ENABLE CLOUD MESSAGING`.

`Note: You can upload development or production APNS certificate and configuration file will be generated accordingly`

![createProject-3](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/createProject-3.png)

Click on `Generate configuration Files` and download the `GoogleService-Info.plist` file. Also note down the the `Server API Key` as this will be required later during the integration


### <a id="config-app"></a>Configuring Application

* Drag the GoogleService-Info.plist file you just downloaded into the root of your Xcode project and add it to all targets
* Register for Pushnotifications inside didFinishLaunchingWithOptions method of you AppDelegate

```objc
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
    } else {
        // iOS 8 or later
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
```

* Post Registration 

Pass the APNS token to Vizury

```objc
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [VizuryEventLogger registerForPushWithToken:deviceToken];
}
```

In case of any failed registration

```objc
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

    [VizuryEventLogger didFailToRegisterForPush];
}
```

* Handling notification payload

```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(							UIBackgroundFetchResult))completionHandler {
    [VizuryEventLogger didReceiveRemoteNotificationInApplication:application withUserInfo:userInfo];
 }
```

### <a id="deeplinks"></a> Deeplinks

In order to open Deep Links that are sent to the device as a Key/Value pair along with a push notification you must implement a custom handler

```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(							UIBackgroundFetchResult))completionHandler {
    [VizuryEventLogger didReceiveRemoteNotificationInApplication:application withUserInfo:userInfo];
    if(application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Appilication Inactive - the user has tapped in the notification when app was closed or in background");
    	[self customPushHandler:userInfo];
    }
 }

- (void) customPushHandler:(NSDictionary *)notification {
    if (notification !=nil && [notification objectForKey:@"deeplink"] != nil) {
        NSString* deeplink = [notification objectForKey:@"deeplink"];
        NSLog(@"%@",deeplink);
        // Here based on the deeplink you can open specific screens that's part of your app
    }
}
```




 
 [VizuryEventLogger_ios]:    https://github.com/vizury/vizury-ios-sdk/blob/master/VizuryEventLogger.framework.zip
 [apple-dev-member-center]:  https://developer.apple.com/membercenter/index.action
 [create-project]:           https://developers.google.com/mobile/add?platform=ios
