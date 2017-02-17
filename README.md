# Upside Down Application Automation
## CfgMgmtCamp '17
Ian Henry
Habitat Technical Community Advocate

This repo contains all of the code to build the multi-tier application that I ran my CfgMgmtCamp 2017 presentation on!
The web app portion is a [fork of work](www.github.com/choose-your-own-adventure-presentations) done by [mattmakai](https://github.com/mattmakai) that I've tweaked a bit, and updated to be packaged and run under Habitat.

Matt also wrote a [kickass multi-part blog post](https://www.twilio.com/blog/2014/11/choose-your-own-adventure-presentations-with-reveal-js-python-and-websockets.html) about the thing he built.

The general idea here is that with this repo, you can quite easily turn up your own presentations like this with little to no effort using Habitat packages!

## Requirements
A quick breakdown of requirements to build the stack:

1. [Habitat >= v0.17.0](https://habitat.sh/docs/get-habitat)
2. [Docker](www.docker.com)
3. A [Twilio](https://www.twilio.com) Account
4. An [Ngrok](https://ngrok.io) Account

## Getting Started
Once you have Docker and Habitat v 0.17.0 or greater installed on your workstation you should be ready to go. To get started
lets go ahead and clone this repo down to your machine

```
$ git clone https://github.com/eeyun/cyoa
```
From the root of the repo we're going to enter the studio and build a few things.
In the future I might publish these packages up to the depot to cut down on things. But if you're new to Habitat then this should be a nice easy exercise for you to see how things all work together.
```
$ cd cyoa
$ hab studio enter
[1][default:/src:0]# hab pkg install core/postgresql/9.5.3
[2][default:/src:0]# hab pkg install core/redis
[3][default:/src:0]# build plans/cyoa
[4][default:/src:0]# build plans/ngrok
```
Ok so that should give us everything we should need to make our docker containers.
```
[5][default:/src:0]# hab pkg export docker core/postgresql/9.5.3
[6][default:/src:0]# hab pkg export docker core/redis
[7][default:/src:0]# hab pkg export docker yourorigin/ngrok
[8][default:/src:0]# hab pkg export docker yourorigin/cyoa
[9][default:/src:0]# exit
```
Now each of these images should be available from docker. You can check with a simple command
```
$ sudo docker images
```
Verify that each of your expected images exist there. If so we can move on. If not, come ask me for help in slack.habitat.sh!

With the images in place we now need to update our docker-compose.yml file and there are a few specific values that youll need to update which are specifically the environment variables that we pass to our containers at runtime.
```
twilio={sid='inputtwiliosidhere',token='inputtwiliotokenhere',number='+1XXXXXXXXXX'}
ngrok={port='5001',host="cyoa",authtoken='ngrokauthtokenshouldgetinsertedhere',subdomain='yoursubdomain'}
```
Once you've updated these values with the information from your specific accounts we should be ready to turn the stack up. This will be a two-step process as the supervisor for redis has been told to expect more than a single container to exist in the cluster.
```
$ sudo docker-compose up
```
This should give you oodles of output but should more or less stop and wait after around 10-20 seconds. At this point the stack functions except for voting, which is handled by the redis caching layer. So lets scale out redis.
```
$ sudo docker-compose scale redis=3
```

And that should be all it takes! You should now have a 6 node cluster across 4 different services all talking and working together. From a browser you should be able to hit `localhost:5001/wizard` for the login page. `Username: hab, Password: hab`

As the web app supports multiple presentations you'll want to click `New Presentation` to add the CfgMgmtCamp '17 deck to the app. I've included it in the repo under `/slides` but the application should automatically mount that directory for use with the slide deck.
```
Presentation Name
App Automation with Habitat

File name
cmcamp17.html

URL Slug
cmcamp17
```
Make sure you also check the `is Visible` box before clicking `save`!
Returning to `localhost:5001` should now present you with a link to my presentation! Of course you can always look through the html as it is a reveal.js presentation.

## License

Copyright (c) 2016-2017 Ian Henry and/or applicable contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
