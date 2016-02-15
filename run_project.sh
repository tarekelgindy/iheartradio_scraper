if [ "$1" = "" ]; then
	echo "Need to define a project name"
	exit	
fi
if [ "$2" = "" ]; then
	echo "Need to define a radio station"
	exit
fi
adjusted=`echo $2 | sed "s/-/_/g"` 
output="$adjusted_output_file.csv"
spider_location="$1"/"$1"/spiders/download_"$adjusted".py

if [ ! -d "$1/$1/spiders" ]; then
	echo "Folder structure for $1 not found - run start_project.sh"
	exit
fi

if [ ! -f "$spider_location" ]; then
	echo "Spider for $2 not found - creating it..."
	cd $1
	scrapy genspider "download_$adjusted" iheart.com
	cd $1/spiders
	touch "$output"
	cp ../../../template_spider.py .
	sed	 -i "s/TEMPLATE_NAME/download_$adjusted/g" template_spider.py
	sed -i "s/TEMPLATE_STATION/$2/g" template_spider.py
	sed -i "s/TEMPLATE_OUTPUT/$output/g" template_spider.py
	mv template_spider.py "download_$adjusted.py"
	scrapy crawl "download_$adjusted"
else
	cd "$1/$1/spiders"
	touch "$output"
	scrapy crawl "download_$adjusted"
fi
