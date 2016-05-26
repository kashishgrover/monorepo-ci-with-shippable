FROM node:argon

#Create the app directory
RUN mkdir -p /usr/src/app1
WORKDIR /usr/src/app1

#bundle app source
COPY . /usr/src/app1

#expose the port used by server.js
EXPOSE 8081

CMD [ "npm", "start" ]
