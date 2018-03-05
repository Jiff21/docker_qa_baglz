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

Run Behave Tests
```
behave path/to/features_folder
```

Run Locust Tests
```
locust --clients=50 --hatch-rate=1 --num-request=350 --no-web --host=http://example.com -f path/to/locustfile.py
```

Run using allure runner
In our instance using the behave runner.
```
behave -f allure_behave.formatter:AllureFormatter -o path/to/allure/allure_result_folder ./path/to/features_folder
```
