//
//  main.swift
//  vhm
//
//  Created by František Blachowicz on 26.05.15.
//  Copyright (c) 2015 František Blachowicz. All rights reserved.
//

extension String {
    func createFolderAt(location: NSSearchPathDirectory) -> Bool {
        if let directoryUrl = NSFileManager().URLsForDirectory(location, inDomains: .UserDomainMask).first as? NSURL {
            let folderUrl = directoryUrl.URLByAppendingPathComponent(self)
            var err: NSErrorPointer = nil
            return NSFileManager().createDirectoryAtPath(folderUrl.path!, withIntermediateDirectories: true, attributes: nil, error: err)
        }
        return false
    }
}

import Foundation

let vhostsPath = "/Applications/XAMPP/xamppfiles/etc/extra/httpd-vhosts.conf"
let hostsPath = "/etc/hosts"


if Process.arguments.count <= 1 {
    println("VHost name not supplied")
    exit(1)
}


let vhostName = Process.arguments[1]


let vhostDir = NSHomeDirectory()+"/"+vhostName+"/"

var err: NSErrorPointer = nil
let manager = NSFileManager.defaultManager()
manager.createDirectoryAtPath(vhostDir, withIntermediateDirectories: true, attributes: nil, error: err)


let vhostsContent = String(contentsOfFile: vhostsPath, encoding: NSUTF8StringEncoding, error: nil)
if vhostsContent != nil {
    let vhostsResult = vhostsContent! +
    "\n<VirtualHost *:80>\n   ServerName \(vhostName)\n   DocumentRoot \"\(vhostDir)\"\n   <Directory \"\(vhostDir)\">\n       Options Indexes FollowSymLinks Includes ExecCGI\n       AllowOverride All\n       Require all granted\n   </Directory>\n   ErrorLog \"logs/\(vhostName)-error_log\"\n</VirtualHost>"
    
    
    
    let hostsContent = String(contentsOfFile: hostsPath, encoding: NSUTF8StringEncoding, error: nil)
    if hostsContent != nil {
        let hostsResult = hostsContent! +
            "\n127.0.0.1\t"+vhostName
    
    
        hostsResult.writeToFile(hostsPath, atomically: false, encoding: NSUTF8StringEncoding, error: err)
        
        vhostsResult.writeToFile(vhostsPath, atomically: false, encoding: NSUTF8StringEncoding, error: err)
            
        println("VHost \(vhostName) successfully created.")
        println("directory: \(vhostDir)")
    
    }
    else {
        println("Host file error")
        exit(1)
    }
    
}
else {
    println("VHost file error")
    exit(1)
}







