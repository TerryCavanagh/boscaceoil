I downloaded and installed the [AIRSDK](https://www.adobe.com/devnet/air/air-sdk-download.html)
and installed the Adobe AIR 29(cause few people told me AIR32 wasn’t working and AIR 29 was working on Catalina ).

But it wasn’t running on Catalina due to some issues, so I found this [post](https://community.adobe.com/t5/air/quot-installation-file-is-damaged-quot-when-installing-an-air-supported-app/td-p/9540338?page=1) which said the date of my Mac needs to be set to somewhere older than October 2016 and now the air apps was opening and I could make BoscaCeoil run, but I wanted to make it more easy and not change date and stuff so I decided to build a dmg. 
 
 I used this command as provided by the AIRSDK (to know more about tinkering with AIRSDK [read here](https://help.adobe.com/en_US/air/build/index.html)
 
 I had trouble configuring the PATH variables to get the SDK up and running and used the following command to make the .dmg 

(using 
`adt -package -target native myApp.dmg myApp.air` 
)

But the final dmg had some similar date issues so I had to change the date back to an older one and get the .app file 
Now after I got the .app file it still said it couldn’t open so I knew the problem was due the signing of the certificates so I resigned them and changed the date of creating and modification and had to quarantine the AIR from apple to check its validity and used the following commands 


`cd /Library/Frameworks`
`sudo xattr -r -d com.apple.quarantine ./Adobe\ AIR.framework`
`ls -l@ ./Adobe\ AIR.framework/`


Now the app was running without any date related issues but required the installation of latest version of AIR and the following 3 commands to be executed after a semi-successful installation of AIR so I made a .command executable.

This whole process requires a few clicks and your password to be entered 2 times, however I’ll try to make it a single click process in the near future.

Catalina is known to cause many problems for many apps especially the AIR thing being broken this is the only way to resolve it for now.

