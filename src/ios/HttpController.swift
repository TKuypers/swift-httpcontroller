//
//  http.swift
//  Enmosy
//
//  Created by Ties Kuypers on 07/09/15.
//
//

import Foundation


@objc(HttpController) class HttpController:CDVPlugin {
    
    
    var cmd:CDVInvokedUrlCommand? = nil;
    
    func registerGateway(command:CDVInvokedUrlCommand)
    {
        self.cmd = command
        
        let xmlString  = command.arguments[0] as! String
        let urlPath    = command.arguments[1] as! String
        let authStr    = command.arguments[2] as! String
        
        
        let url: NSURL = NSURL(string: urlPath)!
        
        let utf8str        = authStr.dataUsingEncoding(NSUTF8StringEncoding)
        let authEncoded    = utf8str?.base64EncodedStringWithOptions([])
        
        
        let req: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            req.HTTPMethod           = "POST"
            req.addValue("text/xml", forHTTPHeaderField: "Content-Type")
            req.addValue("Basic \(authEncoded!)", forHTTPHeaderField: "Authorization")
        
        let data:NSData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)!

        
        req.timeoutInterval = 60
        req.HTTPBody=data
        req.HTTPShouldHandleCookies=false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(req, queue: queue, completionHandler:
        {
            (response: NSURLResponse?, data: NSData?, err: NSError?) -> Void in
           
            let command:CDVInvokedUrlCommand? = self.cmd!;
            
            if err == nil
            {
                let dataString = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
                let dataResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:dataString)
                
                self.commandDelegate?.sendPluginResult(dataResult, callbackId:command?.callbackId)
            }
            else
            {
                let errorString : String? = err!.localizedDescription
                let errorResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:errorString)
                
                self.commandDelegate?.sendPluginResult(errorResult, callbackId:command?.callbackId)
            }

        })
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        let currentElement=elementName
        
        print("Element \(currentElement)")
    }
    
    
};
