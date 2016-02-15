if [ "$1" = "" ]; then
	echo "Need to define a project name"
	exit	
fi
if [ "$2" = "" ]; then
	echo "Need to define a radio station"
	exit
fi
adjusted=`echo $2 | sed "s/-/_/g"` 
output="$adjusted"_output_file.csv
if [ ! -f "template_spider.py" ]; then
	echo "Missing the template python files in this launch directory"
	exit
fi

if [ -d "$1" ]; then
	echo "Folder structure for $1 already exists. Exiting..."
	exit
fi

echo "Starting project " $1
scrapy startproject $1
cd $1
scrapy genspider download_"$adjusted" iheart.com
cd $1
#I'm being lazy by not requiring the full settings file to be in the launch folder - just append the settings file with nessisary updates intead
(printf "DOWNLOAD_HANDLERS = {'s3':None}") >> settings.py
head -n -1 items.py > delete_me;
mv delete_me items.py
(printf "\n\t%s\n\t%s\n\t%s" 'title = scrapy.Field()' 'link=scrapy.Field()' 'desc=scrapy.Field()') >> items.py
cd spiders
touch "$output"
cp ../../../template_spider.py .
sed -i "s/TEMPLATE_NAME/download_$adjusted/g" template_spider.py
sed -i "s/TEMPLATE_STATION/$2/g" template_spider.py
sed -i "s/TEMPLATE_OUTPUT/$output/g" template_spider.py
mv template_spider.py "download_$adjusted.py"
scrapy crawl "download_$adjusted"
