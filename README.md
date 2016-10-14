# swift-http-controller

## Installing the plugin

```
cordova plugin add https://github.com/TKuypers/swift-httpcontroller
```

See the platform independent folders for additional installation instructions

## Usage

The plugin uses the cordova.exec function to communicate with the native functionalities (https://cordova.apache.org/docs/en/4.0.0/guide/hybrid/plugins/#the-javascript-interface)

To call the plugin use
```
cordova.exec(onSucces, onError, 'HttpController' , '[func]', [url, auth]);
```
