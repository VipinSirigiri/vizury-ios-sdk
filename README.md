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
      * [Enabling GCM](#enabling-gcm)
      * [Configuring Application](#config-app) 
 
 ## <a id="basic-integration"></a>Basic Integration

### <a id="sdk-get"></a>Getting the SDK
Download the latest Vizury ios SDK [`VizuryEventLogger`][VizuryEventLogger_ios] . Extract the archive into a directory of your choice. The extracted file is `VizuryEventLogger.framework`

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

## <a id="config-apple-dev"></a>Configuring Apple Developer Settings

To enable sending Push Notifications through APNs, you need:
    a) An SSL certificate associated with an App ID configured for Push Notifications.
    b) Provisioning profile for that App ID.

	You can create both in the [Apple Developer Member Center][apple-dev-member-center].

## <a id="enabling-gcm"></a>Enabling GCM

For sending push notifications we are using GCM-APNS interface. For this you need to get a configuration file from google	

Set up CocoaPods dependencies

1. If you don't have an Xcode project yet, create one now.
2. Create a Podfile if you don't have one:

```
$ cd your-project directory
$ pod init
```

3. Add the pods that you want to install. You can include a Pod in your Podfile like this:

```
pod 'Google/CloudMessaging'
```

4. Install the pods and open the .xcworkspace file to see the project in Xcode.

```
$ pod install
$ open your-project.xcworkspace
```

Configuring project for GCM

1. Create a google project [here][create-project] if you dont already have one.

![createProject-1](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/createProject-1.png)

Enable Cloud Messaging and upload APNS Certificate (P12 format) and click on ENABLE COLUD MESSAGING.
Note: You can upload development or production APNS certificate and configuration file will be generated accordingly

![createProject-3](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/createProject-3.png)

Download the GoogleService-Info.plist file

2. Add the GoogleService-Info.plist in the root directory of your project.

 
 [VizuryEventLogger_ios]:    https://github.com/vizury/vizury-ios-sdk/blob/master/VizuryEventLogger.framework.zip
 [apple-dev-member-center]:  https://developer.apple.com/membercenter/index.action
 [create-project]:           https://developers.google.com/mobile/add?platform=ios
