---
id: 1206
title: 'How to compile and use Facebook Research’s Craftassist'
date: 2019-09-15T10:48:04+10:00
author: SteveTech
layout: post
guid: https://jas-team.net/?p=1206
permalink: /2019/09/15/compile-and-use-facebook-researchs-craftassist/
onesignal_meta_box_present:
  - "1"
  - "1"
onesignal_send_notification:
  - ""
  - ""
uuid:
  - 72715951-71dd-be6d-b1fc-ab5ba458ded7
  - 72715951-71dd-be6d-b1fc-ab5ba458ded7
response_body:
  - '{"id":"464514a5-8250-4d9b-ba62-dab7490cf79f","recipients":105,"external_id":"72715951-71dd-be6d-b1fc-ab5ba458ded7","warnings":["You must configure iOS notifications in your OneSignal settings if you wish to send messages to iOS users."]}'
  - '{"id":"464514a5-8250-4d9b-ba62-dab7490cf79f","recipients":105,"external_id":"72715951-71dd-be6d-b1fc-ab5ba458ded7","warnings":["You must configure iOS notifications in your OneSignal settings if you wish to send messages to iOS users."]}'
status:
  - "200"
  - "200"
recipients:
  - "105"
  - "105"
notification_id:
  - 464514a5-8250-4d9b-ba62-dab7490cf79f
  - 464514a5-8250-4d9b-ba62-dab7490cf79f
ampforwp_custom_content_editor:
  - ""
  - ""
ampforwp_custom_content_editor_checkbox:
  - ""
  - ""
ampforwp-amp-on-off:
  - default
  - default
amp-cf7-form-checker:
  - "1"
categories:
  - Standard News
  - Tutorials
---
**UPDATE:** These instructions are likely out-dated, and Facebook has made the instructions on their [GitHub](https://github.com/facebookresearch/craftassist) easier as well, please follow those before attempting mine.

Facebook Research set out to create a virtual assistant bot in Minecraft and since I made this video on Reddit people have asked how to set it up, and because Facebook’s instructions on their [GitHub](https://github.com/facebookresearch/craftassist) aren’t the best I decided to write my own.

<blockquote class="reddit-card" >
  <p>
    <a href="https://www.reddit.com/r/Minecraft/comments/cy87su/just_testing_with_facebooks_minecraft_ai/?ref_source=embed&ref=share">Just testing with Facebook’s Minecraft AI</a> from <a href="https://www.reddit.com/r/Minecraft/">Minecraft</a>
  </p>
</blockquote>



  1. Make sure to have some sort of a virtual Linux distro, I’m using WSL Ubuntu from the windows store. 
      * You can follow [this guide from Microsoft](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or [this guide from Ubuntu](https://wiki.ubuntu.com/WSL) for setting up WSL Ubuntu
  2. Clone the GitHub repo so type &#8220;`git clone --recursive https://github.com/facebookresearch/craftassist.git`&#8221; into Ubuntu
  3. Update Ubuntu’s packages, &#8220;`sudo apt-get update && sudo apt-get upgrade`&#8220;
  4. Install all the right dependencies to compile, &#8220;`sudo apt-get install cmake python3 python3-pip libgoogle-glog-dev libboost-all-dev libeigen3-dev gcc screen`&#8220;
  5. Install all the right dependencies for python to run the code, &#8220;`pip3 install numpy sentry_sdk torch scipy word2number snowballstemmer python-Levenshtein ipdb spacy`&#8220;
  6. Change the current directory to craftassist, &#8220;`cd craftassist`&#8220;
  7. Compile everything, &#8220;`make`&#8220;
  8. Start the server &#8220;`screen python3 ./python/cuberite_process.py`&#8221; then detach from the screen session by pressing ‘<kbd>Ctrl + A</kbd>‘ and ‘<kbd>Ctrl + D</kbd>‘ 
      * You can list the screen sessions by typing &#8220;`screen -list`&#8220;
      * You can resume a screen session by typing &#8220;`screen -r [session number]`&#8220;
  9. Change the version of Minecraft to 1.12.x by following [this guide](https://help.mojang.com/customer/portal/articles/1475923-changing-game-versions)
 10. Connect to your server by clicking in the Minecraft client `Multiplayer > Direct Connect > localhost:25565`
 11. Start the assistant &#8220;`screen python3 ./python/craftassist/craftassist_agent.py`&#8221; 
      * The assistant should join the game and you can ask it to do random things.