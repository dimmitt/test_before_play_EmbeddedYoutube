## The purpose of this repository:
1) allow developers to show embed acceptable videos on their website
2) and never show blocked videos which display super ugly static.

### Here are some of the links that we will be testing:
1) Put the below links in your browser's address bar to see the website output:
<pre>working video:    https://www.youtube.com/embed/durCuF6jb8k?rel=0&autoplay=1
err disabled:     https://www.youtube.com/embed/O0EXiT4nYQ0?rel=0&autoplay=1
err NBCU blocked: https://www.youtube.com/embed/nn4tP7ogWIA?rel=0&autoplay=1
err VIVO blocked: https://www.youtube.com/embed/p_IwENcMPOA?rel=0&autoplay=1

bonus ... PLAYLISTS!: https://www.youtube.com/embed/?list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr&rel=0&autoplay=1
</pre>

# The tricky part of embedded youtube videos:
Even if you set the video to autoplay
<br>the error message will be inside the embedded video and not in the HTML output from a curl request.

Upon checking network tab in dev tools you can find the request that has the information.
<br>But how can we get access to it with a curl command?

# How to trouble shoot the browser to solve the problem:
1) cmd opt i, to open dev tools
2) click network tab
3) refresh your browser
4) right click "get_video_info" network request
5) hover over "Copy"
6) select "Copy as cURL"
7) pasting this into the terminal was not very helpful to myself, <br/>
  <pre>request: curl 'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0&cpn=EA-bHhHgNZitU2bm&eurl&el=embedded&hl=en_US&sts=17555&lact=8&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER&cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409&height=800&authuser=0&ei=xgtuWsGfE8-M8gSTpa9w&iframe=1' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9' -H 'x-youtube-client-version: 20180125' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36' -H 'x-chrome-uma-enabled: 1' -H 'accept: */*' -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0' -H 'x-youtube-client-name: 56' -H 'authority: www.youtube.com' -H 'cookie: HSID=A1cNSpElLFuAIz4u-; SSID=AF0D72G9-Y9yfe4i-; APISID=gOAezz65T1SbvbZY/AY7IeENUJ06_aI2s7; SAPISID=F9grmZuvfbxSO9jh/ASsUsC-NRS1kUWaxV; VISITOR_INFO1_LIVE=U0qF_xHZsMM; LOGIN_INFO=AICDL0QwRQIgTKE-Nl60qsJiO7M9LE-7sKg4PDqQAwzxvzkqcgkjKMoCIQCstCLmEbtCW8NyhU1-Pe1mXmiE8vJwIKS5UpZEMlxpYQ:QUpCWWozcmw0b2g5bzI0bGhkQ0k5a2I1TDQxdkp5LWdzUHZMVUx4aVJiMDlRZDNsNkFwUHF3aVgwaFFrNk04bmU5bHNIQUNWS1hjQmhVbV9CcUU2SGZtWlh3RFRJdEFpYU5IOFZNUkgwWVU1RTJVSEtLdzBZN21FQzcwTlNfX1M1UkdQTFRjLVY3ei1YTWxrVV9vRGtndDJ6QmRyWHdhV2xMSGJhZGw4YkYxdTlmU3RBV1k0NTJ3; SID=kwUYIPi23MSshmthATNtk_332Ji2GFwZ33HjaeXrfeJC7lA27yYsO3PWqFDQ6k6MHwsLXA.; _ga=GA1.2.508661757.1517088456; _gid=GA1.2.1456931995.1517088456; PREF=al=en&f5=30; YSC=Ze7qPkV2bYk; llbcs=0' -H 'x-client-data: CKu1yQEIhbbJAQijtskBCMS2yQEI+pzKAQipncoBCIafygEIqKPKAQ==' --compressed
</pre> 

response: <pre>???t,w????}G?=????1̱`??m?D<??Ǯw??B'?'7???u??@ł?Xs0n?X???k`?2?d?6?%?w??b`s?O[?????:BЁ???VP???>??G?B?????WIC^???
t\Z`?t??A?????A???A? </pre>

8) Well that response is a bunch of junk. Reduce the curl command into smaller parts to see if the results are better. 
When you remove --compressed and other details the response will match the expected response:
request: <pre>curl 'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0'</pre>

10) It works! but now we need to compare with other youtube videos to see what needs changing to get correct info every time.
```bash
curl 'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0';
curl 'https://www.youtube.com/get_video_info?html5=1&video_id=nn4tP7ogWIA';

If a video has an error for embeded it shows an errorcode in the response. 🔥
```

11) Youtube does not enable CORS on their server for the get_video_info route.

12) Thankfully I can use a reverse proxy that I [built](https://github.com/MichaelDimmitt/public_express_api_proxy). An api that makes requests on the server side.
Thankfully my server is enabled to accept requests from another application running in a browser. 🆒

Update: referrer was not needed for this project.
<br/>~13) Looking deeper on the network tab of dev tools, the request uses a referrer...~
<br/>~14) lets write a post to the get info url with a header using referer of the video I want the info regarding.<br>~
<!--
curl -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0'
  'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0&cpn=y96mZdNTBvQyTmG5&eurl&el=embedded&hl=en_US&sts=17555&lact=7&c=WEB_EMBEDDED_PLAYER&cver=20180125&cplayer=UNIPLAYER&cbr=Chrome&cbrver=63.0.3239.132&cos=Macintosh&cosver=10_12_6&width=409&height=800&authuser=0&ei=JApuWsu_OoiGgwPHw6boBQ&iframe=1'

-->

# test_ifEmbedded_youtube_video_works_before_putting_one

### Here is a request that does not play as an embedded video
`curl -H 'referer: https://www.youtube.com/embed/O0EXiT4nYQ0' 'https://www.youtube.com/get_video_info?html5=1&video_id=O0EXiT4nYQ0'`

### Here is a request that does play an embedded video
`curl -H 'referer: https://www.youtube.com/embed/nn4tP7ogWIA' 'https://www.youtube.com/get_video_info?html5=1&video_id=nn4tP7ogWIA'`

# Money Shot 💸 🤑 🤑

## Resultant Abstracted request for testing using my mac computer:
```bash
checkVideo(){
  VIDEO=$1
  curl -H "referer: https://www.youtube.com/embed/$VIDEO" \
   "https://www.youtube.com/get_video_info?html5=1&video_id=$VIDEO"
}
checkVideo durCuF6jb8k
checkVideo O0EXiT4nYQ0
checkVideo nn4tP7ogWIA
checkVideo p_IwENcMPOA

```

bonus ... PLAYLISTS!: https://www.youtube.com/embed/?list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr&index=3&rel=0&autoplay=1

```bash
## paremeters to play the third video in a playlist
?list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr&index=3&rel=0&autoplay=1
```

Links related to playlists:
```bash
## returns a json object with all of the items in the list.
curl 'https://www.youtube.com/list_ajax?style=json&action_get_list=1&list=LLSCWFSK6rEm7Pg0yxD61pOA'

## uses the video_id grabbed from the current video index looking up the list_ajax result.
curl 'https://www.youtube.com/get_video_info?html5=1&video_id=ILVqgOlntLM'
```
```bash
## install jq for json parsing: 
brew install jq

## for video ?list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr&index=3&rel=0&autoplay=1
videoId=(curl -s 'https://www.youtube.com/list_ajax?style=json&action_get_list=1&list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr' | jq .video[3].encrypted_id)
echo $videoId ## output: "d86HgL1zU-E"
checkVideo $videoId
```

Woot, done. 😎
