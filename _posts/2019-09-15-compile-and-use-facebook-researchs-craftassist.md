---
layout: post
title: 'How to compile and use Facebook Research’s Craftassist'
date: 2019-09-15T10:48:04+10:00
---
**UPDATE:** These instructions are likely out-dated, and Facebook has made the instructions on their [GitHub](https://github.com/facebookresearch/craftassist) easier as well, please follow those before attempting mine.

Facebook Research set out to create a virtual assistant bot in Minecraft and since I made this video on Reddit people have asked how to set it up, and because Facebook’s instructions on their [GitHub](https://github.com/facebookresearch/craftassist) aren’t the best I decided to write my own.<!--more-->

<blockquote class="reddit-card" >
  <p>
    <a href="https://www.reddit.com/r/Minecraft/comments/cy87su/just_testing_with_facebooks_minecraft_ai/?ref_source=embed&ref=share">Just testing with Facebook’s Minecraft AI</a> from <a href="https://www.reddit.com/r/Minecraft/">Minecraft</a>
  </p>
</blockquote>



  1. Make sure to have some sort of a virtual Linux distro, I’m using WSL Ubuntu from the windows store. 
      * You can follow [this guide from Microsoft](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or [this guide from Ubuntu](https://wiki.ubuntu.com/WSL) for setting up WSL Ubuntu
  2. Clone the GitHub repo so type &ldquo;`git clone --recursive https://github.com/facebookresearch/craftassist.git`&rdquo; into Ubuntu
  3. Update Ubuntu’s packages, &ldquo;`sudo apt-get update && sudo apt-get upgrade`&ldquo;
  4. Install all the right dependencies to compile, &ldquo;`sudo apt-get install cmake python3 python3-pip libgoogle-glog-dev libboost-all-dev libeigen3-dev gcc screen`&ldquo;
  5. Install all the right dependencies for python to run the code, &ldquo;`pip3 install numpy sentry_sdk torch scipy word2number snowballstemmer python-Levenshtein ipdb spacy`&ldquo;
  6. Change the current directory to craftassist, &ldquo;`cd craftassist`&ldquo;
  7. Compile everything, &ldquo;`make`&ldquo;
  8. Start the server &ldquo;`screen python3 ./python/cuberite_process.py`&rdquo; then detach from the screen session by pressing ‘<kbd>Ctrl + A</kbd>‘ and ‘<kbd>Ctrl + D</kbd>‘ 
      * You can list the screen sessions by typing &ldquo;`screen -list`&ldquo;
      * You can resume a screen session by typing &ldquo;`screen -r [session number]`&ldquo;
  9. Change the version of Minecraft to 1.12.x by following [this guide](https://help.mojang.com/customer/portal/articles/1475923-changing-game-versions)
 10. Connect to your server by clicking in the Minecraft client `Multiplayer > Direct Connect > localhost:25565`
 11. Start the assistant &ldquo;`screen python3 ./python/craftassist/craftassist_agent.py`&rdquo; 
      * The assistant should join the game and you can ask it to do random things.