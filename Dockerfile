FROM node:argon

#Create the app directory
RUN mkdir -p /usr/src/samplenodejstwoapps
WORKDIR /usr/src/samplenodejstwoapps

#bundle app source
COPY . /usr/src/samplenodejstwoapps

CMD [ "npm", "start" ]
