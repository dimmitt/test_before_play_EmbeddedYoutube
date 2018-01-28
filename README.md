## The purpose of this repository:
1) allow developers to show embed acceptable videos on their website
2) and never show blocked videos which display super ugly static. 

### Here are some of the links that we will be testing:
<pre>working video:    https://www.youtube.com/embed/durCuF6jb8k?rel=0&autoplay=1
err disabled:     https://www.youtube.com/embed/O0EXiT4nYQ0?rel=0&autoplay=1
err NBCU blocked: https://www.youtube.com/embed/nn4tP7ogWIA?rel=0&autoplay=1
err VIVO blocked: https://www.youtube.com/embed/p_IwENcMPOA?rel=0&autoplay=1

bonus: https://www.youtube.com/embed/?list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr&rel=0&autoplay=1
</pre>

# The tricky part of embedded youtube videos:
Even if you set the video to autoplay 
<br>the error message will be inside the embedded video and not in the HTML output from a curl request.

Upon checking network tab in dev tools you can find the request that has the information.
<br>But how can we get access to it with a curl command?

1) cmd opt i, to open dev tools
2) click network tab
3) refresh your browser
4) right click "get_video_info" network request
5) 
6) hover over "Copy"
7) select "Copy as cURL"
8) pasting this into the terminal was not very helpful to myself, <br>
  request: <pre>curl 'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0&cpn=EA-bHhHgNZitU2bm&eurl&el=embedded&hl=en_US&sts=17555&lact=8&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER&cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409&height=800&authuser=0&ei=xgtuWsGfE8-M8gSTpa9w&iframe=1' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9' -H 'x-youtube-client-version: 20180125' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36' -H 'x-chrome-uma-enabled: 1' -H 'accept: */*' -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0' -H 'x-youtube-client-name: 56' -H 'authority: www.youtube.com' -H 'cookie: HSID=A1cNSpElLFuAIz4u-; SSID=AF0D72G9-Y9yfe4i-; APISID=gOAezz65T1SbvbZY/AY7IeENUJ06_aI2s7; SAPISID=F9grmZuvfbxSO9jh/ASsUsC-NRS1kUWaxV; VISITOR_INFO1_LIVE=U0qF_xHZsMM; LOGIN_INFO=AICDL0QwRQIgTKE-Nl60qsJiO7M9LE-7sKg4PDqQAwzxvzkqcgkjKMoCIQCstCLmEbtCW8NyhU1-Pe1mXmiE8vJwIKS5UpZEMlxpYQ:QUpCWWozcmw0b2g5bzI0bGhkQ0k5a2I1TDQxdkp5LWdzUHZMVUx4aVJiMDlRZDNsNkFwUHF3aVgwaFFrNk04bmU5bHNIQUNWS1hjQmhVbV9CcUU2SGZtWlh3RFRJdEFpYU5IOFZNUkgwWVU1RTJVSEtLdzBZN21FQzcwTlNfX1M1UkdQTFRjLVY3ei1YTWxrVV9vRGtndDJ6QmRyWHdhV2xMSGJhZGw4YkYxdTlmU3RBV1k0NTJ3; SID=kwUYIPi23MSshmthATNtk_332Ji2GFwZ33HjaeXrfeJC7lA27yYsO3PWqFDQ6k6MHwsLXA.; _ga=GA1.2.508661757.1517088456; _gid=GA1.2.1456931995.1517088456; PREF=al=en&f5=30; YSC=Ze7qPkV2bYk; llbcs=0' -H 'x-client-data: CKu1yQEIhbbJAQijtskBCMS2yQEI+pzKAQipncoBCIafygEIqKPKAQ==' --compressed
</pre> response: <pre>???t,w????}G?=????1̱`??m?D<??Ǯw??B'?'7???u??@ł?Xs0n?X???k`?2?d?6?%?w??b`s?O[?????:BЁ???VP???>??G?B?????WIC^???
                                                                                                             V%~???4k;؀?rΝ?
                                                                                                                           qH?t\Z`?t??A?????A???A? </pre>
5) However, I see that the request has a referrer... 
6) let write a post to the get info url with a header using referer of the video I want the info regarding.<br>
<pre>curl -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0' 
  'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0&cpn=y96mZdNTBvQyTmG5&eurl&el=embedded&hl=en_US&sts=17555&lact=7&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER&cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409&height=800&authuser=0&ei=JApuWsu_OoiGgwPHw6boBQ&iframe=1'</pre>
 7) It works! but now we need to compare with other youtube videos to see what needs changing to get correct info every time.
# test_ifEmbedded_youtube_video_works_before_putting_one

### Here is a request. that works
`curl -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0' 'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0&cpn=y96mZdNTBvQyTmG5&eurl&el=embedded&hl=en_US&sts=17555&lact=7&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER&cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409&height=800&authuser=0&ei=JApuWsu_OoiGgwPHw6boBQ&iframe=1'`

### Here is that request formatted for readability:
<pre>
curl -H 'referer: https://www.youtube.com/embed/nn4tP7ogWIA'
https://www.youtube.com/get_video_info?
  html5=1&video_id=nn4tP7ogWIA&cpn=y96mZdNTBvQyTmG5&eurl&el=embedded&hl=en_US&
  sts=17555&lact=7&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER&
  cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409&
  height=800&authuser=0&ei=JApuWsu_OoiGgwPHw6boBQ&iframe=1
</pre>

### Alternative request formatted for readability:
<pre>
curl -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0'
https://www.youtube.com/get_video_info
  ?html5=1&video_id=O0EXiT4nYQ0&cpn=EA-bHhHgNZitU2bm&eurl&el=embedded&hl=en_US
  &sts=17555&lact=8&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER
  &cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409
  &height=800&authuser=0&ei=xgtuWsGfE8-M8gSTpa9w&iframe=1
</pre>

# Money Shot 💸 🤑 🤑

## Resultant Abstracted request for testing using my mac computer:
```bash
VIDEO=$1
curl -H 'referer: https://www.youtube.com/embed/$VIDEO'
https://www.youtube.com/get_video_info
  ?html5=1&video_id=$VIDEO&cpn=EA-bHhHgNZitU2bm&eurl&el=embedded&hl=en_US
  &sts=17555&lact=8&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER
  &cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409
  &height=800&authuser=0&ei=xgtuWsGfE8-M8gSTpa9w&iframe=1
```
