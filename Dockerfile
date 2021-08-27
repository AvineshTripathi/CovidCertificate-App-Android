FROM gradle:7.0.2-jdk11

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
ENV ANDROID_BUILD_TOOLS_VERSION 30.0.1
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_VERSION 30
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/bin:${ANDROID_HOME}/platform-tools

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip

RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --update
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" 

RUN apt-get install -y checkinstall libwebp-dev libopenjp2-7-dev librsvg2-dev libde265-dev
RUN wget https://www.imagemagick.org/download/ImageMagick.tar.gz
RUN tar xzvf ImageMagick.tar.gz
RUN ./configure --enable-shared --with-modules --with-gslib
RUN make
RUN make install
RUN ldconfig /usr/local/lib
RUN identify -version
RUN magick -version
