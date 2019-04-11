echo $(pwd) $(date "+%F %T")
cd /.any/_wallpaper/bing
export http_proxy="10.227.8.122:31281"
requestURL="http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt＝zh-cn"
response=$(curl -s $requestURL)
imageBaseURL=$(echo $response | grep -Po '"url":".*?"' | awk -F'["]' '{print $4}')
echo $imageBaseURL
imageName=$(echo $response | grep -Po '"url":".*?jpg' | sed 's/.*=//g')
finalBaseURL=$(echo "http://www.bing.com/")$(echo $imageBaseURL)
echo $finalBaseURL
wget -q $finalBaseURL --output-document=$imageName 
echo $(pwd) $(date "+%F %T")
echo "\n\n\n"
