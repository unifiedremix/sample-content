FROM alpine:3.4

# install
RUN apk --update add apache2 \
 && rm -f /var/cache/apk/* 

# configure
RUN mkdir -p /run/apache2 \
 && ln -s /dev/stderr /var/log/apache2/error.log \
 && ln -s /dev/stdout /var/log/apache2/access.log \
 && mkdir -p /var/www/sample-content

# download tears of steel
RUN cd /var/www/sample-content \
 && wget http://repository.unified-streaming.com/tears-of-steel-1.7.31.zip \
 && mkdir tears \
 && unzip tears-of-steel-1.7.31.zip -d tears \
 && mv tears/video/tears-of-steel/tears-of-steel-dref.mp4 . \
 && mv tears/video/tears-of-steel/tears-of-steel-64k.isma . \
 && mv tears/video/tears-of-steel/tears-of-steel-128k.isma . \
 && mv tears/video/tears-of-steel/tears-of-steel-400k.ismv . \
 && mv tears/video/tears-of-steel/tears-of-steel-800k.ismv . \
 && mv tears/video/tears-of-steel/tears-of-steel-1200k.ismv . \
 && rm -rf tears-of-steel-1.7.31.zip tears/


COPY sample-content.conf.in /etc/apache2/conf.d/sample-content.conf.in
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# copy logo video
COPY content/logo_5s_720x406.mp4 /var/www/sample-content/logo_5s_720x406.mp4
COPY content/logo_5s_568x320.mp4 /var/www/sample-content/logo_5s_568x320.mp4
COPY content/logo_5s_420x236.mp4 /var/www/sample-content/logo_5s_420x236.mp4
COPY content/logo_5s_audio.mp4 /var/www/sample-content/logo_5s_audio.mp4
COPY content/logo_5s_dref.mp4 /var/www/sample-content/logo_5s_dref.mp4

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["httpd", "-DFOREGROUND"]
