# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import scrapy
from time import sleep
import csv
import os

class RunSpider(scrapy.Spider):
    name = "TEMPLATE_NAME"
    allowed_domains = ["iheart.com"]
    start_urls = ['http://www.iheart.com/live/TEMPLATE_STATION']


    def __init__(self):
        self.driver = webdriver.Firefox()

    def parse(self, response):
        file_name="TEMPLATE_OUTPUT"
        input_dic={}
        song_count={}
        if not os.path.isfile(file_name):
            open(file_name,'a')

        with open(file_name,mode="r") as infile:
            reader=csv.reader(infile)
            input_dic=dict(reader)
            print input_dic
            song_count=input_dic
###        self.driver.get(response.url)
        current_song=""
        try:
###            song = WebDriverWait(self.driver, 40).until(EC.presence_of_element_located((By.CLASS_NAME, "player-song")))
###            print song.text
###            artist=WebDriverWait(self.driver, 40).until(EC.presence_of_element_located((By.CLASS_NAME, "player-artist type-secondary type-xsmall")))
###            print artist.text
            self.driver.implicitly_wait(60)
            self.driver.get(response.url)
            while(True):
                song=self.driver.find_element_by_class_name("station-now-playing")
                print song.text
                artist=self.driver.find_element_by_class_name("station-now-playing-artist")
                print artist.text
                combined=song.text+" --- "+ artist.text
    
    
                if combined!=current_song:
    
                    if combined in song_count:
                        song_count[combined]=int(song_count[combined])+1

                    else:
                        song_count[combined]=1

                    with open(file_name,mode='w') as outfile:
                        writer=csv.writer(outfile)
                        for k,v in song_count.items():
                            writer.writerow([unicode(k).encode("utf-8"),v])

                    print song_count
                else:
                    print "same song"
                current_song=combined
                sleep(60)



        finally:
            self.driver.close()

