//
//  http.swift
//  REM
//
//  Created by Ties Kuypers on 07/09/15.
//
//

import Foundation


@objc(HttpController) class HttpController:CDVPlugin {
    
    /*
    required override initialt()
    {
        super.init()
        
        
        //let xmlString:String  = "<?xml version=\"1.0\"?><app id=\"55331ded72a765af0a1d4b1272691377\"><host_device><![CDATA[phone]]></host_device><host_os><![CDATA[MacIntel]]></host_os><type><![CDATA[enmosy_alpha_0.1.1]]></type><version><![CDATA[0.1.1]]></version><authentication_methods><basic_login><username>b6d8d980abacc1d75a4338fb0bb1aa26</username><password>00ee97e4280e9e6f8a2c3283e458e8ff</password></basic_login></authentication_methods></app>"
        //let urlPath: String   = "http://192.168.0.34/proxy/authentication/apps/55331ded72a765af0a1d4b1272691377"
        //let authString:String = "stretch:hmstmbdq"
        
        //self.registerGateway(xmlString, urlPath:urlPath, authString:authString)
    }
    */
    
    var cmd:CDVInvokedUrlCommand? = nil;
    
    
    func getGatewayData(command:CDVInvokedUrlCommand)
    {
        self.cmd = command
        
        let urlPath    = command.arguments[0] as! String
        let authStr    = command.arguments[1] as! String
        
        self.sendRequest(urlPath, authStr: authStr, xmlString: nil)
    }
    

    
    
    func registerGateway(command:CDVInvokedUrlCommand)
    {
        self.cmd = command
        
        let xmlString  = command.arguments[0] as! String
        let urlPath    = command.arguments[1] as! String
        let authStr    = command.arguments[2] as! String
        
    
        self.sendRequest(urlPath, authStr: authStr, xmlString: xmlString)
    }
    
    
    
    func sendRequest(urlPath:String, authStr:String, xmlString:String?)
    {
        let url: NSURL = NSURL(string: urlPath)!
        
        let utf8str        = authStr.dataUsingEncoding(NSUTF8StringEncoding)
        let authEncoded    = utf8str?.base64EncodedStringWithOptions([])
        
        let req: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            req.HTTPMethod           = "POST"
            req.addValue("text/xml", forHTTPHeaderField: "Content-Type")
            req.addValue("Basic \(authEncoded!)", forHTTPHeaderField: "Authorization")
            req.timeoutInterval = 60
            req.HTTPShouldHandleCookies=false
        
        // check if we have data
        if let unwrappedXmlString = xmlString
        {
            req.HTTPBody = unwrappedXmlString.dataUsingEncoding(NSUTF8StringEncoding)!
        }
        
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(req, queue: queue, completionHandler:
        {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
           
            var dataString:String
            var dataResult:CDVPluginResult
            
            if response != nil
            {
                let httpResponse:NSHTTPURLResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode == 500
                {
                    dataString = "A server error occured"
                    dataResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAsString:dataString)
                }
                else
                {
                    dataString = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
                    dataResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAsString:dataString)
                }
            }
            else
            {
                if error != nil
                {
                    dataString = (error?.localizedDescription)!
                    dataResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAsString:dataString)
                }
                else
                {
                    dataString = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
                    dataResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAsString:dataString)
                }
            }
            
            let command:CDVInvokedUrlCommand? = self.cmd!;
            self.commandDelegate?.sendPluginResult(dataResult, callbackId:command?.callbackId)
            
            /*
            var err: NSError!
            /*
            if data == nil
            {
                print("dataTaskWithRequest error: \(err)")
                return
            }
            
            print("AsSynchronous \(data)")
            */
            
            let dataString = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
            let dataResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:dataString)
            
            let command:CDVInvokedUrlCommand? = self.cmd!;
            self.commandDelegate?.sendPluginResult(dataResult, callbackId:command?.callbackId)
            */

        })
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        let currentElement=elementName
        
        print("Element \(currentElement)")
    }
    
    
};
