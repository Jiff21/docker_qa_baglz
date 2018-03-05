A base docker image. Built off Python with Selenium JAR (Hubs & Nodes), Chrome, Firefox, and installed. Also includes python installs for Behave, Allure, Locustio, Galen Framework and Zap (Baglz stack).  


Pass in Commands:

Start a Selenium Hub
```
java -Dwebdriver.chrome.driver=/usr/bin/chromedriver -jar /usr/bin/selenium.jar  -role hub
```
Start a Selenium Node
```
java -Dwebdriver.chrome.driver=/usr/bin/chromedriver -jar /usr/bin/selenium.jar  -role node -nodeConfig /usr/nodeconfig.json
```
