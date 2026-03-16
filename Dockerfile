FROM nginx:alpine
COPY ./assets/ /usr/share/nginx/html/assets/
COPY ./undefined/images/ /usr/share/nginx/html/undefined/images/
COPY ./index.html /usr/share/nginx/html
COPY ./vite.svg /usr/share/nginx/html
EXPOSE 801
CMD ["nginx", "-g", "daemon off;"]