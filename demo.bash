checkVideo(){
  VIDEO=$1
  curl -H "referer: https://www.youtube.com/embed/$VIDEO" \
   "https://www.youtube.com/get_video_info?html5=1&video_id=$VIDEO"
}
checkVideo durCuF6jb8k
checkVideo O0EXiT4nYQ0
checkVideo nn4tP7ogWIA
checkVideo p_IwENcMPOA

## install jq for json parsing: 
brew install jq

## for video ?list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr&index=3&rel=0&autoplay=1
videoId=$(curl -s 'https://www.youtube.com/list_ajax?style=json&action_get_list=1&list=PLOcTEsKp5qpV7pbtiGeLAjlmD086bqymr' | jq .video[3].encrypted_id | xargs)
echo $videoId ## output: "d86HgL1zU-E"
checkVideo $videoId
