#!/bin/bash
gitee_proxy_ip=10.227.8.122
gitee_proxy_port=31281

cd /foo/oliver/workcode
echo $(pwd) $(date "+%F %T")
echo ">>>>>>>>>>> svn update begin"
svn cleanup --username=peikai --password=peikai /foo/oliver/workcode/cas/CAS/trunk
svn update --username=peikai --password=peikai /foo/oliver/workcode/cas/CAS/trunk

svn cleanup --username=peikai --password=peikai /foo/oliver/workcode/cas/CAS/branches/prod
svn update --username=peikai --password=peikai /foo/oliver/workcode/cas/CAS/branches/prod

svn cleanup --username=peikai --password=peikai /foo/oliver/workcode/b2c/B2C/trunk
svn update --username=peikai --password=peikai /foo/oliver/workcode/b2c/B2C/trunk

svn cleanup --username=peikai --password=peikai /foo/oliver/workcode/ibs/trunk
svn update --username=peikai --password=peikai /foo/oliver/workcode/ibs/trunk
echo "<<<<<<<<<<< svn update end!"
echo $(date "+%F %T")
cd /foo/oliver/workcode/cas
echo $(pwd) $(date "+%F %T")
echo ">>>>>>>>>>>git push cas begin"
git add .
git commit -m "cron-task-git-sync at $(date "+%F %T")"
urlstatus=$(curl -s -m 5 -IL https://gitee.com|grep 200)
if [ "$urlstatus" = "" ];then
	echo "gitee access FAIL, try proxy"
        urlstatus_by_proxy=$(curl -s -m 30 -IL -x http://$gitee_proxy_ip:$gitee_proxy_port https://gitee.com|grep 200)
	if [ "$urlstatus_by_proxy" = "" ];then
		echo "proxy http://$gitee_proxy_ip:$gitee_proxy_port fail"
	else
                git config http.proxy http://$gitee_proxy_ip:$gitee_proxy_port
                git push -u gitee master
                #git config --unset http.proxy
                git config --remove-section http
                git config --remove-section https

	fi
else
	echo "gitee access OK"
	git push -u gitee master
fi
echo "<<<<<<<<<<<git push cas end"
echo $(date "+%F %T")
echo " "
