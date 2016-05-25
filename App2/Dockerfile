FROM node:argon

#Create the app directory
RUN mkdir -p /usr/src/app2
WORKDIR /usr/src/app2

#bundle app source
COPY . /usr/src/app2

CMD [ "npm", "start" ]
